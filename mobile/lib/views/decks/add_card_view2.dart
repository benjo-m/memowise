import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile/services/image_upload_service.dart';

class AddCardView2 extends StatefulWidget {
  const AddCardView2({super.key});

  @override
  State<AddCardView2> createState() => _AddCardView2State();
}

class _AddCardView2State extends State<AddCardView2> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  Uint8List? _questionImage;
  Uint8List? _answerImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _uploadQuestionImage() async {
    final questionImage =
        await ImageUploadService().pickAndUploadImage() ?? Uint8List(0);
    setState(() {
      _questionImage = questionImage;
    });
  }

  void _uploadAnswerImage() async {
    final answerImage =
        await ImageUploadService().pickAndUploadImage() ?? Uint8List(0);
    setState(() {
      _answerImage = answerImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Prevents overflow when the keyboard appears

      appBar: AppBar(
        title: const Text('Add New Card'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    " Front",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                controller: _questionController,
                                maxLines: null,
                              ),
                              _questionImage != null
                                  ? Stack(children: [
                                      Image.memory(
                                        _questionImage!,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.red),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _questionImage = null;
                                            });
                                          },
                                          child: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ])
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      _questionImage == null
                          ? Positioned(
                              bottom: 10,
                              right: 10,
                              child: ElevatedButton.icon(
                                onPressed: _uploadQuestionImage,
                                icon: const Icon(Icons.upload_rounded),
                                label: const Text(
                                  'Image',
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    " Back",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                controller: _answerController,
                                maxLines: null,
                              ),
                              _answerImage != null
                                  ? Stack(children: [
                                      Image.memory(
                                        _answerImage!,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.red),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _questionImage = null;
                                            });
                                          },
                                          child: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ])
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      _answerImage == null
                          ? Positioned(
                              bottom: 10,
                              right: 10,
                              child: ElevatedButton.icon(
                                onPressed: _uploadAnswerImage,
                                icon: const Icon(Icons.upload_rounded),
                                label: const Text(
                                  'Image',
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: null, child: const Text('Save Card')),
                  ElevatedButton(
                      onPressed: null, child: const Text('Save Card')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
