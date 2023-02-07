import 'package:flutter/material.dart';
import 'package:virtual_officine/main.dart';
import 'package:virtual_officine/screen/navigator_bar.dart';

//WIDGET: verifica la autenticación del usuario
class CheckAuthNav extends StatelessWidget {
  const CheckAuthNav({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //llamamos a los proveedores de estados
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          //verificamos si el usuario está autenticado
          future: getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('');
            if (snapshot.data == '') {
              debugPrint('holaaaa');
              Future.microtask(() {
                Navigator.pushNamed(context, '/auth');
              });
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context, PageRouteBuilder(pageBuilder: (_, __, ___) => const NavigatorBar(), transitionDuration: const Duration(seconds: 0)));
              });
            }
            return const Scaffold();
          },
        ),
      ),
    );
  }

  Future<String> getToken() async {
    // await Future.delayed(Duration(seconds: 1));
    if (prefs!.containsKey('token')) {
      final string = prefs!.getString('token');
      return '$string';
    } else {
      return '';
    }
  }
}
