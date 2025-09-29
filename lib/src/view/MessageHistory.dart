import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../bloc/MessageHistoryBloc.dart';
import '../helpers/ColorHelpers.dart';
import '../widget/CustomSearchBar.dart';
import '../widget/CustomText.dart';

class MessageHistory extends StatefulWidget {
  const MessageHistory({Key? key}) : super(key: key);

  @override
  State<MessageHistory> createState() => _MessageHistoryState();
}

class _MessageHistoryState extends State<MessageHistory> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<MessageHistoryBloc>().add(LoadMessageHistoryEvent());
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
      body: BlocBuilder<MessageHistoryBloc, MessageHistoryState>(
        builder: (context, state) {
          if (state is MessageHistoryLoading) {
            return Center(
              child: CircularProgressIndicator(color: ColorHelpers.accentColor),
            );
          }

          if (state is MessageHistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: screenWidth * 0.15,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomText(
                    text: 'Error loading message history',
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.045,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomText(
                    text: state.message,
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.035,
                    color: ColorHelpers.secondaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            );
          }

          if (state is MessageHistoryLoaded) {
            final messageHistory = state.messageHistory;

            return Column(
              children: [
                // Search Bar
                CustomSearchBar(
                  hintText: 'Search messages...',
                  searchQuery: _searchQuery,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    context.read<MessageHistoryBloc>().add(
                      SearchMessageHistoryEvent(query: value),
                    );
                  },
                ),
                // Message List
                Expanded(
                  child: messageHistory.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message_outlined,
                                color: ColorHelpers.secondaryColor.withOpacity(
                                  0.5,
                                ),
                                size: screenWidth * 0.15,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              CustomText(
                                text: 'No message history found',
                                fontFamily: 'Poppins',
                                fontSize: screenWidth * 0.045,
                                color: ColorHelpers.secondaryColor.withOpacity(
                                  0.7,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: messageHistory.length,
                          itemBuilder: (context, index) {
                            final message = messageHistory[index];
                            return _buildMessageItem(
                              message,
                              screenWidth,
                              screenHeight,
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return Center(
            child: CustomText(
              text: 'Loading message history...',
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.045,
              color: ColorHelpers.secondaryColor.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(message, double screenWidth, double screenHeight) {
    final timeFormat = DateFormat('MMM dd, yyyy hh:mm a');

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.005,
      ),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: ColorHelpers.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(
          color: message.sentSuccessfully
              ? ColorHelpers.accentColor.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with receiver info and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: message.receiverName,
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.04,
                      color: ColorHelpers.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      text: message.receiverPhone,
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.035,
                      color: ColorHelpers.secondaryColor.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: message.sentSuccessfully
                      ? ColorHelpers.accentColor
                      : Colors.red,
                  borderRadius: BorderRadius.circular(screenWidth * 0.015),
                ),
                child: CustomText(
                  text: message.sentSuccessfully ? 'Sent' : 'Failed',
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.03,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),

          // Message content
          CustomText(
            text: message.message,
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.035,
            color: ColorHelpers.secondaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: screenHeight * 0.01),

          // Footer with sender and timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'From: ${message.senderName}',
                fontFamily: 'Poppins',
                fontSize: screenWidth * 0.03,
                color: ColorHelpers.secondaryColor.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
              CustomText(
                text: timeFormat.format(message.timestamp),
                fontFamily: 'Poppins',
                fontSize: screenWidth * 0.03,
                color: ColorHelpers.secondaryColor.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
