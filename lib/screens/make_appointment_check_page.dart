// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'package:she_wo/JsnClass/appointment_list.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/information_row_widget.dart';
import 'package:she_wo/settings/functions.dart';

class MakeAppointmentCheckPage extends StatefulWidget {
  final AppointmentObject? appointment;
  final int? indexx;
  const MakeAppointmentCheckPage({Key? key, this.appointment, this.indexx}) : super(key: key);

  @override
  _MakeAppointmentCheckPageState createState() => _MakeAppointmentCheckPageState(appointment: appointment!);
}

class _MakeAppointmentCheckPageState extends State<MakeAppointmentCheckPage> {
  TextEditingController teNote = TextEditingController();
  late String? teOperation;
  late int? userIdData;

  AppointmentObject appointment;

  _MakeAppointmentCheckPageState({required this.appointment});

  late List? appointmentList;

  Future appointmentListFunc() async {
    final AppointmentListJsn? appointmentNewList = await appointmentListJsnFunc(1, "");
    setState(() {
      appointmentList = appointmentNewList!.result!;
    });
  }

  @override
  void initState() {
    super.initState();
    appointmentListFunc();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Container(
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: leadingText(context, "randevu al"),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          appointment.companyNameS!,
                          style: const TextStyle(color: tertiaryColor),
                        ),
                      ),
                      const SizedBox(height: maxSpace)
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Column(
                          children: [
                            InformationRowWidget(
                              containerColor: Colors.black26,
                              operationName: "Tarih",
                              width: deviceWidth(context) * 0.6,
                              height: deviceWidth(context) * 0.15,
                              child: Text(
                                appointment.appointmentDate ?? "tarih",
                                style: const TextStyle(color: tertiaryColor, fontSize: 18),
                              ),
                            ),
                            InformationRowWidget(
                              containerColor: Colors.black26,
                              width: deviceWidth(context) * 0.6,
                              height: deviceWidth(context) * 0.15,
                              operationName: "Saat",
                              child: Text(
                                appointment.timeS!,
                                style: const TextStyle(color: tertiaryColor, fontSize: 18),
                              ),
                            ),
                            InformationRowWidget(
                              containerColor: Colors.black26,
                              operationName: "İşlem",
                              width: deviceWidth(context) * 0.6,
                              height: deviceWidth(context) * 0.17,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(deviceWidth(context) * 0.01),
                                  child: Text(
                                    appointment.operationS!,
                                    style: const TextStyle(color: tertiaryColor, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            InformationRowWidget(
                              containerColor: darkWhite,
                              width: deviceWidth(context) * 0.6,
                              height: deviceWidth(context) * 0.3,
                              operationName: "Özel Not",
                              child: TextFormField(
                                maxLength: 250,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: teNote,
                                cursorColor: primaryColor,
                                style: const TextStyle(color: primaryColor, fontSize: 18),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(""),
                                Container(
                                  width: deviceWidth(context) * 0.6,
                                  height: deviceWidth(context) * 0.15,
                                  decoration: const BoxDecoration(
                                    color: tertiaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: MaterialButton(
                                      child: const Text(
                                        "Randevu Oluştur",
                                        style: TextStyle(fontFamily: leadingFont, color: Colors.white, fontSize: 18),
                                      ),
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        userIdData = prefs.getInt("userIdData");
                                        if (!mounted) return;
                                        final progressHUD = ProgressHUD.of(context);
                                        progressHUD!.show();
                                        if (userIdData != 0) {
                                          final appointmentAddData = await appointmentAddJsnFunc(
                                              userIdData!,
                                              appointment.companyId!,
                                              appointment.campaignId == null ? 0 : appointment.campaignId!,
                                              appointment.appointmentDate!,
                                              appointment.appointmentTimeId!,
                                              appointment.operationId!,
                                              teNote.text);
                                          if (appointmentAddData!.success == true) {
                                            if (!mounted) return;
                                            await showToast(context, "Randevu başarıyla kaydedildi!");
                                          } else {
                                            if (!mounted) return;
                                            await showToast(context, "Randevu kaydı başarısız!");
                                          }
                                          await appointmentListFunc();
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          progressHUD.dismiss();
                                        } else {
                                          showNotMemberAlert(context);
                                          progressHUD.dismiss();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
