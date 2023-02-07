import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_officine/locator.dart';
import 'package:virtual_officine/router/router.dart';
import 'package:virtual_officine/services/navigation_service.dart';
import 'package:virtual_officine/utils/style.dart';

import 'bloc/contribution/contribution_bloc.dart';
import 'bloc/loan/loan_bloc.dart';
import 'bloc/user/user_bloc.dart';

SharedPreferences? prefs;
void main() async {
  setupLocator();
  Flurorouter.configureRoutes();
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => ContributionBloc()),
          BlocProvider(create: (_) => LoanBloc()),
        ],
        child:  MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('es', 'ES'), // Spanish
                Locale('en', 'US'), // English
              ],
              debugShowCheckedModeBanner: false,
              theme: styleLigth(),
              title: 'MUSERPOL PVT',
              initialRoute: '/',
              onGenerateRoute: Flurorouter.router.generator,
              navigatorKey: locator<NavigationService>().navigatorKey,
            ));
  }
}
