import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.black,
      body:Center(
       child: Text("Monfdfdey Logger",
         textScaler: TextScaler.linear(5),
         style: TextStyle(color: Color.fromARGB(255, 218, 39, 39),
         fontWeight: FontWeight.w900), 

       ),
      ),
    );
  }
}