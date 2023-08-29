// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state

import 'package:she_wo/JsnClass/company_operation_jsn.dart';
import 'package:she_wo/screens/make_appointment_operation_page.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:she_wo/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:she_wo/settings/functions.dart';

class MakeAppointmentCalendarPage extends StatefulWidget {
  final AppointmentObject? appointment;

  const MakeAppointmentCalendarPage({Key? key, this.appointment}) : super(key: key);

  @override
  _MakeAppointmentCalendarPageState createState() => _MakeAppointmentCalendarPageState(appointment: appointment!);
}

class _MakeAppointmentCalendarPageState extends State<MakeAppointmentCalendarPage> {
  AppointmentObject appointment;
  TextEditingController teSearch = TextEditingController();
  bool calendarSelected = false;
  bool reservationSelected = true;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  _MakeAppointmentCalendarPageState({required this.appointment});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ProgressHUD(
        child: Builder(
          builder: (context) => Scaffold(
              body: Container(
                color: primaryColor,
                child: Column(
                  children: [
                    const BackLeadingWidget(
                      backColor: primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Align(alignment: Alignment.topLeft, child: leadingText(context, "randevu al")),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appointment.companyNameS!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: maxSpace)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(cardCurved),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TableCalendar(
                                locale: "tr",
                                focusedDay: _focusedDay,
                                firstDay: DateTime.now(),
                                lastDay: DateTime.utc(2030, 3, 14),
                                shouldFillViewport: false,
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                calendarFormat: CalendarFormat.month,
                                calendarStyle: CalendarStyle(
                                  isTodayHighlighted: true,
                                  selectedDecoration: BoxDecoration(
                                    color: tertiaryColor,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(minCurved),
                                  ),
                                  outsideDecoration: boxDecoration,
                                  defaultDecoration: boxDecoration,
                                  weekendDecoration: boxDecoration,
                                  defaultTextStyle: TextStyle(color: Theme.of(context).hintColor),
                                  selectedTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(minCurved),
                                  ),
                                ),
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                  });
                                },
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                color: Theme.of(context).colorScheme.background,
                child: TextButtonWidget(
                    buttonText: "Randevu alınacak işlemi seçiniz",
                    icon: const FaIcon(FontAwesomeIcons.arrowRight, size: 18, color: primaryColor),
                    //-----------------------------Randevu alınacak işlemi seçiniz butonu------------------------------
                    onPressed: () async {
                      appointment.appointmentDate =
                          "${_selectedDay.day <= 9 ? "0${_selectedDay.day}" : _selectedDay.day.toString()}.${_selectedDay.month <= 9 ? "0${_selectedDay.month}" : _selectedDay.month.toString()}.${_selectedDay.year}";
                      print(appointment.appointmentDate);
                      final progressHUD = ProgressHUD.of(context);
                      progressHUD!.show();
                      final CompanyOperationJsn? companyOperation = await companyOperationJsnFunc(appointment.companyId!);
                      if (!mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MakeAppointmentOperationPage(companyOperation: companyOperation!.result, appointment: appointment)));
                      progressHUD.dismiss();
                    }
                    //-------------------------------------------------------------------------------------------------
                    ),
              )),
        ),
      ),
    );
  }
}

class Event {
  final String operation;
  Event({required this.operation});

  @override
  String toString() => operation;
}
