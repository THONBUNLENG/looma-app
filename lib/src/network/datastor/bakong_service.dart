import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BakongService {
  static const String _baseUrl = 'https://api-bakong.nbc.gov.kh/v1';

  /// Verify transaction status by MD5 hash
  /// Returns a map with 'success' (bool) and 'message' (String)
  static Future<Map<String, dynamic>> checkTransactionByMd5({
    required String md5,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/check_transaction_by_md5'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'md5': md5}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final bool isSuccess = (data['responseCode'] == 0 || data['responseCode'] == '0') && 
                                data['data'] != null;
        return {
          'success': isSuccess,
          'message': isSuccess ? 'Success' : (data['responseMessage'] ?? 'Transaction not found'),
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error ${response.statusCode}: ${data['responseMessage'] ?? 'Server error'}',
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Connection timeout. Please check your internet.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }
}
