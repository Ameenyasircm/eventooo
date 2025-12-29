import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/event_model.dart';

class ManagerProvider extends ChangeNotifier{

  final FirebaseFirestore db = FirebaseFirestore.instance;


  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;


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
  DateTime? eventDateTime;
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
      eventDateTime=picked;
      notifyListeners();
    }
  }

  /// 🍽 Meal Change
  void changeMeal(String value) {
    selectedMeal = value;
    notifyListeners();
  }

  void clearEventRegScreens() {
    dateController.clear();
    nameController.clear();
    descController.clear();
    locationController.clear();
    boysController.clear();
  }

  double? latitude;
  double? longitude;

  /// 📍 Save picked location
  void setLocation({
    required String address,
    required double lat,
    required double lng,
  }) {
    locationController.text = address;
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  Future<void> createEventFun(BuildContext context) async {

    if (eventDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select event date")),
      );
      return;
    }

    // if (latitude == null || longitude == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Please select event location")),
    //   );
    //   return;
    // }

    try {
      final String eventId =
          "EVT${DateTime.now().millisecondsSinceEpoch}";

      await db.collection("EVENTS").doc(eventId).set({
        "EVENT_ID": eventId,
        "EVENT_NAME": nameController.text.trim(),

        /// 👇 BOTH FORMATS
        "EVENT_DATE": dateController.text.trim(),
        "EVENT_DATE_TS": Timestamp.fromDate(eventDateTime!),

        "MEAL_TYPE": selectedMeal,
        "LOCATION_NAME": locationController.text.trim(),
        "LATITUDE": latitude,
        "LONGITUDE": longitude,
        "BOYS_REQUIRED": int.parse(boysController.text),
        "DESCRIPTION": descController.text.trim(),
        "EVENT_STATUS": "UPCOMING",
        "STATUS": "CREATED",
        "CREATED_TIME": FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event created successfully")),
      );
      fetchEvents();
    } catch (e) {
      debugPrint("Create Event Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create event")),
      );
    }
  }

  bool isLoading = false;

  List<EventModel> upcomingEventsList = [];
  List<EventModel> runningEventsList = [];

  /// 🔥 FETCH EVENTS
  Future<void> fetchEvents() async {
    upcomingEventsList.clear();
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await db
          .collection('EVENTS').where('STATUS',isEqualTo: 'CREATED')
          // .orderBy('EVENT_DATE_TS', descending: false)
          .get();


      for (var doc in snapshot.docs) {
        upcomingEventsList.add(EventModel.fromMap(doc.data()));
      }
      print(upcomingEventsList.length.toString()+' FRNFRJKF ');
    } catch (e) {
      debugPrint("Fetch Events Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }


}