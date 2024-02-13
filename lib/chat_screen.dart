import 'dart:convert';
import 'dart:io';

import 'package:chatpro/api_call.dart';
import 'package:chatpro/global.dart';
import 'package:chatpro/query_model.dart';
import 'package:chatpro/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController searchController = TextEditingController();
  List<QueryModel> chat = [];
  bool loading = false;
  File? images;
  double temperature = 0;

  void selectImages() async {
    var res = await pickImages();

    setState(() {
      images = res;
    });
    if (images == null) {
      return;
    }
  }

  final ScrollController _scrollController = ScrollController();

  void handleSubmit() async {
    String res;
    setState(() {
      loading = true;
    });
    if (images == null) {
      res = await ApiCall().getRawData(searchController.text, temperature);
    } else {
      res = await ApiCall()
          .getImageData(searchController.text, images!, temperature);
    }
    setState(() {
      loading = false;
    });
    String base64Image = "";
    if (images != null) {
      base64Image = base64Encode(await images!.readAsBytes());
    }

    setState(() {
      chat.add(QueryModel(
          query: searchController.text, content: res, image: base64Image));
      searchController.text = "";
      images = null;
    });
  }

  int activation = 1;

  // final FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    print("Speak");
    // await flutterTts.setLanguage("en-US");
    // await flutterTts.setPitch(1);
    // await flutterTts.speak(text);
    print("Voice");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: GlobalTheme().backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.filter_list_rounded),
        title: const Text(
          "Pro Gemini",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loading == true && chat.isEmpty
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : chat.isEmpty
                  ? Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Welcome to ",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Text(
                              "ProGemini",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Ask anything, to get your answer",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Choose your model",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        activation = 0;
                                        temperature = 1;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: activation == 0
                                            ? Colors.white24
                                            : Colors.transparent,
                                      ),
                                      child: const Center(
                                          child: Text("More Creative")),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        activation = 1;
                                        temperature = 0.5;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          color: activation == 1
                                              ? Colors.white24
                                              : Colors.transparent),
                                      child: const Center(
                                          child: Text("More Balanced")),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        activation = 2;
                                        temperature = 0;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: activation == 2
                                            ? Colors.white24
                                            : Colors.transparent,
                                      ),
                                      child: const Center(
                                          child: Text("More Precise")),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // TabBar(
                            //   unselectedLabelColor: Colors.white70,
                            //   indicatorPadding:
                            //       const EdgeInsets.symmetric(horizontal: 0),
                            //   dividerColor: Colors.transparent,
                            //   labelColor: Colors.white,
                            //   indicatorSize: TabBarIndicatorSize.tab,
                            //   indicator: BoxDecoration(
                            //     color: Colors.white12,
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   tabs: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         setState(() {
                            //           temperature = 1;
                            //         });
                            //       },
                            //       child: const Tab(
                            //         text: "More Creative",
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         setState(() {
                            //           temperature = 0.5;
                            //         });
                            //       },
                            //       child: const Tab(
                            //         text: "More Balanced",
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         setState(() {
                            //           temperature = 0.0;
                            //         });
                            //       },
                            //       child: const Tab(
                            //         text: "More Precise",
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: chat.length,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  userMessageComponent(chat[index].query,
                                      chat[index].image ?? ""),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  chatMessageComponent(chat[index].content),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  index == chat.length - 1 && loading == true
                                      ? const CircularProgressIndicator()
                                      : Container()
                                ],
                              );
                            }),
                      ),
                    ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                images != null
                    ? Stack(
                        children: <Widget>[
                          Image.file(
                            images!,
                            height: 100,
                            width: size.width,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                              right: -2,
                              top: -9,
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  onPressed: () => setState(() {
                                        images = null;
                                      })))
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onSubmitted: (val) {
                            if (loading != true &&
                                searchController.text != "") {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                              );
                              handleSubmit();
                            }
                          },
                          style: const TextStyle(
                            fontSize: 16.0,
                            height: 1.5,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 20.0), // Adjust padding here

                            isDense: true, // important line
                            filled: true,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              splashColor: Colors.deepPurple,
                              onPressed: () {
                                if (loading != true &&
                                    searchController.text != "") {
                                  handleSubmit();
                                }
                              },
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            fillColor: Colors.white10,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            hintText: 'Search its value',
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () => selectImages(),
                          icon: const Icon(Icons.attach_file_outlined))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget userMessageComponent(String message, String image) {
    var size = MediaQuery.of(context).size;

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: CircleAvatar(
            radius: 17,
            child: Icon(Icons.person),
          ),
        ),
        Container(
          width: size.width * 0.65,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: const BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
              // topLeft: Radius.circular(4),
            ),
          ),
          child: Column(
            children: [
              Markdown(
                data: message,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              image != ""
                  ? Image.memory(
                      base64Decode(image),
                      height: 100,
                      width: size.width * 0.5,
                      fit: BoxFit.contain,
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget chatMessageComponent(String message) {
    var size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width * 0.68,
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          decoration: const BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              // topLeft: Radius.circular(4),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 30,
                top: 0,
                child: IconButton(
                    onPressed: () {
                      speak(message);
                    },
                    splashColor: Colors.black54,
                    icon: const Icon(
                      Icons.keyboard_voice_outlined,
                      size: 22,
                    )),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message));
                    },
                    splashColor: Colors.black54,
                    icon: const Icon(
                      Icons.copy,
                      size: 20,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Markdown(
                  data: message,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 17,
            child: Icon(
              Icons.radio_button_on,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
