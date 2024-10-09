import 'dart:core';
import 'package:ai/src/pages/appBar/drawerMenu.dart';
import 'package:ai/src/pages/appBar/index.dart';
import 'package:ai/src/pages/image/controller/image_controller.dart';
import 'package:ai/src/pages/image/state/image_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagePage extends ConsumerStatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends ConsumerState<ImagePage> {
  final ImageController _imageController = ImageController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List messages = ref.watch(imagesNotifierProvider.notifier).getMessages();

    return Scaffold(
      appBar: const AppBarHavealiens(),
      drawer: const  DrawerMenu(),
      backgroundColor:  Colors.black,
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
                      const Text("create anything you want",style: TextStyle(color: Colors.white),)
                    ],
                  )
                  :
                   Flexible(
                          child: ListView.builder(
                            controller: _imageController.scrollController,
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
                                              child: CachedNetworkImage(
                                                imageUrl: messages[i]["message"]
                                                    .toString(),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                         const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            color: Colors.white,
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              _imageController.downloadToImage(
                                                  messages[i]["message"]
                                                      .toString());
                                            },
                                            icon: const Icon(
                                              Icons.download,
                                            ),
                                          )
                                        ],
                                      ),
                              );
                            },
                          ),
                        ),
                  ref.watch(imagesNotifierProvider.notifier).getStatusGetting()
                      ? _imageController.writeWidget()
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
              child: Form(
                child: TextFormField(
                  controller: _imageController.controller,
                  maxLength: 240,
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: !ref
                            .read(imagesNotifierProvider.notifier)
                            .getStatusGetting()
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              _imageController.controller.clear();
                              if (_imageController.messagetxt.isNotEmpty &&
                                  !ref
                                      .read(imagesNotifierProvider.notifier)
                                      .getStatusGetting()) {
                                ref
                                    .read(imagesNotifierProvider.notifier)
                                    .addMessage({
                                  "message": _imageController.messagetxt,
                                  "role": "user"
                                });
                                ref
                                    .read(imagesNotifierProvider.notifier)
                                    .changeGetting(true);

                                setState(() {
                                  _imageController.scroolToDown(messages);
                                });

                                final returnedMessage =
                                    await _imageController.sendMessage();
                                if (!(returnedMessage["result"] == "error")) {
                                  ref
                                      .read(imagesNotifierProvider.notifier)
                                      .addMessage(returnedMessage);
                                  ref
                                      .read(imagesNotifierProvider.notifier)
                                      .changeGetting(false);
                                  setState(() {
                                    _imageController.scroolToDown(messages);
                                  });
                                } else {
                                  print("girdi");
                                  ref
                                      .read(imagesNotifierProvider.notifier)
                                      .addMessage({
                                    "message":
                                        "You should be slow. Try again. Remember this i am a robot :)",
                                    "role": "assistant"
                                  });
                                  ref
                                      .read(imagesNotifierProvider.notifier)
                                      .changeGetting(false);
                                }
                                setState(() {
                                  _imageController.scroolToDown(messages);
                                });
                              } else {
                                ref
                                    .read(imagesNotifierProvider.notifier)
                                    .changeGetting(false);
                                return;
                              }
                            },
                            icon: const Icon(Icons.send),
                          )
                        : const SizedBox(
                            height: 2.0,
                            width: 2.0,
                            child: Center(child: CircularProgressIndicator()),
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
                            .read(imagesNotifierProvider.notifier)
                            .getStatusGetting()
                         ? "💬"
                        : 'Photo content',
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (txt) {
                    _imageController.messagetxt = txt;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
