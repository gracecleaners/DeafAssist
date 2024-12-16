import 'package:http/http.dart' as http;
import 'dart:convert';

class DarazaPaymentService {
  final String apiKey = "pruzoo8Y.kKmQZKOxUQE77xzKvsRh31Ss5UIOAGQ4";
  final String apiUrl = 'https://daraza.net/api/remit/';

  DarazaPaymentService();

  Future<Map<String, dynamic>> initiatePayment({
    required String phone,
    required double amount,
    String note = 'App Subscription',
  }) async {
    try {
      // Validate phone number
      if (!_isValidPhoneNumber(phone)) {
        return {
          'success': false,
          'error': 'Invalid phone number format. Use +256XXXXXXXXX',
        };
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Api-Key $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'method': 1,
          'amount':
              amount.toStringAsFixed(0), // Whole number for Uganda shillings
          'phone': phone,
          'note': note,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Payment failed: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  bool _isValidPhoneNumber(String phone) {
    // Uganda phone number validation
    final phoneRegex = RegExp(r'^\+256\d{9}$');
    return phoneRegex.hasMatch(phone);
  }
}
