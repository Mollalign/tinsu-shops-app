import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tinsu_shops/core/errors/app_error.dart';
import 'package:tinsu_shops/core/network/api_client.dart';
import 'package:tinsu_shops/core/widgets/components.dart';
import 'package:tinsu_shops/features/products/data/product_image_io.dart';
import 'package:tinsu_shops/features/products/data/products_repository.dart';
import 'package:tinsu_shops/features/products/domain/product_model.dart';
import 'package:tinsu_shops/features/products/presentation/widgets/product_image_picker.dart';
import 'package:tinsu_shops/l10n/app_localizations.dart';

// 1×1 PNG
final Uint8List _pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Map<String, dynamic> _productJson({String? photoUrl}) => {
      'id': 'prod-001',
      'shop_id': 'shop-001',
      'name': 'Coca-Cola',
      'photo_url': photoUrl,
      'selling_price': 35,
      'stock_quantity': 50,
      'low_stock_threshold': 5,
      'category_id': null,
      'category_name': null,
      'is_active': true,
    };

ProductModel _product({String? photoUrl}) => ProductModel.fromJson(
      _productJson(photoUrl: photoUrl),
    );

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;
  dynamic lastData;
  int statusCode;
  String body;
  DioException? throwError;

  _RecordingAdapter({this.statusCode = 200, this.body = '{}'});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    lastData = options.data;
    if (throwError != null) throw throwError!;
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ProductImagePicker.skipFileImageDecode = true;
  ProductNetworkImage.skipNetworkLoad = true;

  group('ProductModel photo_url', () {
    test('maps photo_url to photoUrl', () {
      final p = ProductModel.fromJson(_productJson(photoUrl: 'https://cdn/x.jpg'));
      expect(p.photoUrl, 'https://cdn/x.jpg');
      expect(p.toJson()['photo_url'], 'https://cdn/x.jpg');
      expect(p.toJson().containsKey('photoUrl'), isFalse);
    });

    test('null photo_url does not throw', () {
      final p = ProductModel.fromJson(_productJson());
      expect(p.photoUrl, isNull);
    });
  });

  group('ProductImageSelection', () {
    test('empty state', () {
      const sel = ProductImageSelection();
      expect(sel.hasNewImage, isFalse);
      expect(sel.hasExisting, isFalse);
      expect(sel.shouldClearRemote, isFalse);
      expect(sel.hasPreview, isFalse);
    });

    test('existing image', () {
      const sel = ProductImageSelection(existingUrl: 'https://cdn/x.jpg');
      expect(sel.hasExisting, isTrue);
      expect(sel.hasPreview, isTrue);
      expect(sel.shouldClearRemote, isFalse);
    });

    test('removed existing image', () {
      const sel = ProductImageSelection(
        existingUrl: 'https://cdn/x.jpg',
        removed: true,
      );
      expect(sel.hasExisting, isFalse);
      expect(sel.shouldClearRemote, isTrue);
      expect(sel.hasPreview, isFalse);
    });

    test('new local image replaces existing', () {
      final file = File('/tmp/fake.jpg');
      final sel = ProductImageSelection(
        localFile: file,
        existingUrl: 'https://cdn/x.jpg',
      );
      expect(sel.hasNewImage, isTrue);
      expect(sel.hasExisting, isFalse);
      expect(sel.shouldClearRemote, isFalse);
    });
  });

  group('ProductImagePicker', () {
    testWidgets('empty state shows take photo and gallery', (tester) async {
      await tester.pumpWidget(_wrap(const ProductImagePicker()));
      expect(find.text('Product Image'), findsOneWidget);
      expect(find.byKey(const Key('product-image-take-photo')), findsOneWidget);
      expect(find.byKey(const Key('product-image-choose-gallery')), findsOneWidget);
      expect(find.byKey(const Key('product-image-remove')), findsNothing);
    });

    testWidgets('existing image shows change and remove', (tester) async {
      await tester.pumpWidget(
        _wrap(const ProductImagePicker(existingUrl: 'https://example.com/p.png')),
      );
      expect(find.byKey(const Key('product-image-change')), findsOneWidget);
      expect(find.byKey(const Key('product-image-remove')), findsOneWidget);
      expect(find.byKey(const Key('product-image-take-photo')), findsNothing);
    });

    testWidgets('selecting an image shows local preview', (tester) async {
      final fake = File('${Directory.systemTemp.path}/tinsu_fake_preview.jpg');
      final imageKey = GlobalKey<ProductImagePickerState>();
      await tester.pumpWidget(
        _wrap(
          ProductImagePicker(
            key: imageKey,
            pickImage: (_) async => fake,
          ),
        ),
      );
      expect(imageKey.currentState, isNotNull);
      await imageKey.currentState!.pick(ImageSource.gallery);
      expect(imageKey.currentState!.selection.hasNewImage, isTrue);
      await tester.pump();
      expect(find.byKey(const Key('product-image-local-preview')), findsOneWidget);
      expect(find.byKey(const Key('product-image-change')), findsOneWidget);
    });

    testWidgets('permission denial shows friendly message', (tester) async {
      final imageKey = GlobalKey<ProductImagePickerState>();
      await tester.pumpWidget(
        _wrap(
          ProductImagePicker(
            key: imageKey,
            pickImage: (_) async {
              throw const ImagePickFailed(permissionDenied: true);
            },
          ),
        ),
      );
      await imageKey.currentState!.pick(ImageSource.camera);
      await tester.pump();
      expect(find.byKey(const Key('product-image-error')), findsOneWidget);
      expect(
        find.textContaining('Photo permission was denied'),
        findsOneWidget,
      );
    });

    testWidgets('picker failure shows friendly message', (tester) async {
      final imageKey = GlobalKey<ProductImagePickerState>();
      await tester.pumpWidget(
        _wrap(
          ProductImagePicker(
            key: imageKey,
            pickImage: (_) async => throw const ImagePickFailed(),
          ),
        ),
      );
      await imageKey.currentState!.pick(ImageSource.gallery);
      await tester.pump();
      expect(find.text("Couldn't select the image."), findsOneWidget);
    });

    testWidgets('remove image returns to empty actions', (tester) async {
      final imageKey = GlobalKey<ProductImagePickerState>();
      await tester.pumpWidget(
        _wrap(
          ProductImagePicker(
            key: imageKey,
            existingUrl: 'https://example.com/p.png',
          ),
        ),
      );
      imageKey.currentState!.removeImage();
      await tester.pump();
      expect(find.byKey(const Key('product-image-take-photo')), findsOneWidget);
      expect(find.byKey(const Key('product-image-remove')), findsNothing);
      expect(imageKey.currentState!.selection.shouldClearRemote, isTrue);
    });

    testWidgets('uploading shows progress overlay', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ProductImagePicker(
            existingUrl: 'https://example.com/p.png',
            uploading: true,
          ),
        ),
      );
      expect(find.byKey(const Key('product-image-uploading')), findsOneWidget);
    });

    testWidgets('selected image survives parent rebuild', (tester) async {
      final fake = File('${Directory.systemTemp.path}/tinsu_fake_rebuild.jpg');
      final imageKey = GlobalKey<ProductImagePickerState>();
      await tester.pumpWidget(
        _wrap(
          ProductImagePicker(
            key: imageKey,
            pickImage: (_) async => fake,
          ),
        ),
      );
      await imageKey.currentState!.pick(ImageSource.camera);
      expect(imageKey.currentState!.selection.hasNewImage, isTrue);

      await tester.pumpWidget(
        _wrap(
          ProductImagePicker(
            key: imageKey,
            pickImage: (_) async => fake,
          ),
        ),
      );
      expect(imageKey.currentState!.selection.hasNewImage, isTrue);
      expect(find.byKey(const Key('product-image-local-preview')), findsOneWidget);
    });
  });

  group('Product image rendering', () {
    testWidgets('null image shows placeholder on product card', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 180,
            height: 240,
            child: ProductCard(product: _product()),
          ),
        ),
      );
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('broken URL does not crash', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 80,
            height: 80,
            child: ProductNetworkImage(url: 'http://127.0.0.1:1/missing.png'),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });
  });

  group('ProductsRepository image payloads', () {
    late Dio dio;
    late _RecordingAdapter adapter;
    late ProductsRepository repo;

    setUp(() {
      adapter = _RecordingAdapter(
        statusCode: 201,
        body: jsonEncode(_productJson()),
      );
      dio = Dio(BaseOptions(baseUrl: 'http://test'));
      dio.httpClientAdapter = adapter;
      repo = ProductsRepository(dio: dio);
    });

    test('create without image omits photo_url', () async {
      await repo.createProduct(
        shopId: 'shop-001',
        name: 'Coca-Cola',
        sellingPrice: 35,
        initialStock: 50,
      );
      final data = adapter.lastData as Map;
      expect(data.containsKey('photo_url'), isFalse);
      expect(data['name'], 'Coca-Cola');
    });

    test('create with image sends photo_url', () async {
      adapter.body = jsonEncode(_productJson(photoUrl: 'http://test/media/x.png'));
      await repo.createProduct(
        shopId: 'shop-001',
        name: 'Coca-Cola',
        sellingPrice: 35,
        initialStock: 50,
        photoUrl: 'http://test/media/x.png',
      );
      final data = adapter.lastData as Map;
      expect(data['photo_url'], 'http://test/media/x.png');
    });

    test('update can clear photo_url', () async {
      adapter.statusCode = 200;
      adapter.body = jsonEncode(_productJson());
      await repo.updateProduct(
        shopId: 'shop-001',
        productId: 'prod-001',
        photoUrl: null,
      );
      final data = adapter.lastData as Map;
      expect(data.containsKey('photo_url'), isTrue);
      expect(data['photo_url'], isNull);
    });

    test('update omits photo_url when unchanged', () async {
      adapter.statusCode = 200;
      adapter.body = jsonEncode(_productJson(photoUrl: 'http://old.png'));
      await repo.updateProduct(
        shopId: 'shop-001',
        productId: 'prod-001',
        name: 'Coca-Cola',
      );
      final data = adapter.lastData as Map;
      expect(data.containsKey('photo_url'), isFalse);
    });

    test('upload posts multipart file and reads url', () async {
      final tmp = File(
        '${Directory.systemTemp.path}/tinsu_up_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tmp.writeAsBytes(_pngBytes);
      addTearDown(() {
        if (tmp.existsSync()) tmp.deleteSync();
      });

      adapter.statusCode = 201;
      adapter.body = jsonEncode({'url': 'http://test/media/products/x.png'});
      final url = await repo.uploadProductImage(
        shopId: 'shop-001',
        filePath: tmp.path,
      );
      expect(url, 'http://test/media/products/x.png');
      expect(adapter.lastOptions!.path, contains('/uploads/images'));
      expect(adapter.lastData, isA<FormData>());
    });

    test('upload maps network failure to AppError', () async {
      final tmp = File(
        '${Directory.systemTemp.path}/tinsu_fail_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tmp.writeAsBytes(_pngBytes);
      addTearDown(() {
        if (tmp.existsSync()) tmp.deleteSync();
      });
      adapter.throwError = DioException(
        requestOptions: RequestOptions(path: '/uploads/images'),
        type: DioExceptionType.connectionTimeout,
        error: const NetworkError(),
      );
      expect(
        () => repo.uploadProductImage(shopId: 'shop-001', filePath: tmp.path),
        throwsA(isA<AppError>()),
      );
    });
  });

  group('upload error mapping', () {
    test('extractError never exposes DioException text', () {
      final err = extractError(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          error: const NetworkError(),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(err, isA<NetworkError>());
      expect(err.toString().contains('DioException'), isFalse);
    });
  });
}
