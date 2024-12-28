import 'package:flutter/material.dart';

class ReportingView extends StatefulWidget {
  const ReportingView({super.key});

  @override
  State<ReportingView> createState() => _ReportingViewState();
}

class _ReportingViewState extends State<ReportingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reporting"),
      ),
    );
  }
}
