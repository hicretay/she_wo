// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/JsnClass/appointment_list.dart';
import 'package:she_wo/providers/navigation_provider.dart';
import 'package:she_wo/providers/reservation_provider.dart';
import 'package:she_wo/screens/companies_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/reservation_result_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationPage extends StatefulWidget {
  static const route = "reservationPage";
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  TextEditingController teSearch = TextEditingController();

  List? allAppointmentList;
  List? homeContent;

  String? select; // firma seçimi dropDown değeri

  int? userIdData;

  Future allAppointmentListFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdData = prefs.getInt("userIdData");

    final AppointmentListJsn? appointmentNewList = await allAppointmentListJsnFunc(userIdData ?? 0);
    setState(() {
      allAppointmentList = appointmentNewList!.result;
    });
  }

  // ignore: unused_field
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    final provider = Provider.of<ReservationProvider>(context, listen: false);
    super.initState();

    provider.appointmentListFunc();

    allAppointmentListFunc().whenComplete(() {
      for (var element in (allAppointmentList ?? [])) {
        provider.selectedEvents?[DateTime.utc(
            int.parse(element.appointmentDate.toString().split('.')[2]),
            int.parse(element.appointmentDate.toString().split('.')[1]),
            int.parse(element.appointmentDate.toString().split('.')[0]))] = [Event(title: element.operationName)];
        provider.refresh();
      }
    });
    provider.selectedEvents = {};
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservationProvider>(context);

    List<Event> getEventsfromDay(DateTime date) {
      return provider.selectedEvents?[date] ?? [];
    }

    String calendarDate =
        "${provider.selectedDay.day <= 9 ? "0${provider.selectedDay.day}" : provider.selectedDay.day.toString()}.${provider.selectedDay.month <= 9 ? "0${provider.selectedDay.month}" : provider.selectedDay.month.toString()}.${provider.selectedDay.year}";
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: SingleChildScrollView(
            child: FloatingActionButton.extended(
                backgroundColor: secondaryColor,
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  userIdData = prefs.getInt("userIdData");

                  if (userIdData == null) {
                    if (!mounted) return;
                    showNotMemberAlert(context);
                    return;
                  } else {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => CompaniesPage(date: calendarDate)));
                  }
                },
                label: const Text(
                  "Randevu Al",
                  style: TextStyle(color: tertiaryColor),
                ),
                icon: const FaIcon(FontAwesomeIcons.calendar, size: 18, color: tertiaryColor)),
          ),
          body: ProgressHUD(
            child: Builder(
              builder: (context) => BackGroundContainer(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: defaultPadding,
                        right: defaultPadding,
                        top: defaultPadding * 2,
                        bottom: defaultPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "randevularım", //Büyük Başlık
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: tertiaryColor, fontFamily: leadingFont),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(cardCurved),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: maxSpace, left: maxSpace),
                                child: TableCalendar(
                                  locale: "tr",
                                  focusedDay: provider.selectedDay,
                                  firstDay: DateTime.utc(2010, 10, 16),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  shouldFillViewport: false,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  calendarFormat: CalendarFormat.twoWeeks,
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
                                    defaultTextStyle: const TextStyle(color: darkWhite),
                                    outsideTextStyle: const TextStyle(color: darkWhite),
                                    selectedTextStyle: const TextStyle(
                                      color: primaryColor,
                                    ),
                                    todayDecoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(minCurved),
                                    ),
                                  ),
                                  selectedDayPredicate: (day) {
                                    return isSameDay(provider.selectedDay, day);
                                  },
                                  onDaySelected: (selectedDay, focusedDay) async {
                                    provider.selectedDay = selectedDay;
                                    _focusedDay = focusedDay;

                                    await provider.appointmentListFunc(); // randevuları yenileme
                                  },
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                  ),
                                  eventLoader: getEventsfromDay,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: defaultPadding, top: defaultPadding, bottom: defaultPadding),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "$calendarDate Randevu Listesi",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).hintColor),
                                  )),
                            ),
                            Flexible(
                              child: RefreshIndicator(
                                onRefresh: () => provider.appointmentListFunc(),
                                color: primaryColor,
                                backgroundColor: secondaryColor,
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    itemCount: provider.appointmentList == null ? 0 : provider.appointmentList!.length,
                                    controller: NavigationProvider.of(context).screens[RESERVATION_PAGE].scrollController,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ResevationResultWidget(
                                        companyName: provider.appointmentList![index].companyName,
                                        operation: provider.appointmentList![index].operationName,
                                        time: provider.appointmentList![index].appointmentTime,
                                        date: provider.appointmentList![index].appointmentDate,
                                        confirmButton: GestureDetector(
                                            child: Icon(Icons.check_box_rounded,
                                                size: 18,
                                                color: provider.appointmentList![index].confirmed ? tertiaryColor : Theme.of(context).hintColor),
                                            onTap: () {
                                              showToast(context, "Randevu onayı bekleniyor...");
                                            }),
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ProgressHUD(
                                                  child: Builder(
                                                    builder: (context) => AlertDialog(
                                                      content: const Text("Randevu iptal edilsin mi?", style: TextStyle(fontFamily: contentFont)),
                                                      actions: <Widget>[
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            MaterialButton(
                                                                color: tertiaryColor,
                                                                child: const Text("Evet", style: TextStyle(color: white)),
                                                                onPressed: () async {
                                                                  final progressHUD = ProgressHUD.of(context);
                                                                  progressHUD!.show();
                                                                  final deleteAppointment =
                                                                      await appointmentDeleteJsnFunc(provider.appointmentList![index].id);
                                                                  if (deleteAppointment!.success == true) {
                                                                    if (!mounted) return;
                                                                    showToast(context, "Randevu başarıyla iptal edildi!");

                                                                    allAppointmentListFunc().whenComplete(() {
                                                                      String calendarDate =
                                                                          "${provider.selectedDay.day <= 9 ? "0${provider.selectedDay.day}" : provider.selectedDay.day.toString()}.${provider.selectedDay.month <= 9 ? "0${provider.selectedDay.month}" : provider.selectedDay.month.toString()}.${provider.selectedDay.year}";

                                                                      provider.selectedEvents?[DateTime.utc(
                                                                          int.parse(calendarDate.toString().split('.')[2]),
                                                                          int.parse(calendarDate.toString().split('.')[1]),
                                                                          int.parse(calendarDate.toString().split('.')[0]))] = [];
                                                                      provider.refresh();
                                                                    });

                                                                    await provider.appointmentListFunc();
                                                                  } else {
                                                                    if (!mounted) return;
                                                                    showToast(context, "Randevu iptal edilemedi!");
                                                                  }

                                                                  if (!mounted) return;
                                                                  Navigator.of(context).pop();
                                                                  progressHUD.dismiss();
                                                                }),
                                                            MaterialButton(
                                                              color: tertiaryColor,
                                                              child: const Text("Hayır", style: TextStyle(color: white)),
                                                              onPressed: () {
                                                                showToast(context, "Randevu iptal edilmedi!");
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Event {
  final String title;
  Event({required this.title});

  @override
  String toString() => title;
}
