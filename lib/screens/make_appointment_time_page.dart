// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state

import 'package:she_wo/screens/make_appointment_check_page.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:she_wo/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MakeAppointmentTimePage extends StatefulWidget {
  final AppointmentObject? appointment;
  final List? companyOperationTime;

  const MakeAppointmentTimePage({Key? key, this.companyOperationTime, this.appointment}) : super(key: key);

  @override
  _MakeAppointmentTimePageState createState() => _MakeAppointmentTimePageState(companyOperationTime: companyOperationTime, appointment: appointment);
}

class _MakeAppointmentTimePageState extends State<MakeAppointmentTimePage> {
  AppointmentObject? appointment;
  List? companyOperationTime;

  _MakeAppointmentTimePageState({this.companyOperationTime, this.appointment});

  int _checked = -1;
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
                            appointment!.companyNameS!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: maxSpace,
                        )
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: (companyOperationTime!.isEmpty || companyOperationTime!.isEmpty)
                                  ? const Center(child: Text("Uygun saat bulunamadı !"))
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: companyOperationTime!.length,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: (1 / .5),
                                        crossAxisCount: 4,
                                        mainAxisSpacing: minSpace,
                                        crossAxisSpacing: minSpace,
                                      ),
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(maxSpace)),
                                            color: _checked == index ? primaryColor : tertiaryColor,
                                          ),
                                          child: TextButton(
                                            child: Center(
                                              child: Text(
                                                companyOperationTime![index].operationStartTime,
                                                style: TextStyle(
                                                  color: _checked == index ? tertiaryColor : primaryColor,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                //butona basıldığında değeri günceller
                                                _checked = index;
                                                appointment!.appointmentTimeId = companyOperationTime![index].id;
                                                appointment!.timeS = companyOperationTime![index].operationStartTime;
                                                print(companyOperationTime![index].id.toString());
                                              });
                                            },
                                          ),
                                        );
                                      }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //--------------------------------RANDEVUYU TAMAMLA BUTONU-----------------------------------
            bottomNavigationBar: Container(
              color: secondaryColor,
              child: TextButtonWidget(
                  buttonText: "Randevuyu Tamamla",
                  icon: const FaIcon(FontAwesomeIcons.arrowRight, size: 18, color: primaryColor),
                  onPressed: () {
                    print(appointment!.timeS);
                    final progressHUD = ProgressHUD.of(context);
                    progressHUD!.show();
                    if (appointment!.timeS != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MakeAppointmentCheckPage(appointment: appointment)));
                    } else {
                      showToast(context, "Lütfen bir saat seçiniz!");
                    }
                    progressHUD.dismiss();
                  }),
            ),
            //--------------------------------------------------------------------------------------------
          ),
        ),
      ),
    );
  }
}
