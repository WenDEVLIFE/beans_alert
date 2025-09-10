import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helpers/ColorHelpers.dart';
import '../model/ContactModel.dart';
import 'CustomText.dart';

class PurokContactCard extends StatefulWidget {
  final String purokNumber;
  final List<ContactModel> contacts;
  final Function(ContactModel) onRemoveContact;
  final Function(ContactModel) onDeleteContact;

  const PurokContactCard({
    Key? key,
    required this.purokNumber,
    required this.contacts,
    required this.onRemoveContact,
    required this.onDeleteContact,
  }) : super(key: key);

  @override
  State<PurokContactCard> createState() => _PurokContactCardState();
}

class _PurokContactCardState extends State<PurokContactCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _showDeleteConfirmation(ContactModel contact) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          title: const Text('Delete Contact'),
          content: Text(
            'Are you sure you want to delete ${contact.name}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDeleteContact(contact);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveConfirmation(ContactModel contact) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          title: const Text('Remove Contact'),
          content: Text(
            'Are you sure you want to remove ${contact.name} from Purok ${widget.purokNumber}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onRemoveContact(contact);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorHelpers.primaryColor,
              ColorHelpers.primaryColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  children: [
                    // Purok Icon
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: ColorHelpers.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: ColorHelpers.accentColor,
                        size: screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),

                    // Purok Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Purok ${widget.purokNumber}',
                            fontFamily: 'Poppins',
                            fontSize: screenWidth * 0.05,
                            color: ColorHelpers.secondaryColor,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.users,
                                color: Colors.grey.shade600,
                                size: screenWidth * 0.035,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              CustomText(
                                text: '${widget.contacts.length} contacts',
                                fontFamily: 'Poppins',
                                fontSize: screenWidth * 0.035,
                                color: ColorHelpers.secondaryColor.withOpacity(
                                  0.8,
                                ),
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expand/Collapse Icon
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        color: ColorHelpers.accentColor,
                        size: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contacts List (Expandable)
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: widget.contacts.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(screenWidth * 0.06),
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.userSlash,
                              color: Colors.grey.shade400,
                              size: screenWidth * 0.08,
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            CustomText(
                              text: 'No contacts in this purok',
                              fontFamily: 'Poppins',
                              fontSize: screenWidth * 0.035,
                              color: ColorHelpers.secondaryColor.withOpacity(
                                0.6,
                              ),
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.contacts.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey.shade200,
                          indent: screenWidth * 0.04,
                          endIndent: screenWidth * 0.04,
                        ),
                        itemBuilder: (context, index) {
                          final contact = widget.contacts[index];
                          return _buildContactTile(
                            contact,
                            screenWidth,
                            screenHeight,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    ContactModel contact,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.015,
      ),
      child: Row(
        children: [
          // Contact Avatar
          CircleAvatar(
            radius: screenWidth * 0.06,
            backgroundColor: ColorHelpers.accentColor.withOpacity(0.2),
            child: CustomText(
              text: contact.name.isNotEmpty
                  ? contact.name[0].toUpperCase()
                  : 'C',
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.045,
              color: ColorHelpers.accentColor,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),

          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: contact.name,
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
                  color: ColorHelpers.secondaryColor,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: screenHeight * 0.003),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.grey.shade600,
                      size: screenWidth * 0.03,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Flexible(
                      child: CustomText(
                        text: contact.phoneNumber,
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.033,
                        color: ColorHelpers.secondaryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.002),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.grey.shade600,
                      size: screenWidth * 0.03,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Flexible(
                      child: CustomText(
                        text: contact.email,
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.033,
                        color: ColorHelpers.secondaryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              // Remove Button
              InkWell(
                onTap: () => _showRemoveConfirmation(contact),
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.userMinus,
                    color: Colors.orange,
                    size: screenWidth * 0.04,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              // Delete Button
              InkWell(
                onTap: () => _showDeleteConfirmation(contact),
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                    size: screenWidth * 0.04,
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
