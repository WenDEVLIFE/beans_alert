import 'package:flutter/material.dart';
import '../helpers/ColorHelpers.dart';
import 'CustomText.dart';
import 'CustomTextField.dart';

class AddPurokDialog extends StatefulWidget {
  final Function(String) onAddPurok;

  const AddPurokDialog({Key? key, required this.onAddPurok}) : super(key: key);

  @override
  State<AddPurokDialog> createState() => _AddPurokDialogState();
}

class _AddPurokDialogState extends State<AddPurokDialog> {
  final TextEditingController _purokController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _purokController.dispose();
    super.dispose();
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
        text: 'Add New Purok',
        fontFamily: 'Poppins',
        fontSize: screenWidth * 0.05,
        color: ColorHelpers.secondaryColor,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _purokController,
              hintText: 'Enter Purok Number',
              borderColor: ColorHelpers.primaryColor,
              fillColor: ColorHelpers.secondaryColor.withOpacity(0.1),
              keyboardType: TextInputType.number,
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
            color: ColorHelpers.secondaryColor,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAddPurok(_purokController.text.trim());
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorHelpers.primaryColor,
            foregroundColor: ColorHelpers.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
            ),
          ),
          child: CustomText(
            text: 'Add Purok',
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.04,
            color: ColorHelpers.secondaryColor,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
