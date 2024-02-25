// ignore_for_file: file_names

import 'package:flutter/material.dart';

class UpdateOrCreateLogs extends StatefulWidget {
  const UpdateOrCreateLogs({super.key});

  @override
  State<UpdateOrCreateLogs> createState() => _UpdateOrCreateLogs();
}

class _UpdateOrCreateLogs extends State<UpdateOrCreateLogs> {
  List<TextEditingController> listController = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listController.length,
                itemBuilder: (context, index) {
                  return Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E384E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: listController[index],
                              autofocus: false,
                              style: const TextStyle(color: Color(0xFFF8F8FF)),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Input Text Here",
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 132, 140, 155)),
                              ),
                            ),
                          ),
                        ),

                      ],
                    );
                  
                },
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    listController.add(TextEditingController());
                  });
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),

                    child: const Text("Add More",),
                  ),
                ),
              ),
              const SizedBox(
                width: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}