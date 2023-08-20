import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/navigation_provider.dart';
import 'providers/theme_data_provider.dart';
import 'screens/splash_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main de runApp'ten önce işlem yapılabilmesini sağlar
  await ThemeDataProvider().createSharedPrefObj();
  initializeDateFormatting()
      .then((_) => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(
            ChangeNotifierProvider<ThemeDataProvider>(create: (BuildContext context) => ThemeDataProvider(), child: const App()),
          )));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeDataProvider>(context, listen: false).loadTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider<ThemeDataProvider>(create: (BuildContext context) => ThemeDataProvider(), child: const App()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: Provider.of<ThemeDataProvider>(context).themeColor,
            onGenerateRoute: NavigationProvider.of(context).onGenerateRoute,
            debugShowCheckedModeBanner: false,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
