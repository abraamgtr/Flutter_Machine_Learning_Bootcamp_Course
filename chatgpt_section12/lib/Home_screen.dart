import 'dart:convert';

import 'package:chatgpt_section12/Models/Response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _promptController = TextEditingController();
  late Animation<Color?> animation;
  late AnimationController controller;
  String responseTxt = "";
  late ResponseModel _responseModel;
  bool inputEnabled = true;

  completionFun() async {
    final dio = Dio();
    setState(() {
      responseTxt = 'Thinking...';
      inputEnabled = !inputEnabled;
    });
    String prompt = _promptController.text;
    _promptController.clear();
    controller.forward();

    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      options: Options(
          sendTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
          contentType: "application/json",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${dotenv.env['token']}'
          }),
      data: jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0
        },
      ),
    );

    setState(() {
      //FocusManager.instance.primaryFocus?.unfocus();
      inputEnabled = !inputEnabled;
      try {
        Map<String, dynamic>? responseJson = Map.from(response.data);
        _responseModel = ResponseModel.fromJson(responseJson);
        responseTxt = _responseModel.choices?.content ?? "";
        debugPrint(responseTxt);
      } catch (e) {
        responseTxt = "Error in getting your response!";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 3), () {
      setState(() {
        responseTxt = "AI Course GPT";
      });
    });

    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation =
        ColorTween(begin: Colors.white, end: Colors.purple).animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343541),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Flutter and ChatGPT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff343541),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
              child: Align(
            alignment: Alignment.center,
            child: !inputEnabled
                ? AnimatedBuilder(
                    animation: animation,
                    builder: (ctx, child) {
                      return Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          color: animation.value,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      );
                    },
                  )
                : Icon(
                    Icons.computer,
                    color: Colors.white.withOpacity(0.3),
                    size: 120.0,
                  ),
          )),
          Positioned.fill(
              child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child:
                      Center(child: PromptBuilder(responseText: responseTxt))),
              Expanded(
                child: TextFormFieldBuilder(
                  promptController: _promptController,
                  btnFunc: () {
                    completionFun();
                  },
                  enabled: inputEnabled,
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}

class PromptBuilder extends StatelessWidget {
  const PromptBuilder({super.key, required this.responseText});

  final String responseText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.35,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Text(
              responseText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFormFieldBuilder extends StatelessWidget {
  TextFormFieldBuilder(
      {super.key,
      required this.promptController,
      required this.btnFunc,
      required this.enabled});

  final TextEditingController promptController;
  final Function btnFunc;
  final bool enabled;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Row(
          children: [
            Flexible(
                child: Form(
              key: _formKey,
              child: TextFormField(
                cursorColor: Colors.white,
                enabled: enabled,
                controller: promptController,
                autofocus: false,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter something";
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff444653),
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xff4444653),
                    )),
                    filled: true,
                    fillColor: Color(0xff4444653),
                    errorStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    hintText: "Please write for me Something!!!"),
              ),
            )),
            Container(
              color: const Color(0xff19bc99),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IgnorePointer(
                  ignoring: !enabled,
                  child: Opacity(
                    opacity: !enabled ? 0.5 : 1.0,
                    child: IconButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          btnFunc();
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
