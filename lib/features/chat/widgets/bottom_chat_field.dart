//import material package
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: ((value) {
                if (value.isNotEmpty) {
                  setState(() {
                    isShowSendButton = true;
                  });
                } else {
                  setState(() {
                    isShowSendButton = false;
                  });
                }
              }),
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.gif,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                suffixIcon: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: 'Type a message!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 2.0, left: 2.0),
            child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: Icon(
                  isShowSendButton ? Icons.send : Icons.mic,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
