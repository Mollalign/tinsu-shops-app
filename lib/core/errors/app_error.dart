import '../../../l10n/app_localizations.dart';

/// Application-level error hierarchy.
/// Never expose raw DioException or SocketException to users.
sealed class AppError {
  const AppError();

  /// Returns a localized user-facing message using the provided [AppLocalizations].
  String toUserMessage(AppLocalizations l) {
    return switch (this) {
      NetworkError() => l.errorNetwork,
      ServerError() => l.errorServer,
      UnauthorizedError() => l.errorUnauthorized,
      InsufficientStockError(:final productName, :final available) =>
        l.errorInsufficientStock(available, productName),
      NotFoundError() => l.errorNotFound,
      ValidationError(:final message) => message,
      GenericError(:final message) => message,
    };
  }
}

final class NetworkError extends AppError {
  const NetworkError();
}

final class ServerError extends AppError {
  final int statusCode;
  const ServerError(this.statusCode);
}

final class UnauthorizedError extends AppError {
  const UnauthorizedError();
}

final class InsufficientStockError extends AppError {
  final String productName;
  final int available;
  const InsufficientStockError({required this.productName, required this.available});
}

final class ValidationError extends AppError {
  final String message;
  const ValidationError(this.message);
}

final class NotFoundError extends AppError {
  const NotFoundError();
}

final class GenericError extends AppError {
  final String message;
  const GenericError([this.message = '']);
}
