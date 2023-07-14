// ignore_for_file: library_private_types_in_public_api

import 'package:she_wo/JsnClass/appointment_list.dart';
import 'package:she_wo/JsnClass/company_list_jsn.dart';
import 'package:she_wo/JsnClass/content_stream_jsn.dart';
import 'package:she_wo/providers/navigation_provider.dart';
import 'package:she_wo/screens/companies_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/reservation_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationPage extends StatefulWidget {
  static const route = "reservationPage";
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  TextEditingController teSearch = TextEditingController();
  List? appointmentList;
  List? companyContent;
  List? homeContent;

  String? select; // firma seçimi dropDown değeri

  int? userIdData;

  Future appointmentListFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdData = prefs.getInt("userIdData");
    String calendarDate =
        "${_selectedDay.day <= 9 ? "0${_selectedDay.day}" : _selectedDay.day.toString()}.${_selectedDay.month <= 9 ? "0${_selectedDay.month}" : _selectedDay.month.toString()}.${_selectedDay.year}";
    final AppointmentListJsn? appointmentNewList = await appointmentListJsnFunc(userIdData!, calendarDate);
    setState(() {
      appointmentList = appointmentNewList!.result;
    });
  }

  Future companyListFunc() async {
    final CompanyListJsn? companyNewList = await companyListJsnFunc();
    setState(() {
      companyContent = companyNewList!.result;
    });
  }

  Future homeContentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdData = prefs.getInt("userIdData");
    final ContentStreamJsn? homeContentNewList = await contentStreamJsnFunc(userIdData!, 0);
    setState(() {
      homeContent = homeContentNewList!.result;
    });
  }

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<DateTime, List> selectedEvents = {
    // DateTime.now():[Event(operation: "işlem"),Event(operation: "işlem")],
    // DateTime.utc(2022, 9, 10):[Event(operation: "işlem"),],
  };

  // List<Event>? _getEventsForDay(DateTime date) {
  //   return selectedEvents[date] ?? [
  //   // Event(operation: "deneme"),
  //   ];
  // }

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
    appointmentListFunc();
    companyListFunc();
    homeContentList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //code will run when widget rendering complete
    });
  }

  @override
  Widget build(BuildContext context) {
    //final rootContext = context.findRootAncestorStateOfType<NavigatorState>().context;
    String calendarDate =
        "${_selectedDay.day <= 9 ? "0${_selectedDay.day}" : _selectedDay.day.toString()}.${_selectedDay.month <= 9 ? "0${_selectedDay.month}" : _selectedDay.month.toString()}.${_selectedDay.year}";
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
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => CompaniesPage(date: calendarDate)));
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
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: tertiaryColor, fontFamily: leadingFont),
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
                                  focusedDay: _focusedDay,
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
                                    return isSameDay(_selectedDay, day);
                                  },
                                  onDaySelected: (selectedDay, focusedDay) async {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    await appointmentListFunc(); // randevuları yenileme
                                  },
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                  ),
                                  //eventLoader: _getEventsForDay,
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
                                onRefresh: () => appointmentListFunc(),
                                color: primaryColor,
                                backgroundColor: secondaryColor,
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    itemCount: appointmentList == null ? 0 : appointmentList!.length,
                                    controller: NavigationProvider.of(context).screens[RESERVATION_PAGE].scrollController,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ResevationResultWidget(
                                        companyName: appointmentList![index].companyName,
                                        operation: appointmentList![index].operationName,
                                        time: appointmentList![index].appointmentTime,
                                        date: appointmentList![index].appointmentDate,
                                        confirmButton: GestureDetector(
                                            child: Icon(Icons.check_box_rounded,
                                                size: 18, color: appointmentList![index].confirmed ? tertiaryColor : Theme.of(context).hintColor),
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
                                                                      await appointmentDeleteJsnFunc(appointmentList![index].id);
                                                                  if (deleteAppointment!.success == true) {
                                                                    if (!mounted) return;
                                                                    showToast(context, "Randevu başarıyla iptal edildi!");
                                                                  } else {
                                                                    if (!mounted) return;
                                                                    showToast(context, "Randevu iptal edilemedi!");
                                                                  }
                                                                  await appointmentListFunc();
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
