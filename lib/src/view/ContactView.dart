import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

import '../bloc/ContactBloc.dart';
import '../helpers/ColorHelpers.dart';
import '../model/ContactModel.dart';
import '../widget/AddContactDialog.dart';
import '../widget/AddPurokDialog.dart';
import '../widget/CustomSearchBar.dart';
import '../widget/CustomText.dart';
import '../widget/PurokContactCard.dart';

class ContactView extends StatelessWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _ContactViewContent();
  }
}

class _ContactViewContent extends StatefulWidget {
  const _ContactViewContent({Key? key}) : super(key: key);

  @override
  State<_ContactViewContent> createState() => _ContactViewContentState();
}

class _ContactViewContentState extends State<_ContactViewContent> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ContactBloc>().add(LoadContactsEvent());
  }

  void _removeContact(BuildContext context, ContactModel contact) {
    context.read<ContactBloc>().add(
      DeleteContactEvent(purokId: contact.purokNumber, contactId: contact.id),
    );
  }

  void _deleteContact(BuildContext context, ContactModel contact) {
    context.read<ContactBloc>().add(
      DeleteContactEvent(purokId: contact.purokNumber, contactId: contact.id),
    );
  }

  void _addPurok(String purokId) {
    context.read<ContactBloc>().add(AddPurokEvent(purokId: purokId));
  }

  void _addContact(String purokId, ContactModel contact) {
    context.read<ContactBloc>().add(
      AddContactEvent(purokId: purokId, contact: contact),
    );
  }

  Future<bool> _checkDuplicate(String name, String phone) async {
    return await context.read<ContactBloc>().checkDuplicate(name, phone);
  }

  void _showAddPurokDialog() {
    showDialog(
      context: context,
      builder: (context) => AddPurokDialog(onAddPurok: _addPurok),
    );
  }

  void _showAddContactDialog(String purokId) {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(
        purokId: purokId,
        onAddContact: _addContact,
        onCheckDuplicate: _checkDuplicate,
      ),
    );
  }

  Map<String, List<ContactModel>> _getFilteredPurokContacts(
    Map<String, List<ContactModel>> purokContacts,
  ) {
    if (_searchQuery.isEmpty) {
      return purokContacts;
    }

    Map<String, List<ContactModel>> filtered = {};

    purokContacts.forEach((purok, contacts) {
      List<ContactModel> filteredContacts = contacts.where((contact) {
        return contact.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            contact.phoneNumber.contains(_searchQuery) ||
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
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        if (state is ContactLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ContactError) {
          return Scaffold(body: Center(child: Text('Error: ${state.message}')));
        } else if (state is ContactLoaded) {
          final filteredContacts = _getFilteredPurokContacts(
            state.purokContacts,
          );
          return _buildContent(context, filteredContacts);
        }
        return const Scaffold(body: Center(child: Text('No data')));
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    Map<String, List<ContactModel>> purokContacts,
  ) {
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
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plus),
            onPressed: _showAddPurokDialog,
          ),
        ],
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
                color: ColorHelpers.secondaryColor,
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
              color: ColorHelpers.primaryColor,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
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
                  purokContacts.keys.length.toString(),
                  FontAwesomeIcons.mapMarkerAlt,
                  ColorHelpers.accentColor,
                ),
                _buildStatItem(
                  'Total Contacts',
                  purokContacts.values
                      .expand((contacts) => contacts)
                      .length
                      .toString(),
                  FontAwesomeIcons.users,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Active Puroks',
                  purokContacts.values
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
            child: purokContacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.searchLocation,
                          size: screenWidth * 0.16,
                          color: ColorHelpers.secondaryColor.withOpacity(0.4),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text: 'No contacts found',
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.045,
                          color: ColorHelpers.secondaryColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomText(
                          text: 'Try adjusting your search criteria',
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.035,
                          color: ColorHelpers.secondaryColor.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    itemCount: purokContacts.keys.length,
                    itemBuilder: (context, index) {
                      final purokNumber = purokContacts.keys.elementAt(index);
                      final contacts = purokContacts[purokNumber] ?? [];

                      return PurokContactCard(
                        purokNumber: purokNumber,
                        contacts: contacts,
                        onRemoveContact: _removeContact,
                        onDeleteContact: _deleteContact,
                        onAddContact: _showAddContactDialog,
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
            color: ColorHelpers.secondaryColor.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
