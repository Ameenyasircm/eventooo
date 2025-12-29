import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoysProvider extends ChangeNotifier{

  final FirebaseFirestore db = FirebaseFirestore.instance;


  TextEditingController boyNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController guardianController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? selectedBloodGroup;
  DateTime? dobDateTime;

  void changeBloodGroup(String value) {
    selectedBloodGroup = value;
    notifyListeners();
  }

  Future<void> selectDob(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobDateTime = picked;
      dobController.text =
      "${picked.day}/${picked.month}/${picked.year}";
      notifyListeners();
    }
  }


  Future<void> registerNewBoyFun(BuildContext context) async {
    try {
      // DOB validation
      if (dobDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select date of birth")),
        );
        return;
      }

      final phone = phoneController.text.trim();

      // Phone length validation (extra safety)
      if (phone.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter valid 10 digit phone number")),
        );
        return;
      }

      /// 🔍 STEP 1: CHECK PHONE ALREADY EXISTS
      final phoneCheck = await db
          .collection("BOYS")
          .where("PHONE", isEqualTo: phone)
          .limit(1)
          .get();

      if (phoneCheck.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This phone number is already registered"),
          ),
        );
        return; // ⛔ STOP HERE
      }

      /// ✅ STEP 2: REGISTER BOY
      final boyId = "BOY${DateTime.now().millisecondsSinceEpoch}";

      await db.collection("BOYS").doc(boyId).set({
        "BOY_ID": boyId,
        "NAME": boyNameController.text.trim(),
        "PHONE": phone,
        "GUARDIAN_PHONE": guardianController.text.trim(),
        "DOB": dobController.text.trim(),
        "DOB_TS": Timestamp.fromDate(dobDateTime!),
        "BLOOD_GROUP": selectedBloodGroup,
        "PLACE": placeController.text.trim(),
        "DISTRICT": districtController.text.trim(),
        "PIN_CODE": pinController.text.trim(),
        "ADDRESS": addressController.text.trim(),
        "STATUS": "ACTIVE",
        "CREATED_TIME": FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("Boy registered successfully")),
        ),
      );

      fetchBoys();

    } catch (e) {
      debugPrint("Register Boy Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to register boy")),
      );
    }
  }

  List<Map<String, dynamic>> boysList = [];
  List<Map<String, dynamic>> filterBoysList = [];
  bool isLoadingBoys = false;
  Future<void> fetchBoys() async {
    print(' KJRNRF RF ');
    try {
      isLoadingBoys = true;
      notifyListeners();

      boysList.clear();
      filterBoysList.clear();

      final snapshot = await db
          .collection("BOYS")
          .orderBy("CREATED_TIME", descending: true)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        boysList.add(data);
      }

      // initially full list
      filterBoysList = List.from(boysList);

    } catch (e) {
      debugPrint("Fetch Boys Error: $e");
    } finally {
      isLoadingBoys = false;
      notifyListeners();
    }
  }

  void filterBoys(String query) {
    if (query.isEmpty) {
      filterBoysList = List.from(boysList);
    } else {
      filterBoysList = boysList.where((boy) {
        final name = (boy['NAME'] ?? '').toLowerCase();
        final phone = (boy['PHONE'] ?? '');
        return name.contains(query.toLowerCase()) ||
            phone.contains(query);
      }).toList();
    }
    notifyListeners();
  }




}