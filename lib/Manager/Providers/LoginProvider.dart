import 'package:evento/Constants/my_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/manager_bottom.dart';
import 'ManagerProvider.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier{

  final FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController loginphoneController = TextEditingController();

  bool otpLoader = false;
  Future<void> userAuthorized({
    required String phone,
    required String password,
    required BuildContext context,
  }) async {

    // 1. Start Loading
    otpLoader = true;
    notifyListeners();

    try {
      // 2. Firebase Query using .where
      // Note: Ensure field names "PHONE_NUMBER", "PASSWORD", and "TYPE" match your DB exactly
      QuerySnapshot query = await db
          .collection("ADMINS")
          .where("PHONE_NUMBER", isEqualTo: phone)
          .where("PASSWORD", isEqualTo: password)
          .where("TYPE", isEqualTo: "MANAGER")
          .get();

      if (query.docs.isNotEmpty) {
        Map<dynamic,dynamic> dataMap = query.docs.first.data() as Map;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String adminID =query.docs.first.id;
        String adminName =dataMap['NAME']??"";
        await prefs.setString('phone_number', phone);
        await prefs.setString('password', password);

        await prefs.setString('adminName', adminName);
        await prefs.setString('adminName', adminName);

        final managerProvider =
        Provider.of<ManagerProvider>(context, listen: false);
        managerProvider.setTabIndex(0);
        managerProvider.fetchEvents();

        callNextReplacement(ManagerBottom(adminID: adminID,adminName: adminName,), context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful"), backgroundColor: Colors.green),
        );
      } else {
        // 4. Failure: No match found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Credentials or you are not a Manager"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
      );
    } finally {
      // 5. Stop Loading
      otpLoader = false;
      notifyListeners();
    }
  }
}