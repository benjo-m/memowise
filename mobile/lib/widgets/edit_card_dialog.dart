import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_create_request.dart';

class EditCardDialog extends StatefulWidget {
  const EditCardDialog({
    super.key,
    required this.onCancel,
    required this.onEdit,
    required this.cardCreateRequest,
  });

  final VoidCallback onCancel;
  final Function(CardCreateRequest) onEdit;
  final CardCreateRequest cardCreateRequest;

  @override
  State<EditCardDialog> createState() => _EditCardDialogState();
}

class _EditCardDialogState extends State<EditCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.cardCreateRequest.question;
    _answerController.text = widget.cardCreateRequest.answer;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.all(10),
      title: const Center(child: Text("Edit Card")),
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: _questionController,
                  minLines: 3,
                  maxLines: 3,
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
                  minLines: 3,
                  maxLines: 3,
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
                        var cardCreateRequest = CardCreateRequest(
                          question: _questionController.text,
                          answer: _answerController.text,
                        );
                        widget.onEdit(cardCreateRequest);
                      },
                      child: const Text("Edit"),
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
