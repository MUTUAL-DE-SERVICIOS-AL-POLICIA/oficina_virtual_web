import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_officine/bloc/user/user_bloc.dart';
import 'package:virtual_officine/main.dart';
import 'package:virtual_officine/model/user_model.dart';

//WIDGET: verifica la autenticación del usuario
class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //llamamos a los proveedores de estados
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          //verificamos si el usuario está autenticado
          future: getToken(),
          // prefs!.getString('token') ,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('');
            if (snapshot.data == '') {
              debugPrint('holaaaa');
              Future.microtask(() {
                Navigator.pushNamed(context, '/auth');
              });
            } else {
              getInfo(context);
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
      final string = prefs!.getString('token') ;
      return '$string';
    } else {
      return '';
    }
  }

  getInfo(BuildContext context) async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    debugPrint('hay usuario');

    UserModel user = userModelFromJson(prefs!.getString('user')!);
    userBloc.add(UpdateUser(user.user!));
    Future.microtask(() {
      Navigator.pushNamed(context, '/office');
    });
  }
}
