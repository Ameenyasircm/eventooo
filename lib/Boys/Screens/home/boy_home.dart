
import 'package:evento/Boys/Screens/home/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'widgets/work_tabs.dart';


class BoyHome extends StatelessWidget {
  final String boyName,boyID,boyPhone;
  const BoyHome({super.key,required this.boyName,required this.boyID,required this.boyPhone});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const ProfileHeader(),
              const WorkTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    AvailableWorksTab(userId: boyID,),
                     ConfirmedWorksTab(userId: boyID),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

