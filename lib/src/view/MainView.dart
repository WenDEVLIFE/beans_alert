import 'package:beans_alert/src/bloc/UserBloc.dart';
import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/model/UserModel.dart';
import 'package:beans_alert/src/repository/RegisterRepository.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:beans_alert/src/widget/CustomSearchBar.dart';
import 'package:beans_alert/src/widget/UserCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/ColorHelpers.dart';
import '../widget/AddUserDialog.dart';
import '../widget/CustomText.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late UserBloc userbloc;
  final RegisterRepositoryImpl _repository = RegisterRepositoryImpl();
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    userbloc = UserBloc();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _repository.getAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      // Handle error silently or show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading users: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<UserModel> get _filteredUsers {
    if (_searchQuery.isEmpty) {
      return _users;
    }
    return _users.where((user) {
      return user.fullname.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.role.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
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
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
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
              fontSize: screenWidth * 0.075,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            SizedBox(width: screenWidth * 0.02),
            CustomText(
              text: 'ALERT',
              fontFamily: 'Anton',
              fontSize: screenWidth * 0.075,
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
                text: 'User Management View',
                fontFamily: 'Poppins',
                fontSize: screenWidth * 0.075,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Search Bar
          CustomSearchBar(
            hintText: 'Search users...',
            searchQuery: _searchQuery,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),

          // User Stats
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  ColorHelpers.accentColor.withOpacity(0.1),
                ],
              ),
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
                  'Total',
                  _users.length.toString(),
                  FontAwesomeIcons.users,
                  ColorHelpers.accentColor,
                ),
                _buildStatItem(
                  'Admins',
                  _users
                      .where((u) => u.role.toLowerCase() == 'admin')
                      .length
                      .toString(),
                  FontAwesomeIcons.shield,
                  Colors.red,
                ),
                _buildStatItem(
                  'Staff',
                  _users
                      .where((u) => u.role.toLowerCase() == 'staff')
                      .length
                      .toString(),
                  FontAwesomeIcons.briefcase,
                  Colors.blue,
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          // Users List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.users,
                          size: screenWidth * 0.16,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No users found'
                              : 'No users match your search',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) => const AddUserDialog(),
                            );
                            if (result != null) {
                              String fullname = result['fullName'];
                              String email = result['email'];
                              String role = result['role'];
                              String password = result['password'];

                              await userbloc.insertUser(
                                fullname,
                                email,
                                role,
                                password,
                              );
                              _loadUsers(); // Refresh the list
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.plus),
                          label: const Text('Add First User'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHelpers.accentColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadUsers,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: screenHeight * 0.1,
                        left: screenWidth * 0.02,
                        right: screenWidth * 0.02,
                      ),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        return UserCard(
                          user: _filteredUsers[index],
                          userBloc: userbloc,
                          onUserUpdated: _loadUsers,
                          onUserDeleted: _loadUsers,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const AddUserDialog(),
          );
          if (result != null) {
            String fullname = result['fullName'];
            String email = result['email'];
            String role = result['role'];
            String password = result['password'];

            await userbloc.insertUser(fullname, email, role, password);
            _loadUsers(); // Refresh the list after adding
          }
        },
        backgroundColor: ColorHelpers.accentColor,
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
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
          child: FaIcon(icon, color: color, size: screenWidth * 0.06),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
