import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_logger/constants/colour_values.dart';

class DatePickerWidget extends StatefulWidget {
    const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(     

      onTap: () {
        _showDatePicker(context);
      },
      child: Text(
        DateFormat('dd-MM-yyyy').format(_selectedDate),
        style:const TextStyle(
          color: textColour,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      helpText: 'Select a date',
      confirmText: 'Confirm',

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith( // Customize theme as needed
            colorScheme:const ColorScheme.dark(
              surface: primaryColour,
              primary: textColour, // Change primary color here
              onPrimary: backgroundColour, // Change text color here
            ),
          
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
        });
      }
    });
  }
}
