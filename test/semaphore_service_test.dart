import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:beans_alert/src/services/SemaphoreService.dart';

void main() {
  group('SemaphoreService', () {
    test('sendSMS returns true on successful response', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.toString(),
          'https://api.semaphore.co/api/v4/messages',
        );
        expect(
          request.headers['Content-Type'],
          'application/x-www-form-urlencoded; charset=utf-8',
        );
        expect(
          request.bodyFields!['apikey'],
          '86d38d84b21ecbc9d9f7b35fd2c59b09',
        );
        expect(request.bodyFields!['number'], '09497811258');
        expect(request.bodyFields!['message'], 'Test message from semaphore');
        expect(request.bodyFields!['sendername'], 'TestSender');

        return http.Response(
          '[{"message_id":123,"status":"Pending","recipient":"09497811258"}]',
          200,
        );
      });

      final result = await SemaphoreService.sendSMS(
        '09497811258',
        'Test message from semaphore',
        senderName: 'TestSender',
        client: mockClient,
      );

      expect(result, true);
    });

    test('sendSMS returns true on queued response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '[{"message_id":124,"status":"Pending","recipient":"09497811258"}]',
          200,
        );
      });

      final result = await SemaphoreService.sendSMS(
        '09497811258',
        'Test message from semaphore',
        client: mockClient,
      );

      expect(result, true);
    });

    test('sendSMS returns false on failed response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"status": "failed", "message": "Invalid API key"}',
          200,
        );
      });

      final result = await SemaphoreService.sendSMS(
        '09497811258',
        'Test message from semaphore',
        client: mockClient,
      );

      expect(result, false);
    });

    test('sendSMS returns false on HTTP error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final result = await SemaphoreService.sendSMS(
        '09497811258',
        'Test message from semaphore',
        client: mockClient,
      );

      expect(result, false);
    });

    test('sendSMS handles network exception', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      final result = await SemaphoreService.sendSMS(
        '09497811258',
        'Test message from semaphore',
        client: mockClient,
      );

      expect(result, false);
    });

    test('sendSMS works without senderName', () async {
      final mockClient = MockClient((request) async {
        expect(request.bodyFields!.containsKey('sendername'), false);
        return http.Response('{"status": "success"}', 200);
      });

      final result = await SemaphoreService.sendSMS(
        '09497811258',
        'Test message from semaphore',
        client: mockClient,
      );

      expect(result, true);
    });
  });
}
