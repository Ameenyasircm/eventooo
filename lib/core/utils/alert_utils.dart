import 'package:evento/core/theme/app_spacing.dart';
import 'package:evento/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

Future<void> showSuccessAlert({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title,style: AppTypography.body1,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle,color: Colors.green,size: 60,),
            AppSpacing.h10,
            Text(message,style: AppTypography.body1.copyWith(
              fontWeight: FontWeight.w500
            ),),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child:  Text('OK',style: AppTypography.body1),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
