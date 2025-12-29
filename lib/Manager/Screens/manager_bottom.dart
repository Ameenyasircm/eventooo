import 'package:evento/Boys/Providers/boys_provider.dart';
import 'package:flutter/material.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'all_boys_screen.dart';
import 'manager_home_screen.dart';
import 'manager_menu_screen.dart';
import 'package:provider/provider.dart';

class ManagerBottom extends StatefulWidget {
  String adminID,adminName;
  int initialIndex=0;
  ManagerBottom({Key? key,required this.adminID,required this.adminName}) : super(key: key);

  @override
  State<ManagerBottom> createState() => _ManagerBottomState();
}

class _ManagerBottomState extends State<ManagerBottom> {

  late int _currentPage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Start with 0 temporarily
    _currentPage = 0;


    // Wait for next frame, then update to actual initial index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex != 0) {
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            _currentPage = widget.initialIndex;
          });

          // Trigger data fetch for the initial page
          if (widget.initialIndex == 0) {
          }
          if (widget.initialIndex == 1) {
          }
          if (widget.initialIndex == 2) {
          }
        });
      }
    });
  }

  final List<Widget> _screens = [
    ManagerHomeScreen(),
    BoysListScreen(),
    ManagerMenuScreen(),
  ];

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
    final boyProvider =
    Provider.of<BoysProvider>(context, listen: false);
    boyProvider.fetchBoys();
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
          backgroundColor: const Color(0xff1A237E), // Dark blue background
          selectedItemColor: const Color(0xffFF5722), // Orange for active
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
              icon: Icon(Icons.groups_outlined),
              label: 'Boys',
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
