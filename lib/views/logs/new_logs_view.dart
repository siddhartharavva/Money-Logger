import 'package:flutter/material.dart';

class NewLogsView extends StatefulWidget {
  const NewLogsView({super.key});

  @override
  State<NewLogsView> createState() => _NewLogsViewState();
}

class _NewLogsViewState extends State<NewLogsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Log"),
      ),
      body: const Text("Make your log here..."),  
    );
  }
}