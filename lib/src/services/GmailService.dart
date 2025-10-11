import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class GmailService {

  static const String appEmail ='barangayalertsystem02@gmail.com';
  static const String appPW ='bhgd qknk ojsf npfo';

  // This is for the registeration
  static Future<bool> sendEmail(String recipientEmail, String code) async {
    final smtpServer = gmail(appEmail, appPW);

    final message = Message()
      ..from = Address(appEmail, 'Beans Alert Verification Code')
      ..recipients.add(recipientEmail)
      ..subject = 'Beans Alert Verification Code'
      ..html = '<h1>Your beans alert verification code is: $code</h1>';

    try {
      await send(message, smtpServer);
      print('Email sent successfully');
      return true;
    } on MailerException catch (e) {
      print('Failed to send email: ${e.message}');
      for (var problem in e.problems) {
        print('Problem: ${problem.code} - ${problem.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return false;
  }

  // This wil send the email to the user
  static Future<bool> sendedToClient(List<String> recipientEmail, String subject, String body) async {
    final smtpServer = gmail(appEmail, appPW);

    final message = Message()
      ..from = Address(appEmail, 'Beans Alert System')
      ..recipients.addAll(recipientEmail)
      ..subject = subject
      ..html = '<h1>$body</h1>';

    try {
      await send(message, smtpServer);
      print('Email sent successfully');
      return true;
    } on MailerException catch (e) {
      print('Failed to send email: ${e.message}');
      for (var problem in e.problems) {
        print('Problem: ${problem.code} - ${problem.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return false;
  }
}