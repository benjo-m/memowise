import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/achievement_dto.dart';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddAchievementDialog extends StatefulWidget {
  const AddAchievementDialog(
      {super.key, required this.data, required this.onAdd});

  final Function(AchievementResponse) onAdd;
  final List<AchievementResponse> data;

  @override
  State<AddAchievementDialog> createState() => _AddAchievementDialogState();
}

class _AddAchievementDialogState extends State<AddAchievementDialog> {
  late List<AchievementResponse> achievements;
  final _achievementService = AchievementService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _iconController = TextEditingController();

  @override
  void initState() {
    super.initState();
    achievements = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add Achievement")),
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
                          if (achievements.any((item) {
                            log(item.name);
                            return item.name.toLowerCase() ==
                                value.toLowerCase();
                          })) {
                            return "Name already taken";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Name"),
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
                      onPressed: () => Navigator.pop(context),
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
                              icon: _iconController.text);
                          final response = await create(request);
                          widget.onAdd(response);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Add"),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<AchievementResponse> create(AchievementDto updatedAchievement) async {
    final response =
        await _achievementService.create(updatedAchievement.toJson());

    return response!;
    // setState(() {
    //   // achievements.add(response!);
    //   widget.data.add(response!);
    // });
  }
}
