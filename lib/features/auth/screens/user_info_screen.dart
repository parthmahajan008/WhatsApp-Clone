import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController namecontroller = TextEditingController();
  final String networkimageaddress =
      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.nicepng.com%2Fourpic%2Fu2a9o0o0w7e6o0y3_png-file-svg-people-icon-png%2F&psig=AOvVaw0d9_l1vXQGX_QVm25G4xtN&ust=1669446852689000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCMDozKfkyPsCFQAAAAAdAAAAABAE";
  File? image;
  @override
  void dispose() {
    super.dispose();
    namecontroller.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = namecontroller.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(networkimageaddress),
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 64,
                      ),
                Positioned(
                  left: -10,
                  bottom: -10,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: namecontroller,
                    decoration:
                        const InputDecoration(hintText: "Enter Name here"),
                  ),
                ),
                IconButton(
                    onPressed: storeUserData,
                    icon: const Icon(
                      Icons.done,
                    )),
              ],
            )
          ],
        ),
      )),
    );
  }
}
