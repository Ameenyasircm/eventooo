import 'dart:io';

import 'package:flutter/cupertino.dart';

class ManagerProvider extends ChangeNotifier{


  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  // Mock Data - In a real app, you'd fetch this from an API
  List<Map<String, String>> upcomingEvents = [
    {"date": "12/01/2026", "title": "Rose launch- Ibrahimka's Son's Wedding", "boys": "20"},
    {"date": "15/01/2026", "title": "Grand Plaza Catering", "boys": "15"},
  ];

  List<Map<String, String>> runningEvents = [
    {"date": "28/12/2025", "title": "Ongoing Reception - City Hall", "boys": "10"},
  ];

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

}