import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile/services/image_upload_service.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
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
      appBar: AppBar(
        title: const Text('Add New Card'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text(
                "Question",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextField(
                controller: _questionController,
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              _questionImage == null
                  ? Column(
                      children: [
                        const Text(
                          "Question Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _uploadQuestionImage,
                          icon: const Icon(Icons.upload_rounded),
                          label: const Text(
                            'Upload',
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          "Question Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 3.0,
                                color: Colors.grey,
                              ),
                            ),
                            child: Image.memory(
                              _questionImage!,
                              height: 200,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  _questionImage = null;
                                });
                              },
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ]),
                      ],
                    ),
              Divider(
                height: 60,
              ),
              Column(
                children: [
                  const Text(
                    " Answer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: _answerController,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _answerImage != null
                  ? Column(
                      children: [
                        const Text(
                          " Answer Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 3.0,
                                color: Colors.grey,
                              ),
                            ),
                            child: Image.memory(
                              _answerImage!,
                              height: 200,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  _answerImage = null;
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.delete, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          " Answer Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _uploadAnswerImage,
                          icon: const Icon(Icons.upload_rounded),
                          label: const Text(
                            'Upload',
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 90),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement save functionality
                  final question = _questionController.text;
                  final answer = _answerController.text;
                  if (question.isNotEmpty && answer.isNotEmpty) {
                    // Add save logic here
                  }
                },
                child: const Text('Save Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
