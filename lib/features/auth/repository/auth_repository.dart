import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';

//implementing dependency injection using riverpod

// Dependency injection is simply a way of making a class independent of its own dependencies.
// It allows you to separate different parts of your application in a more maintainable way,
//because every class can make calls to any dependency it needs

//provider ref basically allows us to interact with other providers, for eg here we have a authrepoprovider and then we have a auth
//authcontrollerprovider , so if we want that authcontrollerprovider to access that authrepository provider we need to use the provider "ref"
final authRepositoryProvider = Provider(
    (ref) => AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository(
    this.auth,
    this.firestore,
  );
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60), //auto-resolution timeout
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            if (e.code == 'invalid-phone-number') {
              showSnackBar(
                  context: context, content: "The Phone Number is Invalid");
            }
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushReplacementNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) =>
              {}); //autoresulation has timed out
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message.toString());
    }
  }

  void verifyOTP({
    required BuildContext context, //very important to display errors
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushNamedAndRemoveUntil(
          UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message.toString());
    }
  }

  void sendDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.nicepng.com%2Fourpic%2Fu2a9o0o0w7e6o0y3_png-file-svg-people-icon-png%2F&psig=AOvVaw0d9_l1vXQGX_QVm25G4xtN&ust=1669446852689000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCMDozKfkyPsCFQAAAAAdAAAAABAE";
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFiletoFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true, //because the user has just created a profile
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );
      firestore.collection("users").doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileLayoutScreen(),
          ),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userid) {
    return firestore.collection('users').doc(userid).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }
}
