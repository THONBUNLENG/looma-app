import 'package:dio/dio.dart';

import '../api/api_end_point.dart';


class PaymentRepository {
  final Dio _dio = Dio();
  Future<Response?> createPurchase(FormData formData) async {
    try {
      final response = await _dio.post(
        EcommerceAPIEndPoint.instance.purchase,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Accept': 'application/json'},
        ),
      );

      return response;
    } on DioException catch (e) {
      'Payment Error: ${e.response?.statusCode} - ${e.message}';
      rethrow;
    } catch (e) {
      'Unexpected Error: $e';
      return null;
    }
  }
}
