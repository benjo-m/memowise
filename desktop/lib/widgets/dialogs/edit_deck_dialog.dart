import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/deck_dto.dart';
import 'package:desktop/dto/deck_response.dart';
import 'package:desktop/services/deck_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditDeckDialog extends StatefulWidget {
  const EditDeckDialog({super.key, required this.deck, required this.onEdit});

  final DeckResponse deck;
  final Function() onEdit;

  @override
  State<EditDeckDialog> createState() => _EditDeckDialogState();
}

class _EditDeckDialogState extends State<EditDeckDialog> {
  final _deckService = DeckService(baseUrl, http.Client());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _userIdController = TextEditingController();
  String? _nameErrorText;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.deck.name;
    _userIdController.text = widget.deck.userId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Deck")),
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.25,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text("Name"),
                          errorText: _nameErrorText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userIdController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "User ID is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("User ID"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: greyButtonStyle,
                      onPressed: () {
                        setState(() => _nameErrorText = null);
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: blueButtonStyle,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final request = DeckDto(
                            name: _nameController.text,
                            userId: int.parse(_userIdController.text),
                          );
                          final response = await edit(widget.deck.id, request);
                          if (response == null) {
                            setState(() => _nameErrorText = "Name taken");
                            return;
                          } else if (context.mounted) {
                            widget.onEdit();
                            Navigator.pop(context);
                            _nameErrorText = null;
                          }
                        }
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

  Future<DeckResponse?> edit(int id, DeckDto request) async {
    try {
      final response = await _deckService.update(id, request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
