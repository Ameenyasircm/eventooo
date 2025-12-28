import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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


  // Controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController boysController = TextEditingController();

  String selectedMeal = 'Lunch';

  /// 📅 Date Picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1A237E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      notifyListeners();
    }
  }

  /// 🍽 Meal Change
  void changeMeal(String value) {
    selectedMeal = value;
    notifyListeners();
  }

  /// ✅ Submit
  void submit(BuildContext context) {

    // 🔥 API / Firestore call goes here
    debugPrint("Event Created");
    debugPrint(nameController.text);
    debugPrint(dateController.text);
    debugPrint(selectedMeal);
    debugPrint(locationController.text);
    debugPrint(boysController.text);
    debugPrint(descController.text);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    dateController.dispose();
    nameController.dispose();
    descController.dispose();
    locationController.dispose();
    boysController.dispose();
    super.dispose();
  }

}