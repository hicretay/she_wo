import 'package:she_wo/providers/navigationProvider.dart';
import 'package:she_wo/providers/themeDataProvider.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  static const route = '/rootPage';

  const Root({Key? key}) : super(key: key);
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        //------------------Bottom Bar itemları görünümleri----------------
        final bottomNavigationBarItems = provider.screens
            .map(
              (screen) => BottomNavigationBarItem(
                icon: screen.icon,
                activeIcon: screen.activeIcon,
                label: screen.title,
              ),
            )
            .toList();
        //------------------------------------------------------------
        // Her ekran için Navigatorı başlatır
        final screens = provider.screens
            .map(
              (screen) => Navigator(
                key: screen.navigatorState,
                onGenerateRoute: screen.onGenerateRoute,
              ),
            )
            .toList();
        return WillPopScope(
          onWillPop: () async => provider.onWillPop(context),
          child: Scaffold(
            body: IndexedStack(
              index: provider.currentTabIndex,
              children: screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: primaryColor,
              selectedItemColor: Provider.of<ThemeDataProvider>(context, listen: true).isLightTheme ? Colors.amber : Colors.pink,
              elevation: 10,
              items: bottomNavigationBarItems,
              currentIndex: provider.currentTabIndex,
              onTap: provider.setTab,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedFontSize: 0,
              selectedFontSize: 0,
            ),
          ),
        );
      },
    );
  }
}
