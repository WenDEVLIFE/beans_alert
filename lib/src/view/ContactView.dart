import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/ColorHelpers.dart';
import '../model/ContactModel.dart';
import '../widget/CustomSearchBar.dart';
import '../widget/CustomText.dart';
import '../widget/PurokContactCard.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  String _searchQuery = '';
  late Map<String, List<ContactModel>> _purokContacts;

  @override
  void initState() {
    super.initState();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _purokContacts = {
      '1': [
        ContactModel(
          id: '1',
          name: 'Juan Dela Cruz',
          phoneNumber: '+63 912 345 6789',
          email: 'juan.delacruz@email.com',
          purokNumber: '1',
        ),
        ContactModel(
          id: '2',
          name: 'Maria Santos',
          phoneNumber: '+63 917 234 5678',
          email: 'maria.santos@email.com',
          purokNumber: '1',
        ),
        ContactModel(
          id: '3',
          name: 'Pedro Reyes',
          phoneNumber: '+63 920 123 4567',
          email: 'pedro.reyes@email.com',
          purokNumber: '1',
        ),
      ],
      '2': [
        ContactModel(
          id: '4',
          name: 'Ana Garcia',
          phoneNumber: '+63 918 765 4321',
          email: 'ana.garcia@email.com',
          purokNumber: '2',
        ),
        ContactModel(
          id: '5',
          name: 'Carlos Mendoza',
          phoneNumber: '+63 915 876 5432',
          email: 'carlos.mendoza@email.com',
          purokNumber: '2',
        ),
      ],
      '3': [
        ContactModel(
          id: '6',
          name: 'Elena Rodriguez',
          phoneNumber: '+63 919 987 6543',
          email: 'elena.rodriguez@email.com',
          purokNumber: '3',
        ),
        ContactModel(
          id: '7',
          name: 'Roberto Cruz',
          phoneNumber: '+63 916 098 7654',
          email: 'roberto.cruz@email.com',
          purokNumber: '3',
        ),
        ContactModel(
          id: '8',
          name: 'Sofia Hernandez',
          phoneNumber: '+63 921 109 8765',
          email: 'sofia.hernandez@email.com',
          purokNumber: '3',
        ),
        ContactModel(
          id: '9',
          name: 'Miguel Torres',
          phoneNumber: '+63 922 210 9876',
          email: 'miguel.torres@email.com',
          purokNumber: '3',
        ),
      ],
      '4': [], // Empty purok for demonstration
      '5': [
        ContactModel(
          id: '10',
          name: 'Isabella Martinez',
          phoneNumber: '+63 923 321 0987',
          email: 'isabella.martinez@email.com',
          purokNumber: '5',
        ),
      ],
    };
  }

  void _removeContact(ContactModel contact) {
    setState(() {
      _purokContacts[contact.purokNumber]?.remove(contact);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${contact.name} removed from Purok ${contact.purokNumber}',
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteContact(ContactModel contact) {
    setState(() {
      _purokContacts[contact.purokNumber]?.remove(contact);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${contact.name} deleted permanently'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Map<String, List<ContactModel>> get _filteredPurokContacts {
    if (_searchQuery.isEmpty) {
      return _purokContacts;
    }

    Map<String, List<ContactModel>> filtered = {};

    _purokContacts.forEach((purok, contacts) {
      List<ContactModel> filteredContacts = contacts.where((contact) {
        return contact.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            contact.phoneNumber.contains(_searchQuery) ||
            contact.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            purok.contains(_searchQuery);
      }).toList();

      if (filteredContacts.isNotEmpty || purok.contains(_searchQuery)) {
        filtered[purok] = filteredContacts;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              SvgHelpers.menulist,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'BEANS',
              fontFamily: 'Anton',
              fontSize: 30.0,
              color: Colors.black,
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
      drawer: CustomNavigationSideBar(),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.05),
              child: CustomText(
                text: 'Contact Management',
                fontFamily: 'Poppins',
                fontSize: screenWidth * 0.065,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),

          // Search Bar
          CustomSearchBar(
            hintText: 'Search contacts or purok...',
            searchQuery: _searchQuery,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),

          // Statistics Card
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: screenWidth * 0.025,
                  offset: Offset(0, screenHeight * 0.0025),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total Puroks',
                  _purokContacts.keys.length.toString(),
                  FontAwesomeIcons.mapMarkerAlt,
                  ColorHelpers.accentColor,
                ),
                _buildStatItem(
                  'Total Contacts',
                  _purokContacts.values
                      .expand((contacts) => contacts)
                      .length
                      .toString(),
                  FontAwesomeIcons.users,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Active Puroks',
                  _purokContacts.values
                      .where((contacts) => contacts.isNotEmpty)
                      .length
                      .toString(),
                  FontAwesomeIcons.checkCircle,
                  Colors.green,
                ),
              ],
            ),
          ),

          // Purok Contact Cards
          Expanded(
            child: _filteredPurokContacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.searchLocation,
                          size: screenWidth * 0.16,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text: 'No contacts found',
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.045,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomText(
                          text: 'Try adjusting your search criteria',
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    itemCount: _filteredPurokContacts.keys.length,
                    itemBuilder: (context, index) {
                      final purokNumber = _filteredPurokContacts.keys.elementAt(
                        index,
                      );
                      final contacts =
                          _filteredPurokContacts[purokNumber] ?? [];

                      return PurokContactCard(
                        purokNumber: purokNumber,
                        contacts: contacts,
                        onRemoveContact: _removeContact,
                        onDeleteContact: _deleteContact,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
          child: FaIcon(icon, color: color, size: screenWidth * 0.05),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.028,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
