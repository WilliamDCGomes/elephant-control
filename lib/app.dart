import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app/views/stylePages/app_colors.dart';
import 'flavors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  final MaterialColor color;
  const App({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.defaultColor,
      systemNavigationBarColor: AppColors.defaultColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return ResponsiveSizer(builder: (context, orientation, screentype) {
      return GetMaterialApp(
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('pt', 'BR'),
        ],
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: AppColors.defaultColor,
          primarySwatch: widget.color,
        ),
        getPages: [
          GetPage(name: "/initialPage", page: () => F.initialScreen),
        ],
        initialRoute: "/initialPage",
      );
    });
  }
}
