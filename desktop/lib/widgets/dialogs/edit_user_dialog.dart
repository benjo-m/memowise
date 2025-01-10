import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/user_dto.dart';
import 'package:desktop/dto/user_response.dart';
import 'package:desktop/exceptions/exceptions.dart';
import 'package:desktop/services/user_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditUserDialog extends StatefulWidget {
  const EditUserDialog({super.key, required this.onEdit, required this.user});

  final Function() onEdit;
  final UserResponse user;

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _userService = UserService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isAdmin = false;
  bool _isPremium = false;
  late DateTime _createdAt;

  String? _usernameErrorText;
  String? _emailErrorText;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.username;
    _isAdmin = widget.user.isAdmin;
    _isPremium = widget.user.isPremium;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add Payment Record")),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Username is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text("Username"),
                          errorText: _usernameErrorText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          errorText: _emailErrorText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputDatePickerFormField(
                        errorFormatText: "Invalid Date",
                        onDateSaved: (DateTime date) {
                          setState(() => _createdAt = date);
                        },
                        fieldLabelText: "Created At",
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().add(const Duration(days: -365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Is Admin?"),
                          Checkbox(
                            activeColor: Colors.blueAccent,
                            checkColor: Colors.white,
                            value: _isAdmin,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAdmin = value!;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          const Text("Is Premium?"),
                          Checkbox(
                            activeColor: Colors.blueAccent,
                            checkColor: Colors.white,
                            value: _isPremium,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPremium = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buttonsRow(context)
              ],
            ),
          ),
        )
      ],
    );
  }

  Row buttonsRow(BuildContext context) {
    return Row(
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
              _formKey.currentState!.save();
              final request = UserDto(
                createdAt: _createdAt,
                email: _emailController.text,
                username: _usernameController.text,
                isAdmin: _isAdmin,
                isPremium: _isPremium,
                password: "",
              );
              final response = await edit(widget.user.id, request);
              if (response == null) {
                return;
              }
              if (context.mounted) {
                widget.onEdit();
                Navigator.pop(context);
              }
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }

  Future<UserResponse?> edit(int id, UserDto request) async {
    try {
      final response = await _userService.update(id, request.toJson());
      return response;
    } on UsernameTakenException {
      setState(() {
        _usernameErrorText = "Username taken";
      });
      return null;
    } on EmailAlreadyInUseException {
      setState(() {
        _emailErrorText = "Email already in use";
      });
      return null;
    }
  }
}
