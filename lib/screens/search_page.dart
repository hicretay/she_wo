// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:she_wo/model/comment_model.dart';
import 'package:she_wo/model/company_detail_model.dart';
import 'package:she_wo/model/top_favorite_model.dart';
import 'package:she_wo/providers/theme_data_provider.dart';
import 'package:she_wo/screens/home_detail_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';

import '../widgets/backleading_widget.dart';

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

  List selectedCompanies = [];
  bool isFirstTime = true;
  bool isSaved = false;
  String? currentAddress;
  Position? currentPosition;
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => currentPosition = position);
      getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });

    setState(() {
      isLoading = false;
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
    final provider = Provider.of<ThemeDataProvider>(context);
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
                                        .headlineSmall!
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
                                          title: TextFormField(
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
                                          title: TextFormField(
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
                                                child: isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: tertiaryColor,
                                                      )
                                                    : IconButton(
                                                        iconSize: iconSize,
                                                        icon: FaIcon(FontAwesomeIcons.locationArrow,
                                                            color: Theme.of(context).hintColor, size: 16, textDirection: TextDirection.ltr),
                                                        onPressed: () {},
                                                      ),
                                              ),
                                            ),
                                            onTap: () async {
                                              selectedCompanies.clear();
                                              teLocation.text = '';
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
                                              .labelLarge!
                                              .copyWith(color: white, fontFamily: contentFont, fontSize: 18, fontWeight: FontWeight.bold)),
                                      //-----------------------------GİRİŞ BUTONU ONPRESSEDİ---------------------------------------------
                                      onPressed: () async {
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                                        final TopFavoritesModel? companyNewList = await searchListFunc(teSearch.text, teLocation.text);
                                        if (mounted) {
                                          setState(() {
                                            selectedCompanies = companyNewList!.result;
                                          });
                                        }

                                        setState(() {
                                          isSaved = true;
                                        });
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
                            itemCount: selectedCompanies.length,
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
                                        selectedCompanies[index].companyName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 18, color: tertiaryColor),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    final CompanyDetailModel? homeDetailContent = await companyDetailFunc(selectedCompanies[index].id);

                                    final CommentModel? commentsModel = await commentListJsnFunc(selectedCompanies[index].id);
                                    provider.setComments(commentsModel?.result);

                                    if (!mounted) return;
                                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                        builder: (context) => HomeDetailPage(
                                              //? TODO commentsAvg: homeDetailContent!.result,
                                              homeDetailContent: homeDetailContent!.result,
                                              companyId: homeDetailContent.result.id,
                                              companyLogo: homeDetailContent.result.companyLogo.replaceAll('shewoo', 'estetikvitrini'),
                                              companyName: homeDetailContent.result.companyName,
                                              contentTitle: homeDetailContent.result.campaignList[index].campaingName,
                                              googleAdressLink: homeDetailContent.result.googleAdressLink,
                                              companyPhone: homeDetailContent.result.companyPhone,
                                              comments: commentsModel?.result,
                                            )));
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
  }
}
