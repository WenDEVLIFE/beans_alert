import 'package:beans_alert/src/widget/CircleWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../helpers/ColorHelpers.dart';
import 'CustomButton.dart';
import 'CustomText.dart';

class Calendar extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  const Calendar({Key? key, this.onDateSelected}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<DateTime> notAvailableDates = [
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 5)),
    DateTime.now().add(Duration(days: 8)),
  ];

  List<DateTime> _daysInMonth(DateTime month) {
    // final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(lastDay.day, (i) => DateTime(month.year, month.month, i + 1));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final days = _daysInMonth(_focusedDay);
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 20, color: Colors.black,),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                    });
                  },
                ),
                CustomText(
                  text: DateFormat.yMMMM().format(_focusedDay),
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.left,
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronRight, size: 20, color: Colors.black,),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays
                  .map((d) => Expanded(
                child: Center(
                  child: CustomText(
                    text: d,
                    fontFamily: 'Roboto',
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.left,
                  ),
                ),
              ))
                  .toList(),
            ),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: days.length + days.first.weekday % 7,
              itemBuilder: (context, index) {
                if (index < days.first.weekday % 7) {
                  return SizedBox.shrink();
                }
                final day = days[index - days.first.weekday % 7];
                final isSelected = _selectedDay != null && day.year == _selectedDay!.year && day.month == _selectedDay!.month && day.day == _selectedDay!.day;
                final isNotAvailable = notAvailableDates.any((d) => d.year == day.year && d.month == day.month && d.day == day.day);
                return GestureDetector(
                  onTap: () {
                    if (!isNotAvailable) {
                      setState(() {
                        _selectedDay = day;
                      });
                      if (widget.onDateSelected != null) {
                        widget.onDateSelected!(day);
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isNotAvailable
                          ? Colors.grey
                          : isSelected
                          ? Colors.transparent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: CustomText(
                        text: '${day.day}',
                        fontFamily: 'Roboto',
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.10),
          ],
        ),
      ),
    );
  }
}
