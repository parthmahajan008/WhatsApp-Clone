import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_ui/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final name = args['name'];
      final uid = args['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: "page does not exist"),
              ));
  }
}
