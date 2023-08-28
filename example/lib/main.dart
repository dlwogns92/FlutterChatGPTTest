// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:example/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// import 'package:material_buttonx/materialButtonX.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainWidget(),
    );
  }
}

class MessageComponent extends StatelessWidget {
  final String writer;
  final String? message;
  final String tokenId = "";
  const MessageComponent({super.key, required this.writer, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: writer == "me" ? Alignment.bottomRight : Alignment.bottomLeft,
          padding: const EdgeInsets.symmetric(horizontal: 7.0),
          child: Text(writer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
        ),
        Container(
          alignment: writer == "me" ? Alignment.bottomRight : Alignment.bottomLeft,
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          child: Container(
            alignment: writer == "me" ? Alignment.topRight : Alignment.topLeft,
            // constraints: const BoxConstraints(
            //   minWidth: 50.0,
            //   maxWidth: 200.0,
            //   minHeight: 50.0,
            //   maxHeight: double.infinity
            // ),
            // decoration: BoxDecoration(
            //   borderRadius: const BorderRadius.all(Radius.circular(18.0)),
            //   color: writer == "me" ? Colors.amber : Colors.white60,
            // ),
            child: ElevatedButton(
              onPressed: () {  },
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message));
                Fluttertoast.showToast(msg: "Copied to clipboard");
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)
                  ),
                ),
                backgroundColor: writer == "me" ? Colors.amber : Colors.white60,
                maximumSize: const Size(200, double.infinity),
              ),
              // ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(writer == "me" ? Colors.amber : Colors.white60),
              //   maximumSize: MaterialStateProperty.all(const Size(200, double.infinity)),
              // ),
              child: Text(
                message ?? "",
                style: const TextStyle(fontSize: 15, color: Colors.black,),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MainWidget();
}

class _MainWidget extends State<MainWidget> {
  final TextEditingController _textcontroller = TextEditingController();
  final ScrollController _messageScroll = ScrollController();
  List<Widget> messageList = [];
  bool isMaxScrollPos = false;
  String modelName = kTranslateModelV3;
  String promptText = "communiCateGPT";
  List<String> stopList = ["You:"];

  late ChatGPT openAI;

  ///t => translate
  final tController = StreamController<CompleteRes?>.broadcast();

  void _sendMessage(String value) {
    if (value.isEmpty) {
      return;
    }
    setState(() {
      messageList.add(MessageComponent(writer: "me", message: value,));  
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _messageScroll.jumpTo(_messageScroll.position.maxScrollExtent);
    });
    _receiveMessage(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textcontroller.clear();
    });
  }

  void _translateSelectEventListener(String type) {
    String nextPrompt = "";
    switch (type) {
      case "Trans2Kor":
        nextPrompt = "translateToKorean";
        break;
      case "Trans2Eng":
        nextPrompt = "translateToEng";
        break;
      case "Trans2Jap":
        nextPrompt = "translateToJapanese";
        break;
      default:
        break;
    }
    setState(() {
      promptText = nextPrompt;
      modelName = kTranslateModelV3;
      stopList = [""];
    });
    Navigator.pop(context);
  }

  void _popupButtonClickEventListener(int num) {
    switch (num) {
      case 1:
        // Talk
        setState(() {
          promptText = "communiCateGPT";
          modelName = kTranslateModelV3;
          stopList = ["You:"];
        });
        break;
      case 2:
        // Translate
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Translation"),
              content: Flex(
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(onPressed: () => _translateSelectEventListener("Trans2Kor"), child: const Text("Translate To Korean"), ),
                  TextButton(onPressed: () => _translateSelectEventListener("Trans2Eng"), child: const Text("Translate To English"), ),
                  TextButton(onPressed: () => _translateSelectEventListener("Trans2Jap"), child: const Text("Translate To Japanese"), ),
                ],
              ),
            );
          },
        );
        break;
      case 3:
        // Code
        setState(() {
          promptText = "";
          modelName = kCodeTranslateModelV2;
          stopList = [""];
        });
        break;
      default:
        break;
    }
  }

  String _returnPrompt(String message) {
    switch (promptText) {
      case "communiCateGPT":
        return communiCateGPT(message: message);
      case "Trans2Kor":
        return translateToKorean(word: message);
      case "Trans2Eng":
        return translateToEng(word: message);
      case "Trans2Jap":
        return translateToJapanese(word: message);
      case "code":
        return message;
      default:
        return "";
    }
  }

  void _receiveMessage(String message) async{
    try {
      print("promptText : $promptText");
      print("modelName : $modelName");
      openAI.setToken(tokenId);

      // final request = CompleteReq(
      //   // prompt: communiCateGPT(message: message.toString()),
      //   prompt: _returnPrompt(message.toString()),
      //   max_tokens: 4000,
      //   stop: stopList,
      //   model: modelName,
      // );
      // openAI.onCompleteStream(request: request)
      //       .asBroadcastStream()
      //       .listen((res) {
      //         tController.sink.add(res);
      //       })
      //       .onError((err) {
      //         print("$err");
      //       });

      late final dynamic request;
      late final dynamic res;

      request = CompleteReq(
        // prompt: communiCateGPT(message: message.toString()),
        prompt: _returnPrompt(message.toString()),
        max_tokens: 4000,
        stop: stopList,
        model: modelName
      );
      res = await openAI.onCompleteText(request: request);
      // final res = await openAI.onCompleteText(request: request);
      for(dynamic i in res!.choices) {
          String recvMessage = i.text;
          setState(() {
            messageList.add(MessageComponent(writer: "GPT", message: recvMessage.trim(),));
          });
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (isMaxScrollPos) {
          _messageScroll.jumpTo(_messageScroll.position.maxScrollExtent);
        }
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        messageList.add(MessageComponent(writer: "GPT", message: e.runtimeType.toString(),));
      });
    }
  }

  @override
  void initState() {
    openAI = ChatGPT.instance.builder(
        tokenId,
        baseOption: HttpSetup(receiveTimeout: 20000));
    _messageScroll.addListener(() {
      if (_messageScroll.position.maxScrollExtent.toInt() == _messageScroll.offset.toInt()) {
        setState(() {
          isMaxScrollPos = true;
        });
      } else if(isMaxScrollPos == true) {
        setState(() {
          isMaxScrollPos = false;
        });
      }
    });

    // Stream stream = tController.stream;
    // stream.listen((res) {
    //   for(dynamic i in res!.choices) {
    //     String recvMessage = i.text;
    //     setState(() {
    //       messageList.add(MessageComponent(writer: "GPT", message: recvMessage.trim(),));
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    ///close stream complete text
    openAI.close();
    // tController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPT Chat"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                controller: _messageScroll,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return messageList[index];
                },
              ),
            ),
            Flexible(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PopupMenuButton(
                      icon: const Icon(Icons.apps_rounded),
                      iconSize: 30,
                      padding: const EdgeInsets.only(right: 10.0),
                      onSelected: (value) => _popupButtonClickEventListener(value),
                      itemBuilder: (context) => <PopupMenuItem> [
                        const PopupMenuItem(
                          value: 1,
                          child: Text("Talk"),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: Text("Translate"),
                        ),
                        const PopupMenuItem(
                          value: 3,
                          child: Text("Code"),
                        ),
                      ],
                    ),
                    Flexible(
                      child: TextField(
                        controller: _textcontroller,
                        onSubmitted: _sendMessage,
                        decoration: const InputDecoration.collapsed(hintText: "Send a Message", fillColor: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        onPressed: () {
                          _sendMessage(_textcontroller.value.text);
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
