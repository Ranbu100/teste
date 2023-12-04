import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api_client/recicla_app.dart';
import 'api_client/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.request();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();

  bool userLoggedIn = await PreferencesService.userLoggedIn;

  runApp(AppWidget(userLoggedIn: userLoggedIn));
}
