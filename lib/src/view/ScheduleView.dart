import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/model/ScheduledMessage.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../bloc/ScheduledMessageBloc.dart';
import '../helpers/ColorHelpers.dart';
import '../widget/CalendarWidget.dart';
import '../widget/CustomText.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  DateTime? _selectedDate;
  List<ScheduledMessage> _allScheduledMessages = [];
  List<ScheduledMessage> _selectedDateMessages = [];

  @override
  void initState() {
    super.initState();
    context.read<ScheduledMessageBloc>().add(LoadScheduledMessagesEvent());
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedDateMessages = _allScheduledMessages.where((message) {
        return message.scheduledTime.year == date.year &&
            message.scheduledTime.month == date.month &&
            message.scheduledTime.day == date.day;
      }).toList();
    });
  }

  List<DateTime> _getHighlightedDates() {
    return _allScheduledMessages
        .where((message) => !message.isSent)
        .map(
          (message) => DateTime(
            message.scheduledTime.year,
            message.scheduledTime.month,
            message.scheduledTime.day,
          ),
        )
        .toSet() // Remove duplicates
        .toList();
  }

  void _deleteScheduledMessage(ScheduledMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorHelpers.customblack1,
          title: CustomText(
            text: 'Delete Scheduled Message',
            fontFamily: 'Anton',
            fontSize: 18,
            color: ColorHelpers.secondaryColor,
            fontWeight: FontWeight.w600,
          ),
          content: CustomText(
            text: 'Are you sure you want to delete this scheduled message?',
            fontFamily: 'Poppins',
            fontSize: 14,
            color: ColorHelpers.secondaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CustomText(
                text: 'Cancel',
                fontFamily: 'Poppins',
                fontSize: 14,
                color: ColorHelpers.secondaryColor.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ScheduledMessageBloc>().add(
                  DeleteScheduledMessageEvent(messageId: message.id),
                );
                Navigator.of(context).pop();
              },
              child: CustomText(
                text: 'Delete',
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorHelpers.customblack1,
      appBar: AppBar(
        backgroundColor: ColorHelpers.primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              SvgHelpers.menulist,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                ColorHelpers.secondaryColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: 'BEANS',
                fontFamily: 'Anton',
                fontSize: 30.0,
                color: ColorHelpers.secondaryColor,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
              SizedBox(width: screenWidth * 0.02),
              CustomText(
                text: 'ALERT',
                fontFamily: 'Anton',
                fontSize: 30.0,
                color: ColorHelpers.accentColor,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      drawer: CustomNavigationSideBar(),
      body: BlocConsumer<ScheduledMessageBloc, ScheduledMessageState>(
        listener: (context, state) {
          if (state is ScheduledMessageLoaded) {
            setState(() {
              _allScheduledMessages = state.scheduledMessages;
              if (_selectedDate != null) {
                _selectedDateMessages = _allScheduledMessages.where((message) {
                  return message.scheduledTime.year == _selectedDate!.year &&
                      message.scheduledTime.month == _selectedDate!.month &&
                      message.scheduledTime.day == _selectedDate!.day;
                }).toList();
              }
            });
          }
        },
        builder: (context, state) {
          if (state is ScheduledMessageLoading) {
            return Center(
              child: CircularProgressIndicator(color: ColorHelpers.accentColor),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                CustomText(
                  text: 'Scheduled Messages',
                  fontFamily: 'Anton',
                  fontSize: screenWidth * 0.06,
                  color: ColorHelpers.secondaryColor,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: screenHeight * 0.02),

                // Calendar
                Calendar(
                  highlightedDates: _getHighlightedDates(),
                  onDateSelected: _onDateSelected,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Selected Date Messages
                if (_selectedDate != null) ...[
                  CustomText(
                    text:
                        'Messages for ${DateFormat.yMMMMd().format(_selectedDate!)}',
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.045,
                    color: ColorHelpers.secondaryColor,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  if (_selectedDateMessages.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenHeight * 0.04),
                        child: CustomText(
                          text: 'No scheduled messages for this date',
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.04,
                          color: ColorHelpers.secondaryColor.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ..._selectedDateMessages.map(
                      (message) => _buildScheduledMessageCard(
                        message,
                        screenWidth,
                        screenHeight,
                      ),
                    ),
                ] else ...[
                  // Show upcoming messages when no date is selected
                  CustomText(
                    text: 'Upcoming Scheduled Messages',
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.045,
                    color: ColorHelpers.secondaryColor,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  ..._allScheduledMessages
                      .where(
                        (message) =>
                            !message.isSent &&
                            message.scheduledTime.isAfter(DateTime.now()),
                      )
                      .take(5) // Show next 5 upcoming messages
                      .map(
                        (message) => _buildScheduledMessageCard(
                          message,
                          screenWidth,
                          screenHeight,
                        ),
                      ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduledMessageCard(
    ScheduledMessage message,
    double screenWidth,
    double screenHeight,
  ) {
    final timeFormat = DateFormat.jm(); // 12-hour format with AM/PM

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: message.isSent
            ? ColorHelpers.primaryColor.withOpacity(0.1)
            : ColorHelpers.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(
          color: message.isSent
              ? ColorHelpers.primaryColor.withOpacity(0.3)
              : ColorHelpers.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: message.isSent
                      ? Colors.green.withOpacity(0.2)
                      : ColorHelpers.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(screenWidth * 0.015),
                ),
                child: CustomText(
                  text: message.isSent ? 'Sent' : 'Scheduled',
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.03,
                  color: message.isSent
                      ? Colors.green
                      : ColorHelpers.accentColor,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomText(
                text: timeFormat.format(message.scheduledTime),
                fontFamily: 'Poppins',
                fontSize: screenWidth * 0.035,
                color: ColorHelpers.secondaryColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.right,
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.01),

          // Sender
          CustomText(
            text: 'From: ${message.senderName} (${message.senderRole})',
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.035,
            color: ColorHelpers.secondaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.left,
          ),

          SizedBox(height: screenHeight * 0.005),

          // Services
          Row(
            children: [
              if (message.sendSMS) ...[
                FaIcon(
                  FontAwesomeIcons.sms,
                  color: ColorHelpers.accentColor,
                  size: screenWidth * 0.035,
                ),
                SizedBox(width: screenWidth * 0.01),
                CustomText(
                  text: 'SMS',
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.03,
                  color: ColorHelpers.secondaryColor.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ],
              if (message.sendSMS && message.sendEmail) SizedBox(width: screenWidth * 0.02),
              if (message.sendEmail) ...[
                FaIcon(
                  FontAwesomeIcons.envelope,
                  color: ColorHelpers.accentColor,
                  size: screenWidth * 0.035,
                ),
                SizedBox(width: screenWidth * 0.01),
                CustomText(
                  text: 'Email',
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.03,
                  color: ColorHelpers.secondaryColor.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ],
          ),

          SizedBox(height: screenHeight * 0.005),

          // Recipients count
          CustomText(
            text:
                'To: ${message.recipientNames.length} recipient${message.recipientNames.length > 1 ? 's' : ''}',
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.035,
            color: ColorHelpers.secondaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.left,
          ),

          SizedBox(height: screenHeight * 0.01),

          // Message preview
          CustomText(
            text: message.message.length > 100
                ? '${message.message.substring(0, 100)}...'
                : message.message,
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.035,
            color: ColorHelpers.secondaryColor,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
          ),

          // Action buttons
          if (!message.isSent)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _deleteScheduledMessage(message),
                  icon: FaIcon(
                    FontAwesomeIcons.trash,
                    size: screenWidth * 0.04,
                    color: Colors.red,
                  ),
                  label: CustomText(
                    text: 'Delete',
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.035,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.005,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
