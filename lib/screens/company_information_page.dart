// ignore_for_file: unnecessary_null_comparison, avoid_print, library_private_types_in_public_api, no_logic_in_create_state

import 'dart:io';
import 'package:she_wo/JsnClass/company_profile.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/text_button_widget.dart';
import 'package:she_wo/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyInformationPage extends StatefulWidget {
  final CompanyProfileJsn? companyProfile;
  const CompanyInformationPage({Key? key, this.companyProfile}) : super(key: key);

  @override
  _CompanyInformationPageState createState() => _CompanyInformationPageState(companyProfile: companyProfile);
}

class _CompanyInformationPageState extends State<CompanyInformationPage> {
  CompanyProfileJsn? companyProfile;
  _CompanyInformationPageState({this.companyProfile});

  TextEditingController teCompanyName = TextEditingController();
  TextEditingController teEPosta = TextEditingController();
  TextEditingController teTel1 = TextEditingController();
  TextEditingController teTel2 = TextEditingController();
  TextEditingController teWeb = TextEditingController();
  TextEditingController teGoogleAddress = TextEditingController();

  int? userIdData;
  File? selectedImage; // seçilen fotoğraf
  String? base64Image; // base64'e dönüşmüş fotoğraf

  @override
  void initState() {
    teCompanyName.text =
        (companyProfile!.result!.companyName == null || companyProfile!.result!.companyName == "" ? "" : companyProfile!.result!.companyName)!;
    teEPosta.text = (companyProfile!.result!.eMail == null || companyProfile!.result!.eMail == "" ? "" : companyProfile!.result!.eMail)!;
    teTel1.text =
        (companyProfile!.result!.companyPhone == null || companyProfile!.result!.companyPhone == "" ? "" : companyProfile!.result!.companyPhone)!;
    teTel2.text =
        (companyProfile!.result!.companyPhone2 == null || companyProfile!.result!.companyPhone2 == "" ? "" : companyProfile!.result!.companyPhone2)!;
    teWeb.text = (companyProfile!.result!.web == null || companyProfile!.result!.web == "" ? "" : companyProfile!.result!.web)!;
    teGoogleAddress.text = (companyProfile!.result!.googleAdressLink == null || companyProfile!.result!.googleAdressLink == ""
        ? ""
        : companyProfile!.result!.googleAdressLink)!;

    // setState(() {
    //   if(base64Image == null){
    //     existingImage = File(companyProfile!.result!.companyLogo!);
    //     imageToBase64(existingImage!);
    //     print(existingImage);
    //   }
    // });
    super.initState();
  }

  // Future<File?> fileFromImageUrl() async {
  //   final response = await http.get(Uri.parse(companyProfile!.result!.companyLogo!));
  //   final documentDirectory = await getApplicationDocumentsDirectory();
  //   existingImage = File(join(documentDirectory.path, "image.png"));
  //   existingImage!.writeAsBytesSync(response.bodyBytes);
  //   return existingImage;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: Builder(
            builder: (context) => BackGroundContainer(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(maxSpace),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                //iconun çevresini saran yapı tasarımı
                                maxRadius: 20,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                    iconSize: iconSize,
                                    icon: const Icon(Icons.arrow_back, color: primaryColor),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    }),
                              ),
                              const SizedBox(width: maxSpace),
                              const Text(
                                "Firma Bilgileri",
                                style: TextStyle(fontFamily: leadingFont, fontSize: 25, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            companyProfile!.result!.companyName!,
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: maxSpace)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(cardCurved)), //Yalnızca dikeyde yuvarlatılmış
                      ),
                      child: ListView(children: [
                        Padding(
                            padding: const EdgeInsets.all(maxSpace),
                            child: Center(
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 80,
                                  backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                                  child: selectedImage == null ? Image.network(companyProfile!.result!.companyLogo!) : null),
                            )),
                        SizedBox(
                          width: deviceWidth(context),
                          child: TextButtonWidget(
                            buttonText: "Firma Logosu Seçiniz",
                            onPressed: () {
                              setSelectedImage();
                            },
                          ),
                        ),
                        TextFieldWidget(
                          hintText: "Firma Adı",
                          obscureText: false,
                          inputFormatters: const [],
                          keyboardType: TextInputType.text,
                          textEditingController: teCompanyName,
                        ),
                        TextFieldWidget(
                          hintText: "Firma E-Posta",
                          obscureText: false,
                          inputFormatters: const [],
                          keyboardType: TextInputType.text,
                          textEditingController: teEPosta,
                        ),
                        TextFieldWidget(
                          hintText: "Firma Telefonu",
                          obscureText: false,
                          inputFormatters: const [],
                          keyboardType: TextInputType.text,
                          textEditingController: teTel1,
                        ),
                        TextFieldWidget(
                          hintText: "Firma Telefonu 2",
                          obscureText: false,
                          inputFormatters: const [],
                          keyboardType: TextInputType.text,
                          textEditingController: teTel2,
                        ),
                        TextFieldWidget(
                          hintText: "Firma Google Linki",
                          obscureText: false,
                          inputFormatters: const [],
                          keyboardType: TextInputType.text,
                          textEditingController: teGoogleAddress,
                        ),
                        TextFieldWidget(
                          hintText: "Firma Web Adresi",
                          obscureText: false,
                          inputFormatters: const [],
                          keyboardType: TextInputType.text,
                          textEditingController: teWeb,
                        ),
                        SizedBox(
                          width: deviceWidth(context),
                          child: TextButtonWidget(
                            buttonText: "Firma Bilgilerini Kaydet",
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              userIdData = prefs.getInt("userIdData")!;
                              if (!mounted) return;
                              final progressHUD = ProgressHUD.of(context);
                              progressHUD!.show();
                              final companyData = await companyInfUpdateJsnFunc(
                                  1, teCompanyName.text, base64Image, teTel1.text, teTel2.text, teGoogleAddress.text, teEPosta.text, teWeb.text);
                              if (companyData!.success == true) {
                                if (!mounted) return;
                                showToast(context, "Firma Bilgileri Güncellendi!");
                              } else {
                                if (!mounted) return;
                                showToast(context, "Bir hata oluştu!");
                              }
                              progressHUD.dismiss();
                            },
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setSelectedImage() async {
    final picker = ImagePicker();
    final selected = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (selected != null) {
        selectedImage = File(selected.path);
      }
    });
    if (selectedImage != null) {
      base64Image = imageToBase64(selectedImage!);
      print(base64Image);
    }
  }
}
