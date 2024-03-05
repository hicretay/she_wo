import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/screens/reservation_page.dart';
import 'package:she_wo/settings/functions.dart';

import '../JsnClass/appointment_list.dart';

class ReservationProvider with ChangeNotifier {
  List? appointmentList;
  DateTime selectedDay = DateTime.now();

  Map<DateTime, List<Event>>? selectedEvents;

  void refresh() {
    notifyListeners();
  }

  void setSelectedDay(DateTime d) {
    selectedDay = d;
    notifyListeners();
  }

  Future appointmentListFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userIdData = prefs.getInt("userIdData");
    String calendarDate =
        "${selectedDay.day <= 9 ? "0${selectedDay.day}" : selectedDay.day.toString()}.${selectedDay.month <= 9 ? "0${selectedDay.month}" : selectedDay.month.toString()}.${selectedDay.year}";
    final AppointmentListJsn? appointmentNewList = await appointmentListJsnFunc(userIdData ?? 0, calendarDate);

    appointmentList = appointmentNewList!.result;

    notifyListeners();
  }
}
