import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(LoveDaysCounterApp());
}

class LoveDaysCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Days Counter',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.pinkAccent,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.pink,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
          brightness: Brightness.light,
        ),
      ),
      home: LoveDaysCounter(),
    );
  }
}

class LoveDaysCounter extends StatefulWidget {
  @override
  _LoveDaysCounterState createState() => _LoveDaysCounterState();
}

class _LoveDaysCounterState extends State<LoveDaysCounter> {
  late DateTime _startDate;
  late DateTime _endDate;
  int _daysCount = 0;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  void _calculateDays() {
    setState(() {
      _daysCount = _endDate.difference(_startDate).inDays;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart ? _startDate : _endDate;
    DateTime firstDate = isStart ? DateTime(1900) : _startDate;
    DateTime lastDate =
        isStart ? _endDate.add(Duration(days: 365 * 10)) : DateTime(2100);

    if (!isStart && _startDate.isAfter(_endDate)) {
      firstDate = _endDate;
    } else if (isStart && _endDate.isBefore(_startDate)) {
      lastDate = _startDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Theme.of(context).accentColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.black,
              surface: Theme.of(context).primaryColor,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
      _calculateDays();
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.red), // Heart icon here
            SizedBox(width: 5),
            Text('Love Days Counter'),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () => _selectDate(context, true),
              icon: Icon(Icons.calendar_today),
              label: Text(
                'Select Start Date',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Start Date: ${_formattedDate(_startDate)}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _selectDate(context, false),
              icon: Icon(Icons.calendar_today),
              label: Text(
                'Select End Date',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'End Date: ${_formattedDate(_endDate)}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Days Count: $_daysCount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
