/// Application-level error hierarchy.
/// Never expose raw DioException or SocketException to users.
sealed class AppError {
  const AppError();

  String toUserMessage([String? locale]) {
    return switch (this) {
      NetworkError() => locale == 'am'
          ? 'ኔትወርክዎን ያረጋግጡ እና እንደገና ይሞክሩ።'
          : 'Please check your connection and try again.',
      ServerError() => locale == 'am'
          ? 'ስህተት ተፈጠረ። እንደገና ይሞክሩ።'
          : 'Something went wrong. Please try again.',
      UnauthorizedError() => locale == 'am'
          ? 'ክፍለ ጊዜዎ ጊዜው አልፎበታል። እንደገና ይግቡ።'
          : 'Your session has expired. Please log in again.',
      InsufficientStockError(:final productName, :final available) =>
        'Only $available of "$productName" are available.',
      ValidationError(:final message) => message,
      NotFoundError() => 'The requested item was not found.',
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
  const GenericError([this.message = 'An error occurred. Please try again.']);
}
