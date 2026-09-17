// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

// ─── StockAnalyticsDataPoint ──────────────────────────────────────────────────

/// @nodoc
mixin _$StockAnalyticsDataPoint {
  String get date; int get restockedUnits; int get soldUnits;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StockAnalyticsDataPointCopyWith<StockAnalyticsDataPoint> get copyWith =>
      _$StockAnalyticsDataPointCopyWithImpl<StockAnalyticsDataPoint>(
          this as StockAnalyticsDataPoint, _$identity);
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StockAnalyticsDataPoint &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.restockedUnits, restockedUnits) ||
                other.restockedUnits == restockedUnits) &&
            (identical(other.soldUnits, soldUnits) ||
                other.soldUnits == soldUnits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, restockedUnits, soldUnits);

  @override
  String toString() =>
      'StockAnalyticsDataPoint(date: $date, restockedUnits: $restockedUnits, soldUnits: $soldUnits)';
}

/// @nodoc
abstract mixin class $StockAnalyticsDataPointCopyWith<$Res> {
  factory $StockAnalyticsDataPointCopyWith(StockAnalyticsDataPoint value,
          $Res Function(StockAnalyticsDataPoint) _then) =
      _$StockAnalyticsDataPointCopyWithImpl;
  @useResult
  $Res call({String date, int restockedUnits, int soldUnits});
}

/// @nodoc
class _$StockAnalyticsDataPointCopyWithImpl<$Res>
    implements $StockAnalyticsDataPointCopyWith<$Res> {
  _$StockAnalyticsDataPointCopyWithImpl(this._self, this._then);
  final StockAnalyticsDataPoint _self;
  final $Res Function(StockAnalyticsDataPoint) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? restockedUnits = null, Object? soldUnits = null}) {
    return _then(_self.copyWith(
      date: null == date ? _self.date : date as String,
      restockedUnits: null == restockedUnits ? _self.restockedUnits : restockedUnits as int,
      soldUnits: null == soldUnits ? _self.soldUnits : soldUnits as int,
    ));
  }
}

/// @nodoc
@JsonSerializable(fieldRename: FieldRename.snake)
class _StockAnalyticsDataPoint implements StockAnalyticsDataPoint {
  const _StockAnalyticsDataPoint({
    required this.date,
    this.restockedUnits = 0,
    this.soldUnits = 0,
  });
  factory _StockAnalyticsDataPoint.fromJson(Map<String, dynamic> json) =>
      _$StockAnalyticsDataPointFromJson(json);

  @override final String date;
  @override @JsonKey() final int restockedUnits;
  @override @JsonKey() final int soldUnits;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StockAnalyticsDataPointCopyWith<_StockAnalyticsDataPoint> get copyWith =>
      __$StockAnalyticsDataPointCopyWithImpl<_StockAnalyticsDataPoint>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() => _$StockAnalyticsDataPointToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StockAnalyticsDataPoint &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.restockedUnits, restockedUnits) ||
                other.restockedUnits == restockedUnits) &&
            (identical(other.soldUnits, soldUnits) ||
                other.soldUnits == soldUnits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, restockedUnits, soldUnits);

  @override
  String toString() =>
      'StockAnalyticsDataPoint(date: $date, restockedUnits: $restockedUnits, soldUnits: $soldUnits)';
}

/// @nodoc
abstract mixin class _$StockAnalyticsDataPointCopyWith<$Res>
    implements $StockAnalyticsDataPointCopyWith<$Res> {
  factory _$StockAnalyticsDataPointCopyWith(_StockAnalyticsDataPoint value,
          $Res Function(_StockAnalyticsDataPoint) _then) =
      __$StockAnalyticsDataPointCopyWithImpl;
  @override
  @useResult
  $Res call({String date, int restockedUnits, int soldUnits});
}

/// @nodoc
class __$StockAnalyticsDataPointCopyWithImpl<$Res>
    implements _$StockAnalyticsDataPointCopyWith<$Res> {
  __$StockAnalyticsDataPointCopyWithImpl(this._self, this._then);
  final _StockAnalyticsDataPoint _self;
  final $Res Function(_StockAnalyticsDataPoint) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? date = null, Object? restockedUnits = null, Object? soldUnits = null}) {
    return _then(_StockAnalyticsDataPoint(
      date: null == date ? _self.date : date as String,
      restockedUnits: null == restockedUnits ? _self.restockedUnits : restockedUnits as int,
      soldUnits: null == soldUnits ? _self.soldUnits : soldUnits as int,
    ));
  }
}

// ─── TopStockItem ─────────────────────────────────────────────────────────────

/// @nodoc
mixin _$TopStockItem {
  String get productId; String get productName; int get quantity;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopStockItemCopyWith<TopStockItem> get copyWith =>
      _$TopStockItemCopyWithImpl<TopStockItem>(this as TopStockItem, _$identity);
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TopStockItem &&
            (identical(other.productId, productId) || other.productId == productId) &&
            (identical(other.productName, productName) || other.productName == productName) &&
            (identical(other.quantity, quantity) || other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, quantity);

  @override
  String toString() =>
      'TopStockItem(productId: $productId, productName: $productName, quantity: $quantity)';
}

/// @nodoc
abstract mixin class $TopStockItemCopyWith<$Res> {
  factory $TopStockItemCopyWith(
          TopStockItem value, $Res Function(TopStockItem) _then) =
      _$TopStockItemCopyWithImpl;
  @useResult
  $Res call({String productId, String productName, int quantity});
}

/// @nodoc
class _$TopStockItemCopyWithImpl<$Res> implements $TopStockItemCopyWith<$Res> {
  _$TopStockItemCopyWithImpl(this._self, this._then);
  final TopStockItem _self;
  final $Res Function(TopStockItem) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null, Object? productName = null, Object? quantity = null}) {
    return _then(_self.copyWith(
      productId: null == productId ? _self.productId : productId as String,
      productName: null == productName ? _self.productName : productName as String,
      quantity: null == quantity ? _self.quantity : quantity as int,
    ));
  }
}

/// @nodoc
@JsonSerializable(fieldRename: FieldRename.snake)
class _TopStockItem implements TopStockItem {
  const _TopStockItem({
    required this.productId,
    required this.productName,
    this.quantity = 0,
  });
  factory _TopStockItem.fromJson(Map<String, dynamic> json) =>
      _$TopStockItemFromJson(json);

  @override final String productId;
  @override final String productName;
  @override @JsonKey() final int quantity;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopStockItemCopyWith<_TopStockItem> get copyWith =>
      __$TopStockItemCopyWithImpl<_TopStockItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() => _$TopStockItemToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TopStockItem &&
            (identical(other.productId, productId) || other.productId == productId) &&
            (identical(other.productName, productName) || other.productName == productName) &&
            (identical(other.quantity, quantity) || other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, quantity);

  @override
  String toString() =>
      'TopStockItem(productId: $productId, productName: $productName, quantity: $quantity)';
}

/// @nodoc
abstract mixin class _$TopStockItemCopyWith<$Res>
    implements $TopStockItemCopyWith<$Res> {
  factory _$TopStockItemCopyWith(
          _TopStockItem value, $Res Function(_TopStockItem) _then) =
      __$TopStockItemCopyWithImpl;
  @override
  @useResult
  $Res call({String productId, String productName, int quantity});
}

/// @nodoc
class __$TopStockItemCopyWithImpl<$Res>
    implements _$TopStockItemCopyWith<$Res> {
  __$TopStockItemCopyWithImpl(this._self, this._then);
  final _TopStockItem _self;
  final $Res Function(_TopStockItem) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? productId = null, Object? productName = null, Object? quantity = null}) {
    return _then(_TopStockItem(
      productId: null == productId ? _self.productId : productId as String,
      productName: null == productName ? _self.productName : productName as String,
      quantity: null == quantity ? _self.quantity : quantity as int,
    ));
  }
}

// ─── StockAnalytics ───────────────────────────────────────────────────────────

/// @nodoc
mixin _$StockAnalytics {
  String get period; String get startDate; String get endDate;
  int get restockedUnits; int get soldUnits; int get currentStock;
  List<StockAnalyticsDataPoint> get data;
  List<TopStockItem> get topRestocked;
  List<TopStockItem> get topSold;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StockAnalyticsCopyWith<StockAnalytics> get copyWith =>
      _$StockAnalyticsCopyWithImpl<StockAnalytics>(
          this as StockAnalytics, _$identity);
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StockAnalytics &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.restockedUnits, restockedUnits) || other.restockedUnits == restockedUnits) &&
            (identical(other.soldUnits, soldUnits) || other.soldUnits == soldUnits) &&
            (identical(other.currentStock, currentStock) || other.currentStock == currentStock) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other.topRestocked, topRestocked) &&
            const DeepCollectionEquality().equals(other.topSold, topSold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, period, startDate, endDate, restockedUnits, soldUnits,
      currentStock,
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(topRestocked),
      const DeepCollectionEquality().hash(topSold));

  @override
  String toString() =>
      'StockAnalytics(period: $period, startDate: $startDate, endDate: $endDate, restockedUnits: $restockedUnits, soldUnits: $soldUnits, currentStock: $currentStock, data: $data, topRestocked: $topRestocked, topSold: $topSold)';
}

/// @nodoc
abstract mixin class $StockAnalyticsCopyWith<$Res> {
  factory $StockAnalyticsCopyWith(
          StockAnalytics value, $Res Function(StockAnalytics) _then) =
      _$StockAnalyticsCopyWithImpl;
  @useResult
  $Res call({
    String period, String startDate, String endDate,
    int restockedUnits, int soldUnits, int currentStock,
    List<StockAnalyticsDataPoint> data,
    List<TopStockItem> topRestocked,
    List<TopStockItem> topSold,
  });
}

/// @nodoc
class _$StockAnalyticsCopyWithImpl<$Res>
    implements $StockAnalyticsCopyWith<$Res> {
  _$StockAnalyticsCopyWithImpl(this._self, this._then);
  final StockAnalytics _self;
  final $Res Function(StockAnalytics) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null, Object? startDate = null, Object? endDate = null,
    Object? restockedUnits = null, Object? soldUnits = null, Object? currentStock = null,
    Object? data = null, Object? topRestocked = null, Object? topSold = null,
  }) {
    return _then(_self.copyWith(
      period: null == period ? _self.period : period as String,
      startDate: null == startDate ? _self.startDate : startDate as String,
      endDate: null == endDate ? _self.endDate : endDate as String,
      restockedUnits: null == restockedUnits ? _self.restockedUnits : restockedUnits as int,
      soldUnits: null == soldUnits ? _self.soldUnits : soldUnits as int,
      currentStock: null == currentStock ? _self.currentStock : currentStock as int,
      data: null == data ? _self.data : data as List<StockAnalyticsDataPoint>,
      topRestocked: null == topRestocked ? _self.topRestocked : topRestocked as List<TopStockItem>,
      topSold: null == topSold ? _self.topSold : topSold as List<TopStockItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable(fieldRename: FieldRename.snake)
class _StockAnalytics implements StockAnalytics {
  const _StockAnalytics({
    required this.period,
    required this.startDate,
    required this.endDate,
    this.restockedUnits = 0,
    this.soldUnits = 0,
    this.currentStock = 0,
    final List<StockAnalyticsDataPoint> data = const [],
    final List<TopStockItem> topRestocked = const [],
    final List<TopStockItem> topSold = const [],
  })  : _data = data,
        _topRestocked = topRestocked,
        _topSold = topSold;

  factory _StockAnalytics.fromJson(Map<String, dynamic> json) =>
      _$StockAnalyticsFromJson(json);

  @override final String period;
  @override final String startDate;
  @override final String endDate;
  @override @JsonKey() final int restockedUnits;
  @override @JsonKey() final int soldUnits;
  @override @JsonKey() final int currentStock;
  final List<StockAnalyticsDataPoint> _data;
  @override @JsonKey() List<StockAnalyticsDataPoint> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    return EqualUnmodifiableListView(_data);
  }
  final List<TopStockItem> _topRestocked;
  @override @JsonKey() List<TopStockItem> get topRestocked {
    if (_topRestocked is EqualUnmodifiableListView) return _topRestocked;
    return EqualUnmodifiableListView(_topRestocked);
  }
  final List<TopStockItem> _topSold;
  @override @JsonKey() List<TopStockItem> get topSold {
    if (_topSold is EqualUnmodifiableListView) return _topSold;
    return EqualUnmodifiableListView(_topSold);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StockAnalyticsCopyWith<_StockAnalytics> get copyWith =>
      __$StockAnalyticsCopyWithImpl<_StockAnalytics>(this, _$identity);

  @override
  Map<String, dynamic> toJson() => _$StockAnalyticsToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StockAnalytics &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.restockedUnits, restockedUnits) || other.restockedUnits == restockedUnits) &&
            (identical(other.soldUnits, soldUnits) || other.soldUnits == soldUnits) &&
            (identical(other.currentStock, currentStock) || other.currentStock == currentStock) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other._topRestocked, _topRestocked) &&
            const DeepCollectionEquality().equals(other._topSold, _topSold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, period, startDate, endDate, restockedUnits, soldUnits,
      currentStock,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(_topRestocked),
      const DeepCollectionEquality().hash(_topSold));

  @override
  String toString() =>
      'StockAnalytics(period: $period, startDate: $startDate, endDate: $endDate, restockedUnits: $restockedUnits, soldUnits: $soldUnits, currentStock: $currentStock, data: $data, topRestocked: $topRestocked, topSold: $topSold)';
}

/// @nodoc
abstract mixin class _$StockAnalyticsCopyWith<$Res>
    implements $StockAnalyticsCopyWith<$Res> {
  factory _$StockAnalyticsCopyWith(
          _StockAnalytics value, $Res Function(_StockAnalytics) _then) =
      __$StockAnalyticsCopyWithImpl;
  @override
  @useResult
  $Res call({
    String period, String startDate, String endDate,
    int restockedUnits, int soldUnits, int currentStock,
    List<StockAnalyticsDataPoint> data,
    List<TopStockItem> topRestocked,
    List<TopStockItem> topSold,
  });
}

/// @nodoc
class __$StockAnalyticsCopyWithImpl<$Res>
    implements _$StockAnalyticsCopyWith<$Res> {
  __$StockAnalyticsCopyWithImpl(this._self, this._then);
  final _StockAnalytics _self;
  final $Res Function(_StockAnalytics) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? period = null, Object? startDate = null, Object? endDate = null,
    Object? restockedUnits = null, Object? soldUnits = null, Object? currentStock = null,
    Object? data = null, Object? topRestocked = null, Object? topSold = null,
  }) {
    return _then(_StockAnalytics(
      period: null == period ? _self.period : period as String,
      startDate: null == startDate ? _self.startDate : startDate as String,
      endDate: null == endDate ? _self.endDate : endDate as String,
      restockedUnits: null == restockedUnits ? _self.restockedUnits : restockedUnits as int,
      soldUnits: null == soldUnits ? _self.soldUnits : soldUnits as int,
      currentStock: null == currentStock ? _self.currentStock : currentStock as int,
      data: null == data ? _self._data : data as List<StockAnalyticsDataPoint>,
      topRestocked: null == topRestocked ? _self._topRestocked : topRestocked as List<TopStockItem>,
      topSold: null == topSold ? _self._topSold : topSold as List<TopStockItem>,
    ));
  }
}

// ─── ProductStockAnalytics ────────────────────────────────────────────────────

/// @nodoc
mixin _$ProductStockAnalytics {
  String get productId; String get productName; String get period;
  String get startDate; String get endDate;
  int get currentStock; int get restockedUnits; int get soldUnits;
  List<StockAnalyticsDataPoint> get data;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductStockAnalyticsCopyWith<ProductStockAnalytics> get copyWith =>
      _$ProductStockAnalyticsCopyWithImpl<ProductStockAnalytics>(
          this as ProductStockAnalytics, _$identity);
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductStockAnalytics &&
            (identical(other.productId, productId) || other.productId == productId) &&
            (identical(other.productName, productName) || other.productName == productName) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.currentStock, currentStock) || other.currentStock == currentStock) &&
            (identical(other.restockedUnits, restockedUnits) || other.restockedUnits == restockedUnits) &&
            (identical(other.soldUnits, soldUnits) || other.soldUnits == soldUnits) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, productId, productName, period, startDate, endDate,
      currentStock, restockedUnits, soldUnits,
      const DeepCollectionEquality().hash(data));

  @override
  String toString() =>
      'ProductStockAnalytics(productId: $productId, productName: $productName, period: $period, startDate: $startDate, endDate: $endDate, currentStock: $currentStock, restockedUnits: $restockedUnits, soldUnits: $soldUnits, data: $data)';
}

/// @nodoc
abstract mixin class $ProductStockAnalyticsCopyWith<$Res> {
  factory $ProductStockAnalyticsCopyWith(ProductStockAnalytics value,
          $Res Function(ProductStockAnalytics) _then) =
      _$ProductStockAnalyticsCopyWithImpl;
  @useResult
  $Res call({
    String productId, String productName, String period,
    String startDate, String endDate,
    int currentStock, int restockedUnits, int soldUnits,
    List<StockAnalyticsDataPoint> data,
  });
}

/// @nodoc
class _$ProductStockAnalyticsCopyWithImpl<$Res>
    implements $ProductStockAnalyticsCopyWith<$Res> {
  _$ProductStockAnalyticsCopyWithImpl(this._self, this._then);
  final ProductStockAnalytics _self;
  final $Res Function(ProductStockAnalytics) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null, Object? productName = null, Object? period = null,
    Object? startDate = null, Object? endDate = null,
    Object? currentStock = null, Object? restockedUnits = null, Object? soldUnits = null,
    Object? data = null,
  }) {
    return _then(_self.copyWith(
      productId: null == productId ? _self.productId : productId as String,
      productName: null == productName ? _self.productName : productName as String,
      period: null == period ? _self.period : period as String,
      startDate: null == startDate ? _self.startDate : startDate as String,
      endDate: null == endDate ? _self.endDate : endDate as String,
      currentStock: null == currentStock ? _self.currentStock : currentStock as int,
      restockedUnits: null == restockedUnits ? _self.restockedUnits : restockedUnits as int,
      soldUnits: null == soldUnits ? _self.soldUnits : soldUnits as int,
      data: null == data ? _self.data : data as List<StockAnalyticsDataPoint>,
    ));
  }
}

/// @nodoc
@JsonSerializable(fieldRename: FieldRename.snake)
class _ProductStockAnalytics implements ProductStockAnalytics {
  const _ProductStockAnalytics({
    required this.productId,
    required this.productName,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.currentStock = 0,
    this.restockedUnits = 0,
    this.soldUnits = 0,
    final List<StockAnalyticsDataPoint> data = const [],
  }) : _data = data;

  factory _ProductStockAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ProductStockAnalyticsFromJson(json);

  @override final String productId;
  @override final String productName;
  @override final String period;
  @override final String startDate;
  @override final String endDate;
  @override @JsonKey() final int currentStock;
  @override @JsonKey() final int restockedUnits;
  @override @JsonKey() final int soldUnits;
  final List<StockAnalyticsDataPoint> _data;
  @override @JsonKey() List<StockAnalyticsDataPoint> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductStockAnalyticsCopyWith<_ProductStockAnalytics> get copyWith =>
      __$ProductStockAnalyticsCopyWithImpl<_ProductStockAnalytics>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() => _$ProductStockAnalyticsToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductStockAnalytics &&
            (identical(other.productId, productId) || other.productId == productId) &&
            (identical(other.productName, productName) || other.productName == productName) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.currentStock, currentStock) || other.currentStock == currentStock) &&
            (identical(other.restockedUnits, restockedUnits) || other.restockedUnits == restockedUnits) &&
            (identical(other.soldUnits, soldUnits) || other.soldUnits == soldUnits) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, productId, productName, period, startDate, endDate,
      currentStock, restockedUnits, soldUnits,
      const DeepCollectionEquality().hash(_data));

  @override
  String toString() =>
      'ProductStockAnalytics(productId: $productId, productName: $productName, period: $period, startDate: $startDate, endDate: $endDate, currentStock: $currentStock, restockedUnits: $restockedUnits, soldUnits: $soldUnits, data: $data)';
}

/// @nodoc
abstract mixin class _$ProductStockAnalyticsCopyWith<$Res>
    implements $ProductStockAnalyticsCopyWith<$Res> {
  factory _$ProductStockAnalyticsCopyWith(_ProductStockAnalytics value,
          $Res Function(_ProductStockAnalytics) _then) =
      __$ProductStockAnalyticsCopyWithImpl;
  @override
  @useResult
  $Res call({
    String productId, String productName, String period,
    String startDate, String endDate,
    int currentStock, int restockedUnits, int soldUnits,
    List<StockAnalyticsDataPoint> data,
  });
}

/// @nodoc
class __$ProductStockAnalyticsCopyWithImpl<$Res>
    implements _$ProductStockAnalyticsCopyWith<$Res> {
  __$ProductStockAnalyticsCopyWithImpl(this._self, this._then);
  final _ProductStockAnalytics _self;
  final $Res Function(_ProductStockAnalytics) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? productId = null, Object? productName = null, Object? period = null,
    Object? startDate = null, Object? endDate = null,
    Object? currentStock = null, Object? restockedUnits = null, Object? soldUnits = null,
    Object? data = null,
  }) {
    return _then(_ProductStockAnalytics(
      productId: null == productId ? _self.productId : productId as String,
      productName: null == productName ? _self.productName : productName as String,
      period: null == period ? _self.period : period as String,
      startDate: null == startDate ? _self.startDate : startDate as String,
      endDate: null == endDate ? _self.endDate : endDate as String,
      currentStock: null == currentStock ? _self.currentStock : currentStock as int,
      restockedUnits: null == restockedUnits ? _self.restockedUnits : restockedUnits as int,
      soldUnits: null == soldUnits ? _self.soldUnits : soldUnits as int,
      data: null == data ? _self._data : data as List<StockAnalyticsDataPoint>,
    ));
  }
}
