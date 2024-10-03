import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:wealth/presentation/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wealth/storage/secure_storage.dart';

void main() async {
  // runApp(const MyApp());

  try {
    SecureStorage storage = new SecureStorage();
    // Update the file path to point to the lib folder
    await dotenv.load(fileName: ".env");
    await storage.deleteSecureData("accessToken");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
          return MyApp();
        },
        designSize: const Size(375, 813),
      ),
    ),
  );

  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("506be808-8a21-4464-9b25-bce142e37352");
// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GlobalLoaderOverlay(
      child: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        child: InAppNotification(
          child: MaterialApp.router(
            title: 'Wealth app',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              // backgroundColor: Colors.white,
              appBarTheme: AppBarTheme(elevation: 0.0),
              // This is the theme of your application.
              //
              // TRY THIS: Try running your application with "flutter run". You'll see
              // the application has a blue toolbar. Then, without quitting the app,
              // try changing the seedColor in the colorScheme below to Colors.green
              // and then invoke "hot reload" (save your changes or press the "hot
              // reload" button in a Flutter-supported IDE, or press "r" if you used
              // the command line to start the app).
              //
              // Notice that the counter didn't reset back to zero; the application
              // state is not lost during the reload. To reset the state, use hot
              // restart instead.
              //
              // This works for code too, not just values: Most code changes can be
              // tested with just a hot reload.
              colorScheme: ColorScheme.fromSeed(seedColor: linkTextOrange),
              useMaterial3: true,
            ),
            routerConfig: router,
            // home: VerificationSuccessful(),
          ),
        ),
      ),
    );
  }
}
