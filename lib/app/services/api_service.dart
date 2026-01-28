import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../services/auth_service.dart';

class ApiService {
  final AuthService _authService = Get.find<AuthService>();

  // Get headers with token

  Map<String, String> _getHeaders() {
    final token = _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET Request

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = _getHeaders();
      final response = await http
          .get(
        Uri.parse(endpoint),
        headers: headers,
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Something went wrong: $e');
    }
  }

  // POST Request

  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    try {
      final headers = _getHeaders();
      final response = await http
          .post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Something went wrong: $e');
    }
  }

  // PUT Request

  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    try {
      final headers = _getHeaders();
      final response = await http
          .put(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Something went wrong: $e');
    }
  }

  // DELETE Request

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final headers = _getHeaders();
      final response = await http
          .delete(
        Uri.parse(endpoint),
        headers: headers,
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Something went wrong: $e');
    }
  }

  // Handle Response

  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw ApiException(_getErrorMessage(response));
      case 401:
        _authService.logout();
        throw ApiException('Session expired. Please login again');
      case 403:
        throw ApiException('Access forbidden');
      case 404:
        throw ApiException('Resource not found');
      case 422:
        throw ValidationException(_getValidationErrors(response));
      case 500:
        throw ApiException('Server error. Please try again later');
      default:
        throw ApiException('Something went wrong: ${response.statusCode}');
    }
  }

  // Get error message from response

  String _getErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Request failed';
    } catch (e) {
      return 'Request failed';
    }
  }

  // Get validation errors

  Map<String, List<String>> _getValidationErrors(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null) {
        return errors.map(
              (key, value) => MapEntry(
            key,
            (value as List).map((e) => e.toString()).toList(),
          ),
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Validation errors parsing failed: $e');
        debugPrint('Stack: $stackTrace');
      }

    }
    return {};
  }

  // Upload file with multipart

  Future<Map<String, dynamic>> uploadFile(
      String endpoint,
      File file, {
        String fieldName = 'file',
        Map<String, String>? additionalFields,
      }) async {
    try {
      final headers = _getHeaders();
      headers.remove('Content-Type');

      final request = http.MultipartRequest('POST', Uri.parse(endpoint));
      request.headers.addAll(headers);

      // Add file

      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );

      // Add additional fields

      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      throw ApiException('Upload failed: $e');
    }
  }
}

// Custom Exceptions

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final Map<String, List<String>> errors;
  ValidationException(this.errors);

  String get firstError {
    if (errors.isEmpty) return 'Validation failed';
    return errors.values.first.first;
  }

  @override
  String toString() => firstError;
}