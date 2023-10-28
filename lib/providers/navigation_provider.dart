// ignore_for_file: constant_identifier_names
import 'package:she_wo/screens/home_page.dart';
import 'package:she_wo/screens/login_page.dart';
import 'package:she_wo/screens/register_page.dart';
import 'package:she_wo/screens/reservation_page.dart';
import 'package:she_wo/screens/settings_page.dart';
import 'package:she_wo/screens/splash_page.dart';
import 'package:she_wo/settings/root.dart';
import 'package:she_wo/model/screen_provider_model.dart';
import 'package:she_wo/widgets/exit_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../settings/consts.dart';

const HOME_PAGE = 0;
// const FAVORITE_PAGE = 1;
const RESERVATION_PAGE = 1;
// const SEARCH_PAGE = 3;
const SETTINGS_PAGE = 2;

class NavigationProvider extends ChangeNotifier {
  static NavigationProvider of(BuildContext context) {
    //iconCol = Provider.of<ThemeDataProvider>(context, listen: true).isLightTheme ? primaryColor : white;
    return Provider.of<NavigationProvider>(context, listen: false);
  }

  int _currentScreenIndex = HOME_PAGE; // Başlangıç sayfası homePage
  int get currentTabIndex => _currentScreenIndex;

  void setCurrentTab(int tab) {
    _currentScreenIndex = tab;
    notifyListeners();
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == SplashPage.route) {
      return MaterialPageRoute(builder: (_) => const SplashPage());
    } else if (settings.name == LoginPage.route) {
      return MaterialPageRoute(builder: (_) => const LoginPage());
    } else if (settings.name == RegisterPage.route) {
      return MaterialPageRoute(builder: (_) => const RegisterPage());
    } else {
      return MaterialPageRoute(builder: (_) => const Root());
    }
  }

  final Map<int, Screen> _screens = {
    HOME_PAGE: Screen(
      scrollController: ScrollController(),
      child: const HomePage(),
      title: "",
      icon: SvgPicture.asset("assets/icons/Compass.svg", height: 25, width: 25, color: tertiaryColor),
      activeIcon: CircleAvatar(
        backgroundColor: tertiaryColor,
        child: SvgPicture.asset("assets/icons/Compass.svg", height: 25, width: 25, color: primaryColor),
      ),
      initialRoute: HomePage.route,
      navigatorState: GlobalKey<NavigatorState>(),
      onGenerateRoute: (_) {
        return MaterialPageRoute(builder: (_) => const HomePage());
      },
    ),
    RESERVATION_PAGE: Screen(
      scrollController: ScrollController(),
      icon: SvgPicture.asset("assets/icons/calendar.svg", height: 25, width: 25, color: tertiaryColor),
      title: "",
      activeIcon: CircleAvatar(
        backgroundColor: tertiaryColor,
        child: SvgPicture.asset("assets/icons/calendar.svg", height: 25, width: 25, color: primaryColor),
      ),
      child: const ReservationPage(),
      initialRoute: ReservationPage.route,
      navigatorState: GlobalKey<NavigatorState>(),
      onGenerateRoute: (_) {
        return MaterialPageRoute(builder: (_) => const ReservationPage());
      },
    ),
    SETTINGS_PAGE: Screen(
      scrollController: ScrollController(),
      icon: SvgPicture.asset("assets/icons/User.svg", height: 25, width: 25, color: tertiaryColor),
      title: "",
      activeIcon: CircleAvatar(
        backgroundColor: tertiaryColor,
        child: SvgPicture.asset("assets/icons/User.svg", height: 25, width: 25, color: primaryColor),
      ),
      child: const SettingsPage(),
      initialRoute: SettingsPage.route,
      navigatorState: GlobalKey<NavigatorState>(),
      onGenerateRoute: (_) {
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      },
    ),
  };

  List<Screen> get screens => _screens.values.toList();

  Screen? get currentScreen => _screens[_currentScreenIndex];

//-----------------------Sayfa yönlendirme fonksiyonu---------------------
//NavigationProvider.of(context).setTab(PAGENAME); şeklinde kullanılacak.
  void setTab(int tab) async {
    if (tab == currentTabIndex) {
      _scrollToStart();
      notifyListeners();
    } else {
      _currentScreenIndex = tab;
      notifyListeners();
    }
  }
//-----------------------------------------------------------------------

  void _scrollToStart() async {
    await Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // ignore: unnecessary_null_comparison
      if (currentScreen!.scrollController != null) {
        currentScreen!.scrollController.animateTo(
          currentScreen!.scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<bool> onWillPop(BuildContext context) async {
    final currentNavigatorState = currentScreen!.navigatorState.currentState;
    if (currentNavigatorState!.canPop()) {
      currentNavigatorState.pop();
      return false;
    } else {
      if (currentTabIndex != HOME_PAGE) {
        setTab(HOME_PAGE);
        notifyListeners();
        return false;
      } else {
        return await showDialog(
          context: context,
          builder: (context) => const ExitAlertDialog(),
        );
      }
    }
  }
}
