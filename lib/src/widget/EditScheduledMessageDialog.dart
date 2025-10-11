import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../helpers/ColorHelpers.dart';
import '../model/ScheduledMessage.dart';
import 'CustomText.dart';

class EditScheduledMessageDialog extends StatefulWidget {
  final ScheduledMessage message;
  final Function(ScheduledMessage) onSave;

  const EditScheduledMessageDialog({
    Key? key,
    required this.message,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditScheduledMessageDialog> createState() => _EditScheduledMessageDialogState();
}

class _EditScheduledMessageDialogState extends State<EditScheduledMessageDialog> {
  late TextEditingController _messageController;
  late DateTime _selectedDateTime;
  late bool _sendSMS;
  late bool _sendEmail;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.message.message);
    _selectedDateTime = widget.message.scheduledTime;
    _sendSMS = widget.message.sendSMS;
    _sendEmail = widget.message.sendEmail;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorHelpers.accentColor,
              onPrimary: Colors.white,
              surface: ColorHelpers.customblack1,
              onSurface: ColorHelpers.secondaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorHelpers.accentColor,
                onPrimary: Colors.white,
                surface: ColorHelpers.customblack1,
                onSurface: ColorHelpers.secondaryColor,
              ),
            ),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  void _saveChanges() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    if (!_sendSMS && !_sendEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one service (SMS or Email)')),
      );
      return;
    }

    if (_selectedDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a future date and time')),
      );
      return;
    }

    final updatedMessage = widget.message.copyWith(
      message: _messageController.text.trim(),
      scheduledTime: _selectedDateTime,
      sendSMS: _sendSMS,
      sendEmail: _sendEmail,
    );

    widget.onSave(updatedMessage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      backgroundColor: ColorHelpers.customblack1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      title: CustomText(
        text: 'Edit Scheduled Message',
        fontFamily: 'Anton',
        fontSize: screenWidth * 0.045,
        color: ColorHelpers.secondaryColor,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Field
            CustomText(
              text: 'Message',
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.04,
              color: ColorHelpers.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: screenHeight * 0.01),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: screenWidth * 0.005,
                    blurRadius: screenWidth * 0.01,
                    offset: Offset(
                      screenWidth * 0.005,
                      screenHeight * 0.0025,
                    ),
                  ),
                ],
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 3,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: ColorHelpers.secondaryColor,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your message...',
                  filled: true,
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: ColorHelpers.secondaryColor.withOpacity(0.6),
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: ColorHelpers.customblack1,
                  contentPadding: EdgeInsets.all(screenWidth * 0.04),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(
                      color: ColorHelpers.primaryColor,
                      width: screenWidth * 0.0075,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(
                      color: ColorHelpers.primaryColor,
                      width: screenWidth * 0.005,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Date/Time Selection
            CustomText(
              text: 'Scheduled Time',
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.04,
              color: ColorHelpers.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: screenHeight * 0.01),
            InkWell(
              onTap: _selectDateTime,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: ColorHelpers.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  border: Border.all(
                    color: ColorHelpers.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.calendar,
                      color: ColorHelpers.accentColor,
                      size: screenWidth * 0.045,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    CustomText(
                      text: DateFormat('MMM dd, yyyy hh:mm a').format(_selectedDateTime),
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.04,
                      color: ColorHelpers.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Service Selection
            CustomText(
              text: 'Services',
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.04,
              color: ColorHelpers.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: screenHeight * 0.01),
            Column(
              children: [
                CheckboxListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.sms,
                        color: ColorHelpers.accentColor,
                        size: screenWidth * 0.045,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      CustomText(
                        text: 'SMS',
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.04,
                        color: ColorHelpers.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  value: _sendSMS,
                  onChanged: (value) => setState(() => _sendSMS = value ?? false),
                  activeColor: ColorHelpers.accentColor,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                CheckboxListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.envelope,
                        color: ColorHelpers.accentColor,
                        size: screenWidth * 0.045,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      CustomText(
                        text: 'Email',
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.04,
                        color: ColorHelpers.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  value: _sendEmail,
                  onChanged: (value) => setState(() => _sendEmail = value ?? false),
                  activeColor: ColorHelpers.accentColor,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: CustomText(
            text: 'Cancel',
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.04,
            color: ColorHelpers.secondaryColor.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorHelpers.primaryColor,
            foregroundColor: ColorHelpers.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
            ),
          ),
          child: CustomText(
            text: 'Save Changes',
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.04,
            color: ColorHelpers.secondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}