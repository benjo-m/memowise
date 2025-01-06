import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/dtos/feeedback_create_request.dart';
import 'package:mobile/services/feedback_service.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Feedback"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text("Title"),
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  sendFeedback(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      const WidgetStatePropertyAll(Color(0xff03AED2)),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.014),
                  ),
                  fixedSize: WidgetStatePropertyAll(
                    Size.fromWidth(
                      MediaQuery.sizeOf(context).width * 0.4,
                    ),
                  ),
                  side: const WidgetStatePropertyAll(
                    BorderSide(
                      width: 2,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                child: const Text("Send Feedback"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendFeedback(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final feedback = FeedbackCreateRequest(
        title: _titleController.text,
        description: _descriptionController.text,
        status: "PENDING",
        submittedAt: DateTime.now(),
      );

      await FeedbackService().postFeedback(feedback);

      if (context.mounted) {
        Navigator.pop(context);
      }

      Fluttertoast.showToast(
        msg: "Feedback Sent!",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: const Color.fromARGB(255, 188, 234, 255),
        textColor: Colors.black,
        fontSize: 16,
      );
    }
  }
}
