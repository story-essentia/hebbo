import 'package:flutter/material.dart';
import '../main.dart';

class NotificationService {
  static void showSnackBar(String message, {String? actionLabel, VoidCallback? onAction}) {
    // Clear current snackbars to avoid stacking as per Edge Cases concern in spec
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        action: actionLabel != null 
          ? SnackBarAction(
              label: actionLabel, 
              onPressed: onAction ?? () {},
              textColor: Colors.blueAccent, // Premium design touch
            ) 
          : null,
      ),
    );
  }
  
  static void showStorageFullError() {
    showSnackBar(
      "Could not save session data. Your device storage may be full.",
      actionLabel: "OK",
    );
  }
}
