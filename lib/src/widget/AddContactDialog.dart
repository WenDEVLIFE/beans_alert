import 'package:flutter/material.dart';
import '../helpers/ColorHelpers.dart';
import '../model/ContactModel.dart';
import 'CustomText.dart';
import 'CustomTextField.dart';

class AddContactDialog extends StatefulWidget {
  final String purokId;
  final Function(String, ContactModel) onAddContact;
  final Future<bool> Function(String name, String phone) onCheckDuplicate;

  const AddContactDialog({
    Key? key,
    required this.purokId,
    required this.onAddContact,
    required this.onCheckDuplicate,
  }) : super(key: key);

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isValidPhilippinePhoneNumber(String phone) {
    // Philippine phone numbers: +63 followed by 10 digits, or 09 followed by 9 digits
    final RegExp phPhoneRegex = RegExp(r'^(?:\+63|0)9\d{9}$');
    return phPhoneRegex.hasMatch(phone.replaceAll(' ', ''));
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
                hintText: 'Phone Number (e.g., +639123456789)',
                borderColor: ColorHelpers.primaryColor,
                fillColor: ColorHelpers.secondaryColor.withOpacity(0.1),
                keyboardType: TextInputType.phone,
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
          onPressed: () async {
            final name = _nameController.text.trim();
            final phone = _phoneController.text.trim();

            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a name')),
              );
              return;
            }

            if (!_isValidPhilippinePhoneNumber(phone)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid Philippine phone number'),
                ),
              );
              return;
            }

            // Check for duplicates
            final isDuplicate = await widget.onCheckDuplicate(name, phone);
            if (isDuplicate) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Contact with this name and phone number already exists',
                  ),
                ),
              );
              return;
            }

            final contact = ContactModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              phoneNumber: phone,
              purokNumber: widget.purokId,
            );
            widget.onAddContact(widget.purokId, contact);
            Navigator.of(context).pop();
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
