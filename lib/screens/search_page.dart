// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:she_wo/JsnClass/company_list_jsn.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';

import '../JsnClass/company_profile.dart';
import '../widgets/backleading_widget.dart';
import 'company_profile_page.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatefulWidget {
  static const route = "searchPage";
  const SearchPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController teSearch = TextEditingController();
  TextEditingController teLocation = TextEditingController();

  List allCompanies = [];
  List selectedCompanies = [];
  bool isFirstTime = true;
  bool isSaved = false;
  String? currentAddress;
  Position? currentPosition;

  Future<CompanyListJsn?> allCompaniesList() async {
    final CompanyListJsn? companyNewList = await companyListJsnFunc();
    if (mounted) {
      setState(() {
        allCompanies = companyNewList!.result!;
      });
    }
    return companyNewList;
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast(context, 'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast(context, 'Location permissions are denied');

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showToast(context, 'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => currentPosition = position);
      getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(currentPosition!.latitude, currentPosition!.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        print(currentAddress);
        setState(() {
          teLocation.text = currentAddress ?? '';
        });
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanyListJsn?>(
        future: allCompaniesList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("HATA"),
            );
          } else {
            if (snapshot.hasData) {
              if (isFirstTime) {
                selectedCompanies = allCompanies;
                isFirstTime = false;
              }
              return Container(
                color: Colors.transparent,
                child: SafeArea(
                  top: false,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: ProgressHUD(
                        child: Builder(
                          builder: (context) => Container(
                            color: primaryColor,
                            child: Padding(
                              padding: EdgeInsets.only(top: deviceHeight(context) * 0.03),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: BackLeadingWidget(
                                      backColor: tertiaryColor,
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: deviceWidth(context) * 0.05),
                                      child: SizedBox(
                                        height: deviceWidth(context) * 0.25,
                                        child: Center(
                                          child: Image.asset("assets/images/shewo_logo.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: deviceHeight(context) * 0.05),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: defaultPadding,
                                            right: defaultPadding,
                                            bottom: defaultPadding,
                                          ),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Arama",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(color: tertiaryColor, fontFamily: leadingFont, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: minSpace),
                                          child: Container(
                                            decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: ListTile(
                                                    title: TextField(
                                                      controller: teSearch,
                                                      cursorColor: tertiaryColor,
                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        hintText: "Hizmet veya mekan arayın",
                                                        hintStyle: const TextStyle(color: Colors.grey),
                                                        focusedBorder: InputBorder.none,
                                                        enabledBorder: InputBorder.none,
                                                        filled: true,
                                                        fillColor: secondaryColor,
                                                        border: const OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(cardCurved)),
                                                        ),
                                                        icon: CircleAvatar(
                                                          maxRadius: 15,
                                                          backgroundColor: secondaryColor,
                                                          child: IconButton(
                                                            iconSize: iconSize,
                                                            icon: FaIcon(FontAwesomeIcons.search,
                                                                color: Theme.of(context).hintColor, size: 16, textDirection: TextDirection.ltr),
                                                            onPressed: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        selectedCompanies.clear();
                                                        setState(() {
                                                          isSaved = false;
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        selectedCompanies.clear();
                                                        setState(() {
                                                          for (var element in allCompanies) {
                                                            if (element.companyName.toLowerCase().contains(teSearch.text.toLowerCase())) {
                                                              selectedCompanies.add(element);
                                                            }
                                                          }
                                                        });

                                                        if (selectedCompanies.isEmpty) {
                                                          setState(() {
                                                            isSaved = false;
                                                          });
                                                        }
                                                      },
                                                      onSubmitted: (val) {
                                                        if (selectedCompanies.isNotEmpty) {
                                                          setState(() {
                                                            isSaved = true;
                                                          });
                                                        }

                                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: minSpace),
                                          child: Container(
                                            decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: ListTile(
                                                    title: TextField(
                                                      controller: teLocation,
                                                      cursorColor: tertiaryColor,
                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        hintText: "Mevcut konum",
                                                        hintStyle: const TextStyle(color: Colors.grey),
                                                        focusedBorder: InputBorder.none,
                                                        enabledBorder: InputBorder.none,
                                                        filled: true,
                                                        fillColor: secondaryColor,
                                                        border: const OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(cardCurved)),
                                                        ),
                                                        icon: CircleAvatar(
                                                          maxRadius: 15,
                                                          backgroundColor: secondaryColor,
                                                          child: IconButton(
                                                            iconSize: iconSize,
                                                            icon: FaIcon(FontAwesomeIcons.locationArrow,
                                                                color: Theme.of(context).hintColor, size: 16, textDirection: TextDirection.ltr),
                                                            onPressed: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        selectedCompanies.clear();
                                                        setState(() {
                                                          isSaved = false;
                                                        });

                                                        await getCurrentPosition();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: deviceHeight(context) * 0.03),
                                          child: Material(
                                            color: tertiaryColor,
                                            borderRadius: BorderRadius.circular(16.0),
                                            //--------------------------------------------------GİRİŞ BUTONU---------------------------------------------------------------
                                            child: MaterialButton(
                                                minWidth: deviceWidth(context) * 0.35, //Buton minimum genişliği
                                                child: Text("UYGULA",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button!
                                                        .copyWith(color: white, fontFamily: contentFont, fontSize: 18, fontWeight: FontWeight.bold)),
                                                //-----------------------------GİRİŞ BUTONU ONPRESSEDİ---------------------------------------------
                                                onPressed: () {
                                                  setState(() {
                                                    isSaved = true;
                                                  });

                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                }),
                                            //-----------------------------------------------------------------------------------------------------------------------------
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSaved && selectedCompanies.isNotEmpty)
                                    ListView.separated(
                                      padding: const EdgeInsets.all(0),
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: selectedCompanies.isEmpty ? allCompanies.length : selectedCompanies.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
                                          child: InkWell(
                                            child: Container(
                                              height: deviceHeight(context) * 0.06,
                                              width: deviceWidth(context) * 0.06,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                color: primaryColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  selectedCompanies.isEmpty ? allCompanies[index].companyName : selectedCompanies[index].companyName,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 18, color: tertiaryColor),
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              // final progressUHD = ProgressHUD.of(context);
                                              // progressUHD!.show();
                                              final CompanyProfileJsn? companyProfile = await companyListDetailJsnFunc(selectedCompanies[index].id);
                                              if (!mounted) return;
                                              Navigator.of(context, rootNavigator: true)
                                                  .push(MaterialPageRoute(builder: (context) => CompanyProfilePage(companyProfile: companyProfile)));

                                              // progressUHD.dismiss();
                                            },
                                          ),
                                        );
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return const SizedBox(height: minSpace);
                                      },
                                    ),
                                  if (isSaved && selectedCompanies.isEmpty) const Text('Uygun hizmet veya mekan bulunamadı !'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return circularBasic;
            }
          }
        });
  }
}
