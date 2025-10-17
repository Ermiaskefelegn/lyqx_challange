import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class NetworkException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException._(this.message, this.statusCode);

  NetworkException.fromDioError(DioException dioException)
    : message = _mapDioMessage(dioException),
      statusCode = dioException.response?.statusCode;

  const NetworkException.custom({required this.message, required this.statusCode});

  static String _mapDioMessage(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.badResponse:
        return 'Received invalid response with status code: ${dioException.response?.statusCode}';
      case DioExceptionType.badCertificate:
        return 'The certificate provided is invalid';
      case DioExceptionType.connectionTimeout:
        return 'Connection to the server timed out';
      case DioExceptionType.sendTimeout:
        return 'Timeout occurred while sending the request';
      case DioExceptionType.receiveTimeout:
        return 'Timeout occurred while receiving data from the server';
      case DioExceptionType.cancel:
        return 'The request to the server was cancelled';
      case DioExceptionType.connectionError:
        return dioException.error is SocketException
            ? 'No internet connection. Please check your network settings'
            : 'Network connection error occurred';
      case DioExceptionType.unknown:
        return 'An unknown error occurred';
    }
  }

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => 'NetworkException: $message (Status Code: $statusCode)';
}

NetworkException parseDioError(Object error) {
  if (error is DioException) {
    if (error.error is NetworkException) {
      return error.error as NetworkException;
    }
    return NetworkException.fromDioError(error);
  } else {
    return NetworkException.custom(message: error.toString(), statusCode: -1);
  }
}
