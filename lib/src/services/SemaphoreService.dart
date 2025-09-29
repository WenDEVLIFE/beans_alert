import 'dart:convert';
import 'package:http/http.dart' as http;

class SemaphoreService {
  static const String _baseUrl = 'https://api.semaphore.co/api/v4/messages';
  // Replace with your actual Semaphore API key
  static const String _apiKey = '86d38d84b21ecbc9d9f7b35fd2c59b09';

  static Future<bool> sendSMS(
    String phoneNumber,
    String message, {
    String? senderName,
    http.Client? client,
  }) async {
    final Map<String, String> body = {
      'apikey': _apiKey,
      'number': phoneNumber,
      'message': message,
    };

    if (senderName != null && senderName.isNotEmpty) {
      body['sendername'] = senderName;
    }

    final httpClient = client ?? http.Client();

    try {
      final response = await httpClient.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Check if the response indicates success
        // Semaphore returns something like {"status": "success", ...}
        if (responseData['status'] == 'success' ||
            responseData['status'] == 'queued') {
          print('SMS sent successfully');
          return true;
        } else {
          print(
            'Failed to send SMS: ${responseData['message'] ?? 'Unknown error'}',
          );
          return false;
        }
      } else {
        print('HTTP error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred while sending SMS: $e');
      return false;
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }
}
