import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/user_dto.dart';
import 'package:desktop/dto/user_response.dart';
import 'package:desktop/services/user_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key, required this.onAdd});

  final Function(UserResponse?) onAdd;

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _userService = UserService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isAdmin = false;
  bool _isPremium = false;

  DateTime _createdAt = DateTime.now();

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
                        decoration: const InputDecoration(
                          label: Text("Username"),
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
                        decoration: const InputDecoration(
                          label: Text("Email"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Password"),
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
                password: _passwordController.text,
              );
              final response = await create(request);
              if (response == null) {
                return;
              }
              if (context.mounted) {
                widget.onAdd(response);
                Navigator.pop(context);
              }
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }

  Future<UserResponse?> create(UserDto request) async {
    try {
      final response = await _userService.create(request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
