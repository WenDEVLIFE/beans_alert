import 'package:flutter/material.dart';
import '../helpers/ColorHelpers.dart';
import '../model/ContactModel.dart';
import 'CustomText.dart';
import 'CustomTextField.dart';

class AddContactDialog extends StatefulWidget {
  final String purokId;
  final Function(String, ContactModel) onAddContact;

  const AddContactDialog({
    Key? key,
    required this.purokId,
    required this.onAddContact,
  }) : super(key: key);

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      title: CustomText(
        text: 'Add Contact to Purok ${widget.purokId}',
        fontFamily: 'Poppins',
        fontSize: screenWidth * 0.045,
        color: ColorHelpers.secondaryColor,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Full Name',
                borderColor: ColorHelpers.primaryColor,
                fillColor: ColorHelpers.secondaryColor.withOpacity(0.1),
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                borderColor: ColorHelpers.primaryColor,
                fillColor: ColorHelpers.secondaryColor.withOpacity(0.1),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email Address',
                borderColor: ColorHelpers.primaryColor,
                fillColor: ColorHelpers.secondaryColor.withOpacity(0.1),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
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
              final contact = ContactModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
                email: _emailController.text.trim(),
                purokNumber: widget.purokId,
              );
              widget.onAddContact(widget.purokId, contact);
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
            text: 'Add Contact',
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
