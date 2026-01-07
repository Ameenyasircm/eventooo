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
        title: Text(title,style: AppTypography.body1,),
        content: Column(
          children: [
            Icon(Icons.check_circle,color: Colors.green,size: 50,),
            AppSpacing.h10,
            Text(message,style: AppTypography.caption,),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child:  Text('OK',style: AppTypography.body1),
          ),
        ],
      );
    },
  );
}
