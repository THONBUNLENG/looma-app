import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class AbaPayWayService {
  // Merchant Details
  static const String defaultMerchantId = 'ec475441';
  static const String defaultApiKey =
      '3bcbb5140d1659e1a7aa427be70f369a7a6c9a52';

  // User/Owner Information
  static const String defaultFirstName = 'Looma';
  static const String defaultLastName = 'Store';
  static const String defaultPhone = '011820595';

  static const String apiUrl =
      'https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/purchase';
  static const String checkTransactionUrl =
      'https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/check-transaction';
  static const String generateQrUrl =
      'https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/generate-qr';

  /// Generates HMAC-SHA512 hash
  static String generateHash(String data, {String? apiKey}) {
    final key = utf8.encode(apiKey ?? defaultApiKey);
    final bytes = utf8.encode(data);
    final hmac = Hmac(sha512, key);
    final digest = hmac.convert(bytes);
    return base64.encode(digest.bytes);
  }

  /// Formats the current time as YYYYMMDDHHMMSS
  static String getReqTime() {
    final now = DateTime.now();
    return "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
  }

  /// Calls the ABA QR API (`/generate-qr`) to get a scannable QR code and an
  /// `abapay_deeplink` that opens the ABA Mobile app directly.
  static Future<Map<String, dynamic>> generateQr({
    required String transactionId,
    required double amount,
    required String items,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String paymentOption = 'abapay_khqr',
    String currency = 'USD',
    int lifetimeMinutes = 5,
    String qrImageTemplate = 'template3_color',
    String? callbackUrl,
    double shippingFee = 0.0,
    String? ctid,
    String? pwt,
    String? tokenFlag,
    String? returnParams,
    String? customFields,
    String? returnDeeplink,
    String? merchantId,
    String? apiKey,
  }) async {
    final reqTime = getReqTime();
    final amountStr = amount.toStringAsFixed(2);
    final shippingFeeStr = shippingFee.toStringAsFixed(2);
    const purchaseType = 'purchase';
    final lifetimeStr = lifetimeMinutes.toString();
    final mId = merchantId ?? defaultMerchantId;
    final fName = firstName ?? defaultFirstName;
    final lName = lastName ?? defaultLastName;
    final pPhone = phone ?? defaultPhone;

    final hashData =
        '$reqTime$mId$transactionId$amountStr$items$fName$lName${email ?? ''}$pPhone$purchaseType$paymentOption${callbackUrl ?? ''}${returnDeeplink ?? ''}$currency${customFields ?? ''}${returnParams ?? ''}$lifetimeStr$qrImageTemplate$shippingFeeStr${ctid ?? ''}${pwt ?? ''}${tokenFlag ?? ''}';

    final hash = generateHash(hashData, apiKey: apiKey);

    final body = {
      'req_time': reqTime,
      'merchant_id': mId,
      'tran_id': transactionId,
      'first_name': fName,
      'last_name': lName,
      'email': email ?? '',
      'phone': pPhone,
      'amount': amountStr,
      'shipping_fee': shippingFeeStr,
      'purchase_type': purchaseType,
      'payment_option': paymentOption,
      'items': items,
      'currency': currency,
      'callback_url': callbackUrl ?? '',
      'return_deeplink': returnDeeplink ?? '',
      'custom_fields': customFields ?? '',
      'return_params': returnParams ?? '',
      'payout': '',
      'lifetime': lifetimeMinutes,
      'qr_image_template': qrImageTemplate,
      'ctid': ctid ?? '',
      'pwt': pwt ?? '',
      'token_flag': tokenFlag ?? '',
      'hash': hash,
    };

    try {
      final response = await http.post(
        Uri.parse(generateQrUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': {
            'code': response.statusCode.toString(),
            'message':
                'Server Error: ${response.statusCode} - ${response.body}',
          },
        };
      }
    } catch (e) {
      return {
        'status': {'code': '-1', 'message': e.toString()},
      };
    }
  }

  /// Checks the transaction status
  static Future<Map<String, dynamic>> checkTransaction(
    String transactionId, {
    String? merchantId,
    String? apiKey,
  }) async {
    final reqTime = getReqTime();
    final mId = merchantId ?? defaultMerchantId;
    final hashData = reqTime + mId + transactionId;
    final hash = generateHash(hashData, apiKey: apiKey);

    try {
      final response = await http.post(
        Uri.parse(checkTransactionUrl),
        body: {
          'req_time': reqTime,
          'merchant_id': mId,
          'tran_id': transactionId,
          'hash': hash,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode.toString(),
          'description': 'Server Error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'status': '-1', 'description': e.toString()};
    }
  }
}
