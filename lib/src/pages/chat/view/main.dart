import 'dart:core';
import 'package:ai/src/pages/appBar/drawerMenu.dart';
import 'package:ai/src/pages/appBar/index.dart';
import 'package:ai/src/pages/chat/controller/chat_controller.dart';
import 'package:ai/src/pages/chat/state/chat_state.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable

class MessagingPage extends ConsumerStatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends ConsumerState<MessagingPage> {
  final ChatController _chatController = ChatController();

   late SharedPreferences prefs;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List messages = ref.watch(messagesNotifierProvider.notifier).getMessages();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppBarHavealiens(),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 120),
              child: Column(
                mainAxisAlignment: messages.isEmpty? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  messages.isEmpty?
                  Column(
                    children: [
                      Image.asset("assets/icon.png",width: 55,height: 55,),
                      Text("ask anything you want",style: TextStyle(color: Colors.white),)
                    ],
                  )
                  :

                       Flexible(
                          child: ListView.builder(
                            controller: _chatController.scrollController,
                            shrinkWrap: true,
                            reverse: false,
                            padding: const EdgeInsets.all(10),
                            itemCount: messages.length,
                            itemBuilder: (context, i) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                child: messages[i]["role"] == "user"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                messages[i]["message"]
                                                    .toString(),
                                                softWrap: true,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Text("👻",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18)))
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 7),
                                              child: Text("👽",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18))),
                                          Flexible(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white70,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                messages[i]["message"]
                                                    .toString(),
                                                softWrap: true,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
                        ),
                  ref
                          .watch(messagesNotifierProvider.notifier)
                          .getStatusGetting()
                      ? _chatController.writeWidget()
                      : const Row(
                          children: <Widget>[
                            Flexible(
                              child: SizedBox(
                                height: 0,
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
            //messagebox
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: Form(
                  child: TextFormField(
                  
                    controller: _chatController.controller,
                    maxLength: 240,
                    maxLines: null,
                    decoration: InputDecoration(
                      suffixIcon: !ref
                              .read(messagesNotifierProvider.notifier)
                              .getStatusGetting()
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () 
                              
                              async {
                                //ref.read(messagesNotifierProvider.notifier).setChatHistory(_chatController.messagetxt);
                                _chatController.controller.clear();
                                if (_chatController.messagetxt.isNotEmpty &&
                                    !ref
                                        .read(messagesNotifierProvider.notifier)
                                        .getStatusGetting()) {
                                
                                  ref
                                      .read(messagesNotifierProvider.notifier)
                                      .addMessage({
                                    "message": _chatController.messagetxt,
                                    "role": "user"
                                  });
                                
                                  
                                  ref
                                      .read(messagesNotifierProvider.notifier)
                                      .changeGetting(true);
                
                                  setState(() {
                                    _chatController.scroolToDown(messages);
                                  });
                
                                  final returnedMessage =
                                      await _chatController.sendMessage();
                                  if (!(returnedMessage["result"] == "error")) {
                                    ref
                                        .read(messagesNotifierProvider.notifier)
                                        .addMessage(returnedMessage);
                                    ref
                                        .read(messagesNotifierProvider.notifier)
                                        .changeGetting(false);
                                    setState(() {
                                      _chatController.scroolToDown(messages);
                                    });
                              
                                  } else {
                                    ref
                                        .read(messagesNotifierProvider.notifier)
                                        .addMessage({
                                      "message":
                                          "You should be slow. Try again. Remember this i am a robot :)",
                                      "role": "assistant"
                                    });
                                    ref
                                        .read(messagesNotifierProvider.notifier)
                                        .changeGetting(false);
                                  }
                                  setState(() {
                                    _chatController.scroolToDown(messages);
                                  });
                                } else {
                                  ref
                                      .read(messagesNotifierProvider.notifier)
                                      .changeGetting(false);
                                  return;
                                }
                              },
                              icon: const Icon(Icons.send),
                            )
                          : const SizedBox(
                              height: 2.0,
                              width: 2.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      suffixIconColor: Colors.white60,
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70,width: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white,width: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: ref
                              .read(messagesNotifierProvider.notifier)
                              .getStatusGetting()
                          ? "💬"
                          : 'Message',
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (txt) {
                      _chatController.messagetxt = txt;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
