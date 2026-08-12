import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BakongService {
  static const String _baseUrl = 'https://api-bakong.nbc.gov.kh/v1';

  /// Verify transaction status by MD5 hash
  /// Returns a map with 'success' (bool), 'message' (String),
  /// 'responseCode' (the API's response code, or the HTTP status code
  /// as a fallback), and 'data' (raw payload, if any).
  static Future<Map<String, dynamic>> checkTransactionByMd5({
    required String md5,
    required String token,
    double? amount,
    String? currency,
  }) async {
    http.Response response;

    // --- Network call ---
    try {
      response = await http
          .post(
        Uri.parse('$_baseUrl/check_transaction_by_md5'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'md5': md5}),
      )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Connection timeout. Please check your internet.',
        'responseCode': 'timeout',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
        'responseCode': 'network_error',
      };
    }
    Map<String, dynamic>? data;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        data = decoded;
      }
    } catch (_) {
      data = null;
    }

    if (response.statusCode == 200 && data != null) {
      final bool isSuccess =
          (data['responseCode'] == 0 || data['responseCode'] == '0') &&
              data['data'] != null;
      return {
        'success': isSuccess,
        'message': isSuccess
            ? 'Success'
            : (data['responseMessage'] ?? 'Transaction not found'),
        'responseCode': data['responseCode'] ?? response.statusCode,
        'data': data['data'],
      };
    }

    return {
      'success': false,
      'message': data != null
          ? 'Error ${response.statusCode}: ${data['responseMessage'] ?? 'Server error'}'
          : 'Error ${response.statusCode}: Unexpected response from server',
      'responseCode': data?['responseCode'] ?? response.statusCode,
    };
  }
}