import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app/views/stylePages/app_colors.dart';
import 'base/services/firebase_messaging_service.dart';
import 'base/services/notification_service.dart';
import 'flavors.dart';

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
  void initState() {
    super.initState();
  }

  _initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }

  _checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  }

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