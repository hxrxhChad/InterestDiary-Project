import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khatadiary/common/style.dart';
import 'package:khatadiary/common/theme.dart';
import 'package:khatadiary/firebase_options.dart';
import 'package:khatadiary/page/auth-page.dart';
import 'package:khatadiary/page/control-page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: white1, // navigation bar color
    statusBarColor: white1, // status bar color
    statusBarIconBrightness: Brightness.dark, // status bar icon color
    systemNavigationBarIconBrightness:
        Brightness.dark, // color of navigation controls
  ));
  runApp(MainApp(
    email: email,
  ));
}

class MainApp extends StatelessWidget {
  final String? email;
  const MainApp({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Yo, Chill!',
        theme: lightTheme(context),
        debugShowCheckedModeBanner: false,
        home: email == null
            ? const AuthPage() // login page
            : const ControlPage());
  }
}
