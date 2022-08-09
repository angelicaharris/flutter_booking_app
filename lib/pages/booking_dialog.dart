import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/tutor_details.dart';
import 'package:intl/intl.dart';

class BookingDialog extends StatefulWidget {
  String restorationId = "";
  BookingDialog({Key? key, this.restorationId = ""}) : super(key: key);

  @override
  _BookingDialog createState() {
    return _BookingDialog();
  }
}

class _BookingDialog extends State<BookingDialog> with RestorationMixin {
  String startTimeValue = "1";
  String startTimeValueMins = "00";
  String startTimeValueT = "PM";
  String durationValues = "30 mins";
  String startDate = "No Date";
  static DateTime? selectedDate;

  final Map<String, String> _lessonTypeMap = {
    "InPerson": "In Person",
    "online": "Online Lesson"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "TIME",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            _buildDatePicker(),
            const SizedBox(
              height: 20,
            ),
            _buildStartTime(),
            const SizedBox(
              height: 20,
            ),
            _buildDuration(),
            const SizedBox(
              height: 20,
            ),
            _buildLessonType(),
            const SizedBox(
              height: 50,
            ),
            FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.send),
              label: const Text('Send Request'),
              backgroundColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: BorderSide(
                    color: Colors.black38,
                    width: 0.5,
                  )))),
          onPressed: () {
            //Set date
            _restorableRouteFuture.present();
          },
          child: Text(selectedDate == null
              ? startDate
              : "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}"),
        )
      ],
    );
  }

  Widget _buildStartTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Start Time",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            buildDropDown(
                List.generate(10, (index) => "$index"), startTimeValue),
            buildDropDown(
                List.generate(10, (index) => index > 9 ? "$index" : "0$index"),
                startTimeValueMins),
            buildDropDown(["AM", "PM"], startTimeValueT),
          ],
        )
      ],
    );
  }

  Widget buildDropDown(List<String> items, String? dropdownValue) {
    return DropdownButton<String?>(
        value: dropdownValue,
        items: items
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            dropdownValue = value;
          });
        });
  }

  Widget _buildDuration() {
    return Column(
      children: [
        const Text(
          "Duration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        buildDropDown(["30 mins", "45 mins", "1 hr"], durationValues)
      ],
    );
  }

  Widget _buildLessonType() {
    return Column(
      children: _lessonTypeMap.keys
          .map((e) => RadioListTile<String>(
              value: _lessonTypeMap[e] ?? "",
              title: Text(_lessonTypeMap[e] ?? ""),
              groupValue: _lessonTypeMap["online"],
              onChanged: (value) {}))
          .toList(),
    );
  }

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, "session_booking_date_picker");
    registerForRestoration(_restorableRouteFuture, "datepicker_dialog");
  }

  late final RestorableRouteFuture<DateTime?> _restorableRouteFuture =
      RestorableRouteFuture(onComplete: (value) {
    setState(() {
      print("$value");
      selectedDate = value;
    });
  }, onPresent: (NavigatorState navigator, Object? args) {
    return navigator.restorablePush(_datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch);
  });

  static Route<DateTime> _datePickerRoute(
      BuildContext context, Object? arguments) {
    return DialogRoute(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog(
              restorationId: "session_booking_date_picker",
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate:
                  DateTime.fromMillisecondsSinceEpoch(arguments as int),
              firstDate: DateTime(2021),
              lastDate: DateTime(2023));
        });
  }

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2022, 08, 3));
}
