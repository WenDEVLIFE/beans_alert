import 'package:beans_alert/src/bloc/UserBloc.dart';
import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/model/UserModel.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:beans_alert/src/widget/CustomSearchBar.dart';
import 'package:beans_alert/src/widget/UserCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUsersEvent());
  }

  List<UserModel> _filteredUsers(List<UserModel> users) {
    if (_searchQuery.isEmpty) {
      return users;
    }
    return users.where((user) {
      return user.fullname.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.role.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        List<UserModel> users = [];
        bool isLoading = false;
        String? errorMessage;

        if (state is UserLoading) {
          isLoading = true;
        } else if (state is UserLoaded) {
          users = state.users;
        } else if (state is UserError) {
          errorMessage = state.message;
        }

        return Scaffold(
          backgroundColor: ColorHelpers.customblack1,
          appBar: AppBar(
            backgroundColor: ColorHelpers.primaryColor,
            leading: Builder(
              builder: (context) => IconButton(
                icon: SvgPicture.asset(
                  SvgHelpers.menulist,
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  colorFilter: const ColorFilter.mode(
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
                    color: ColorHelpers.secondaryColor,
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
                      ColorHelpers.primaryColor,
                      ColorHelpers.primaryColor.withOpacity(0.8),
                    ],
                  ),
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
                      'Total',
                      users.length.toString(),
                      FontAwesomeIcons.users,
                      ColorHelpers.accentColor,
                    ),
                    _buildStatItem(
                      'Admins',
                      users
                          .where((u) => u.role.toLowerCase() == 'admin')
                          .length
                          .toString(),
                      FontAwesomeIcons.shield,
                      Colors.red,
                    ),
                    _buildStatItem(
                      'Staff',
                      users
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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                    ? Center(
                        child: Text(
                          'Error: $errorMessage',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _filteredUsers(users).isEmpty
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
                            CustomText(
                              text: 'No users found',
                              fontFamily: 'Poppins',
                              fontSize: screenWidth * 0.04,
                              color: ColorHelpers.secondaryColor,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
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

                                  context.read<UserBloc>().add(
                                    AddUserEvent(
                                      fullname: fullname,
                                      email: email,
                                      role: role,
                                      password: password,
                                    ),
                                  );
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
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: screenHeight * 0.1,
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                        ),
                        itemCount: _filteredUsers(users).length,
                        itemBuilder: (context, index) {
                          return UserCard(
                            user: _filteredUsers(users)[index],
                            userBloc: context.read<UserBloc>(),
                          );
                        },
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

                context.read<UserBloc>().add(
                  AddUserEvent(
                    fullname: fullname,
                    email: email,
                    role: role,
                    password: password,
                  ),
                );
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
      },
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
          child: Center(
            child: FaIcon(icon, color: color, size: screenWidth * 0.06),
          ),
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
            color: ColorHelpers.secondaryColor.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
