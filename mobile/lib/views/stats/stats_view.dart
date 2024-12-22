import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile/services/image_upload_service.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  late Uint8List? slika;

  @override
  void initState() {
    super.initState();
    ImageUploadService().fetchImage(1).then((value) {
      setState(() {
        slika = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () async =>
                await ImageUploadService().pickAndUploadImage(),
            child: const Text("Upload Image"),
          ),
          Image.memory(
            slika ?? Uint8List(0),
            width: 300,
            height: 200,
          )
        ],
      )),
    );
  }
}
