import 'package:beans_alert/src/model/ContactModel.dart';
import 'package:beans_alert/src/widget/CustomText.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelpers.dart';

class SelectableContactCard extends StatelessWidget {
  final ContactModel contact;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableContactCard({
    Key? key,
    required this.contact,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorHelpers.accentColor.withOpacity(0.2)
              : ColorHelpers.customblack1,
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
          border: Border.all(
            color: isSelected
                ? ColorHelpers.accentColor
                : ColorHelpers.primaryColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? ColorHelpers.accentColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? ColorHelpers.accentColor
                      : ColorHelpers.secondaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: screenWidth * 0.04,
                    )
                  : null,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: contact.name,
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.04,
                    color: ColorHelpers.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(
                    text: contact.phoneNumber,
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.035,
                    color: ColorHelpers.secondaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
