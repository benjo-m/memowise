import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_dto.dart';

class AddCardDialog extends StatefulWidget {
  const AddCardDialog({
    super.key,
    required this.onCancel,
    required this.onAdd,
  });

  final VoidCallback onCancel;
  final Function(CardDto) onAdd;

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.all(10),
      title: const Center(child: Text("Add Card")),
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: _questionController,
                  minLines: 5,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    label: Text(
                      "Question",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _answerController,
                  minLines: 5,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    label: Text(
                      "Answer",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => widget.onCancel(),
                        child: const Text("Cancel")),
                    ElevatedButton(
                      onPressed: () {
                        var cardCreateRequest = CardDto(
                            question: _questionController.text,
                            answer: _answerController.text);
                        widget.onAdd(cardCreateRequest);
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
