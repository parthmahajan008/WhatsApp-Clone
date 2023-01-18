import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

import '../../../models/user_model.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;
  //generate constructor
  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    //get contacts from firebase
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedcontact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedphoneNumber =
            selectedcontact.phones[0].number.replaceAll(' ', '');
        if (selectedphoneNumber == userData.phoneNumber) {
          print('hi');
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }
      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This user is not registered',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
