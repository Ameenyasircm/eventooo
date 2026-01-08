import 'package:evento/Boys/Screens/home/boy_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Constants/colors.dart';
import '../../Providers/boys_provider.dart';
import '../menu/menu_screen.dart';

class BoyBottomNavBar extends StatefulWidget {
  final String boyName,boyID,boyPhone;
  const BoyBottomNavBar({super.key,required this.boyName,required this.boyID,required this.boyPhone});

  @override
  State<BoyBottomNavBar> createState() => _BoyBottomNavBarState();
}

class _BoyBottomNavBarState extends State<BoyBottomNavBar> {
  late int _currentPage;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _currentPage = 0;

    _screens = [
      BoyHome(boyName: '', boyID: 'BOY1767671079465', boyPhone: ''),
      MenuScreen(),
    ];
  }


  void _onTabSelected(int index) {
    setState(() {
      _currentPage = index;
    });

    // Call functions based on tab index
    switch (index) {
      case 0:
        _onHomeTab();
        break;
      case 1:
        _onBoysTab();
        break;
      case 2:
        _onMenuTab();
        break;
    }
  }

  void _onHomeTab() {
    print("Home tab clicked");
    // Example:
    // context.read<HomeProvider>().fetchDashboard();
  }

  void _onBoysTab() {
    print("Boys tab clicked");
    // final boyProvider = Provider.of<BoysProvider>(context, listen: false);
    // boyProvider.fetchBoys();
  }

  void _onMenuTab() {
    print("Menu tab clicked");
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        // Display the body based on the selected index
        body: IndexedStack(
          index: _currentPage,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (index) {
            setState(() {
              _onTabSelected(index);
              _currentPage = index;
            });
          },
          // Styling to match your image
          backgroundColor:  blue7E, // Dark blue background
          selectedItemColor: red22, // Orange for active
          unselectedItemColor: Colors.white, // White for inactive
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home), // Solid home when active
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
        ),
      );
  }
}
