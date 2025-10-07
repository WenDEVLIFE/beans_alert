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
      print('🚀 Sending SMS to: $phoneNumber');
      print('📝 Message: $message');
      print('👤 Sender: ${senderName ?? 'Default'}');
      print(
        '🔑 API Key: ${_apiKey.substring(0, 8)}...',
      ); // Only show first 8 chars for security
      print('📦 Request Body: $body');

      final response = await httpClient.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Handle different response formats
        if (responseData is List && responseData.isNotEmpty) {
          // Response is an array with message details
          final messageData = responseData[0] as Map<String, dynamic>;
          final status = messageData['status']?.toString().toLowerCase();

          if (status == 'pending' ||
              status == 'success' ||
              status == 'queued') {
            print('✅ SMS sent successfully (Status: $status)');
            return true;
          } else {
            print('❌ Failed to send SMS: Status $status');
            return false;
          }
        } else if (responseData is Map) {
          // Check if response contains validation errors
          if (responseData.containsKey('sendername') &&
              responseData['sendername'] is List) {
            print('❌ Failed to send SMS: Sender name is invalid');
            return false;
          }

          // Check if the response indicates success
          final status = responseData['status']?.toString().toLowerCase();
          if (status == 'success' || status == 'queued') {
            print('✅ SMS sent successfully');
            return true;
          } else {
            print(
              '❌ Failed to send SMS: ${responseData['message'] ?? 'Unknown error'}',
            );
            return false;
          }
        } else {
          print('❌ Unexpected response format: $responseData');
          return false;
        }
      } else {
        print('❌ HTTP error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('💥 An error occurred while sending SMS: $e');
      return false;
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }
}
