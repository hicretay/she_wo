// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state

import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/screens/make_appointment_time_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:she_wo/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MakeAppointmentOperationPage extends StatefulWidget {
  final AppointmentObject? appointment;
  final List? companyOperation;
  const MakeAppointmentOperationPage({Key? key, this.companyOperation, this.appointment}) : super(key: key);

  @override
  _MakeAppointmentOperationPageState createState() =>
      _MakeAppointmentOperationPageState(companyOperation: companyOperation!, appointment: appointment!);
}

class _MakeAppointmentOperationPageState extends State<MakeAppointmentOperationPage> {
  AppointmentObject? appointment;
  List? checkedOperation = [];
  int _checked = 0;

  List? companyOperation;
  _MakeAppointmentOperationPageState({this.companyOperation, this.appointment});

  Map<dynamic, bool> operationListMap = {};

  operationListFunc() {
    setState(() {
      for (var item in companyOperation!) {
        Map<dynamic, bool> newItem = {item: false};
        operationListMap.addEntries(newItem.entries);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    operationListFunc();
  }

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
                        Align(
                          alignment: Alignment.topLeft,
                          child: leadingText(context, "randevu al"),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            appointment!.companyNameS!,
                            style: const TextStyle(color: Colors.black),
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
                            const SizedBox(height: defaultPadding),
                            (companyOperation!.isEmpty || companyOperation!.isEmpty)
                                ? const Center(child: Text("Uygun işlem bulunamadı !"))
                                : ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical, //dikeyde kaydırılabilir
                                    shrinkWrap: true,
                                    itemCount: companyOperation!.length, //_location mapi uzunluğu kadar
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // yalnızca sol ve sağdan boşluk
                                        //InkWell sarmaladığı widgeta tıklanabilirlik özelliği kazandırdı
                                        //InkWell ile liste yapısının tamamı tıklanabilir hale geldi
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _checked = index;
                                              appointment!.operationId = companyOperation![index].id;
                                              appointment!.operationS = companyOperation![index].operationName;
                                              print(appointment!.operationId);
                                              print(appointment!.operationS);
                                            });
                                          },
                                          child: Container(
                                            //işlemlerin listeleneceği card genişliği
                                            height: 60,
                                            decoration: BoxDecoration(
                                              // Container rengi gradient ile verildi
                                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              color: _checked == index ? tertiaryColor : primaryColor,
                                            ),
                                            child: Center(
                                              //Bir seçim radiosu ve text yapısından oluşan Row
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                //İç container yapısı
                                                children: [
                                                  SizedBox(width: deviceWidth(context) * 0.04),
                                                  Container(
                                                    width: deviceWidth(context) * 0.06,
                                                    height: deviceHeight(context) * 0.06,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _checked == index ? tertiaryColor : primaryColor,
                                                    ),
                                                    //Dış container yapısı
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: _checked == index ? primaryColor : tertiaryColor,
                                                            width: 4.5), // mor dairenin genişliği
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: deviceWidth(context) * 0.02),
                                                  //operation isimlerinin gösterildiği text
                                                  Row(
                                                    children: [
                                                      Center(
                                                        child: SizedBox(
                                                          width: deviceWidth(context) * 0.7,
                                                          child: Text(
                                                            companyOperation![index].operationName,
                                                            style: TextStyle(
                                                              fontSize: 16, // operationların fontu
                                                              color: _checked == index
                                                                  ? Colors.white // seçili ise açık text
                                                                  : tertiaryColor, // seçili değilse koyu
                                                            ),
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
                                      );
                                    },
                                    //separatorBuilder list itemları arasına bir widget koymayı sağlıyor
                                    //SizedBox ile itemlar arası boşluk sağlandı
                                    separatorBuilder: (BuildContext context, int index) {
                                      return const SizedBox(height: minSpace);
                                    },
                                  ),
                            SizedBox(height: deviceHeight(context) * 0.01),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //-----------------------------------RANDEVU SAATİNİ SEÇ BUTONU-------------------------------------------
            bottomNavigationBar: Container(
              color: primaryColor,
              child: TextButtonWidget(
                  buttonText: "Saat Seç",
                  icon: const FaIcon(FontAwesomeIcons.arrowRight, size: 18, color: primaryColor),
                  onPressed: () async {
                    final progressHUD = ProgressHUD.of(context);
                    progressHUD!.show();
                    final companyOperationTime = await companyOperationTimeJsnFunc([appointment!.operationId]);
                    // ignore: unnecessary_null_comparison
                    if (appointment!.operationId != null) {
                      if (!mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MakeAppointmentTimePage(
                                  companyOperationTime: companyOperationTime!.result,
                                  appointment: appointment!))); //MakeAppointmentPersonelPage(appointment: appointment,)
                    } else {
                      _checked = 0;
                      appointment!.operationId = companyOperation![0].id;
                      appointment!.operationS = companyOperation![0].operationName;
                    }
                    progressHUD.dismiss();
                  }),
            ),
            //--------------------------------------------------------------------------------------------------------------
          ),
        ),
      ),
    );
  }
}
