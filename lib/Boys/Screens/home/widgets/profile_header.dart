import 'package:evento/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Constants/colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           CircleAvatar(
            radius: 26.r,
              backgroundColor: grey2c,
            // backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'spine test boy onne',
                  style: AppTypography.body1,
                ),
                AppSpacing.h2,
                 Text(
                  'BOY_A\n9058001001',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


