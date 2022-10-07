import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/tutor_booking.dart';
import 'package:flutter_booking_app/pages/tutor_details_viewmodel.dart';
import 'package:intl/intl.dart';

class BookingDialog extends StatefulWidget {
  String restorationId = "";
  final String tutorId;
  late TutorDetailsViewModel tutorDetailsViewModel = TutorDetailsViewModel();
  BookingDialog({Key? key, required this.tutorId, this.restorationId = ""})
      : super(key: key);

  @override
  _BookingDialog createState() {
    return _BookingDialog();
  }
}

class _BookingDialog extends State<BookingDialog> with RestorationMixin {
  String startTimeHour = "1";
  String startTimeValueMins = "00";
  String startTimeValueT = "PM";
  String durationValues = "30 mins";
  String startDate = "No Date";
  static DateTime? selectedDate;

  final Map<String, String> _lessonTypeMap = {
    "InPerson": "In Person",
    "online": "Online Lesson"
  };

  String _lessonType = "InPerson";

  @override
  void initState() {
    widget.tutorDetailsViewModel.bookNow.listen((event) {
      if (event.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Submitting a request")));
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Request submitted!")));
      Navigator.of(context).pop();
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$error")));
    });
    super.initState();
  }

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
              onPressed: () {
                if (selectedDate == null ||
                    startDate.isEmpty ||
                    startTimeValueMins.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Some fields are missing")));
                  return;
                }
                final year = selectedDate?.year.toInt();
                final month = selectedDate?.month.toInt();
                final day = selectedDate?.day.toInt();
                final hour = int.tryParse(startTimeHour);
                final mins = int.tryParse(startTimeValueMins);

                final startTimeInMillis =
                    DateTime(year!, month!, day!, hour!, mins!)
                        .millisecondsSinceEpoch;
                widget.tutorDetailsViewModel.bookTutor(
                    tutorId: widget.tutorId,
                    bookingRequest: TutorBooking(
                        null,
                        null,
                        null,
                        startTimeInMillis,
                        durationValues,
                        _lessonType,
                        ["Maths/Sample"]));
              },
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
            buildDropDown(List.generate(10, (index) => "$index"), startTimeHour,
                (value) {
              startTimeHour = value ?? "";
            }),
            buildDropDown(
                List.generate(10, (index) => index > 9 ? "$index" : "0$index"),
                startTimeValueMins, (value) {
              startTimeValueMins = value ?? "";
            }),
            buildDropDown(["AM", "PM"], startTimeValueT, (value) {
              startTimeValueT = value ?? "";
            }),
          ],
        )
      ],
    );
  }

  Widget buildDropDown(
      List<String> items, String? dropdownValue, Function(String?) onSelect) {
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
            onSelect.call(value);
          });
        });
  }

  Widget _buildDuration() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Duration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        buildDropDown(["30 mins", "45 mins", "1 hr"], durationValues, (value) {
          durationValues = value ?? "";
        })
      ],
    );
  }

  Widget _buildLessonType() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Lesson Type",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Column(
          children: _lessonTypeMap.keys
              .map((e) => SizedBox(
                    child: RadioListTile<String>(
                        value: e,
                        contentPadding: EdgeInsets.only(left: 0),
                        title: Text(_lessonTypeMap[e] ?? ""),
                        groupValue: _lessonType,
                        onChanged: (value) {
                          setState(() {
                            _lessonType = value ?? "";
                          });
                          print("value : $value $e");
                        }),
                  ))
              .toList(),
        )
      ],
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
              firstDate: DateTime.now(),
              lastDate: DateTime(2023));
        });
  }

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
}
