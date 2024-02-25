import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateUpdateLogView extends StatefulWidget {
  const CreateUpdateLogView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateLogView> createState() => _CreateUpdateLogViewState();
}

class _CreateUpdateLogViewState extends State<CreateUpdateLogView> {
  late TextEditingController _textController;
  late IconData iconshape;
  late DateTime _selectedDate;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    _textController = TextEditingController();
    iconshape = Icons.fastfood_rounded; // Initial icon
    _selectedDate = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = _selectedDate;
    _firstDay = DateTime.utc(2020, 1, 1);
    _lastDay = DateTime.utc(2030, 12, 31);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            // Open calendar picker
            _showCalendarPicker(context);
          },
          child: Text(
            '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue, // Change the color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            // Your existing content here
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue, // Change the color as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Your existing bottom navigation bar here
          ],
        ),
      ),
    );
  }

  // Method to show the calendar picker
  void _showCalendarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
