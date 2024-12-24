import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/services/image_picker_service.dart';

class EditCardView extends StatefulWidget {
  const EditCardView({
    super.key,
    required this.onEdit,
    required this.cardDto,
  });

  final Function(CardDto) onEdit;
  final CardDto cardDto;

  @override
  State<EditCardView> createState() => _EditCardViewState();
}

class _EditCardViewState extends State<EditCardView> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  Uint8List? _questionImage;
  Uint8List? _answerImage;

  final FocusNode _questionFocusNode = FocusNode();
  final FocusNode _answerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.cardDto.question;
    _answerController.text = widget.cardDto.answer;
    if (widget.cardDto.questionImage != null &&
        widget.cardDto.questionImage != '') {
      _questionImage = base64Decode(widget.cardDto.questionImage ?? '');
    }
    if (widget.cardDto.answerImage != null &&
        widget.cardDto.answerImage != '') {
      _answerImage = base64Decode(widget.cardDto.answerImage ?? '');
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _uploadQuestionImage() async {
    final questionImage =
        await ImagePickerService().pickImage() ?? Uint8List(0);
    setState(() {
      _questionImage = questionImage;
    });
  }

  void _uploadAnswerImage() async {
    final answerImage = await ImagePickerService().pickImage() ?? Uint8List(0);
    setState(() {
      _answerImage = answerImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Card'),
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
                    " Question",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _questionFocusNode.requestFocus(),
                        child: Container(
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
                                  focusNode: _questionFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your question here',
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
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _questionImage == null
                          ? Positioned(
                              bottom: 10,
                              right: 10,
                              child: ElevatedButton.icon(
                                onPressed: () => _uploadQuestionImage(),
                                icon: const Icon(Icons.upload_rounded),
                                label: const Text(
                                  'Image',
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    " Answer",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _answerFocusNode.requestFocus(),
                        child: Container(
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
                                  focusNode: _answerFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your answer here',
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
                                                _answerImage = null;
                                              });
                                            },
                                            child: const Icon(Icons.delete,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ])
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _answerImage == null
                          ? Positioned(
                              bottom: 10,
                              right: 10,
                              child: ElevatedButton.icon(
                                onPressed: () => _uploadAnswerImage(),
                                icon: const Icon(Icons.upload_rounded),
                                label: const Text(
                                  'Image',
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 243, 83, 71)),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      fixedSize: WidgetStatePropertyAll(Size(150, 45)),
                      side: WidgetStatePropertyAll(
                        BorderSide(
                          width: 2,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Cancel"),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      finishEdit(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color(blue)),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      fixedSize: WidgetStatePropertyAll(Size(150, 45)),
                      side: WidgetStatePropertyAll(
                        BorderSide(
                          width: 2,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Edit Card"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void finishEdit(BuildContext context) {
    if (isCardEmpty()) {
      Navigator.pop(context);
      return;
    }

    final cardDto = CardDto(
      question: _questionController.text,
      answer: _answerController.text,
      questionImage: base64Encode(_questionImage ?? Uint8List(0)),
      answerImage: base64Encode(_answerImage ?? Uint8List(0)),
    );
    widget.onEdit(cardDto);
    Navigator.pop(context);
  }

  bool isCardEmpty() {
    return _questionController.text.trim().isEmpty &&
        _answerController.text.trim().isEmpty &&
        _questionImage == null &&
        _answerImage == null;
  }
}
