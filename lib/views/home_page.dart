// ignore_for_file: file_names
import 'package:money_logger/constants/colour_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: backgroundColour,
      body:Center(
       child:SvgPicture.asset('assets/icons/Logo.svg'),
      ),
    );
  }
}

/*
Text("Money Logger",
         textScaler: TextScaler.linear(5),
         style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
         fontWeight: FontWeight.w900), 

       ),*/