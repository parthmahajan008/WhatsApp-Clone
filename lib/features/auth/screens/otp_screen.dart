import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          verificationId,
          userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          title: const Text('Verifying your Number')),
      body: Center(
        child: Column(children: [
          const SizedBox(height: 20),
          const Text("We have sent an SMS with a code"),
          SizedBox(
            width: size.width * 0.5,
            child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    verifyOTP(ref, context, val.trim());
                  }
                },
                decoration: const InputDecoration(
                    hintText: "_ _ _ _ _ _",
                    hintStyle: TextStyle(fontSize: 30))),
          )
        ]),
      ),
    );
  }
}
