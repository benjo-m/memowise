import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/achievement_dto.dart';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AchievementsTable extends StatefulWidget {
  const AchievementsTable({
    super.key,
    required this.data,
  });

  final List<AchievementResponse> data;

  @override
  State<AchievementsTable> createState() => _AchievementsTableState();
}

class _AchievementsTableState extends State<AchievementsTable> {
  final _scrollController = ScrollController();
  final _achievementService = AchievementService(baseUrl, http.Client());
  late List<AchievementResponse> achievements;
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
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minWidth: MediaQuery.sizeOf(context).width * 0.93),
          child: DataTable(
            showBottomBorder: true,
            headingRowColor: const WidgetStatePropertyAll(
                Color.fromARGB(255, 226, 246, 255)),
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Id",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Name",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Description",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Actions",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            rows: achievements.map((achievement) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(achievement.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(achievement.name)),
                  ),
                  DataCell(
                    Center(child: Text(achievement.description)),
                  ),
                  DataCell(
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: blueButtonStyle,
                          onPressed: () => showEditDialog(achievement),
                          child: const Text("Edit"),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: redButtonStyle,
                          onPressed: () => showDeleteDialog(achievement.id),
                          child: const Text("Delete"),
                        ),
                      ],
                    )),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  showDeleteDialog(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Center(child: Text("Delete Achievement?")),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child:
                      Text("Are you sure you want to delete this achievement?"),
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
                    style: redButtonStyle,
                    onPressed: () {
                      delete(id);
                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          );
        });
  }

  showEditDialog(AchievementResponse achievement) async {
    setState(() {
      _nameController.text = achievement.name;
      _descriptionController.text = achievement.description;
      _iconController.text = achievement.icon;
    });
    showDialog(
        context: context,
        builder: (context) {
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
                                if (achievements.any((item) =>
                                    item.name.toLowerCase() ==
                                        value.toLowerCase() &&
                                    achievement.name.toLowerCase() !=
                                        value.toLowerCase())) {
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final request = AchievementDto(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    icon: _iconController.text);
                                edit(achievement.id, request);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Edit"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  delete(int id) async {
    await _achievementService.delete(id);
    setState(() {
      achievements.removeWhere((achievement) => achievement.id == id);
    });
  }

  edit(int id, AchievementDto updatedAchievement) async {
    final response =
        await _achievementService.update(id, updatedAchievement.toJson());

    if (response != null) {
      setState(() {
        final index =
            achievements.indexWhere((achievement) => achievement.id == id);
        if (index != -1) {
          achievements[index] = response;
        }
      });
    }
  }
}
