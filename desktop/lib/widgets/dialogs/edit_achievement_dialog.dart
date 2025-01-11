import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/achievement_dto.dart';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/exceptions/exceptions.dart';
import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditAchievementDialog extends StatefulWidget {
  const EditAchievementDialog(
      {super.key, required this.achievement, required this.onEdit});

  final AchievementResponse achievement;
  final Function() onEdit;

  @override
  State<EditAchievementDialog> createState() => _EditAchievementDialogState();
}

class _EditAchievementDialogState extends State<EditAchievementDialog> {
  final _achievementService = AchievementService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _iconController = TextEditingController();
  String? _nameErrorText;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.achievement.name;
    _descriptionController.text = widget.achievement.description;
    _iconController.text = widget.achievement.icon;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Achievement")),
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
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Description"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _iconController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Icon is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Icon"),
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
                          final request = AchievementDto(
                            name: _nameController.text,
                            description: _descriptionController.text,
                            icon: _iconController.text,
                          );
                          final response =
                              await edit(widget.achievement.id, request);
                          if (response == null) {
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

  Future<AchievementResponse?> edit(
      int id, AchievementDto updatedAchievement) async {
    try {
      final response =
          await _achievementService.update(id, updatedAchievement.toJson());
      return response;
    } on AchievementNameTakenException {
      setState(() => _nameErrorText = "Name taken");
      return null;
    }
  }
}
