import 'package:dio/dio.dart';
import 'package:qodera_demo_app/core/error/failures.dart';

class ApiFailureHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return const NetworkFailure(
            "Connection failed. Please check your internet.",
          );

        case DioExceptionType.connectionTimeout:
          return const NetworkFailure("Connection timeout. Try again later.");

        case DioExceptionType.receiveTimeout:
          return const NetworkFailure("Receive timeout. Try again later.");

        case DioExceptionType.sendTimeout:
          return const NetworkFailure("Send timeout. Please retry.");

        case DioExceptionType.cancel:
          return const NetworkFailure("Request was cancelled.");

        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);

        case DioExceptionType.unknown:
          return const NetworkFailure(
            "No internet connection or unknown error.",
          );

        default:
          return const ServerFailure("Something went wrong. Please try again.");
      }
    } else {
      return const ServerFailure("Unexpected error occurred.");
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure("No response from server.");
    }

    final statusCode = response.statusCode;
    final data = response.data;

    String message = "Server error occurred.";
    if (data is Map && data.containsKey('message')) {
      message = data['message'];
    } else if (statusCode != null) {
      message =
          "Error $statusCode: ${response.statusMessage ?? 'Unknown error'}";
    }

    return ServerFailure(message);
  }
}
