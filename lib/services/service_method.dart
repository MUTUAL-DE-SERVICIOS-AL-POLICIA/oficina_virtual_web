import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:virtual_officine/bloc/contribution/contribution_bloc.dart';
import 'package:virtual_officine/bloc/loan/loan_bloc.dart';
import 'package:virtual_officine/components/dialog_action.dart';
import 'package:virtual_officine/main.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_officine/services/services.dart';


Future<dynamic> serviceMethod(
    bool mounted, BuildContext context, String method, Map<String, dynamic>? body, String urlAPI, bool accessToken, bool errorState) async {
  final Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
  };
  if (accessToken) {
    headers["Authorization"] = "Bearer ${prefs!.getString('token')}";
  }
  try {
    debugPrint('consumientod');
      var url = Uri.parse(urlAPI);
      // final ioc = HttpClient();
      // ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      // final http = IOClient(ioc);
      debugPrint('==========================================');
      debugPrint('== method $method');
      debugPrint('== url $url');
      debugPrint('== body $body');
      debugPrint('== headers $headers');
      debugPrint('==========================================');
      switch (method) {
        case 'get':
          return await http.get(url, headers: headers).timeout(const Duration(seconds: 40)).then((value) {
            debugPrint('statusCode ${value.statusCode}');
            debugPrint('value ${value.body}');
            switch (value.statusCode) {
              case 200:
                return value;
              default:
                if (errorState) {
                  return confirmDeleteSession(mounted, context, false);
                }
                return null;
            }
          }).catchError((err) {
            debugPrint('errA $err');
            if ('$err'.contains('html')) {
              callDialogAction(context, 'Tenemos un problema con nuestro servidor, intente luego');
            } else if ('$err' == 'Software caused connection abort' || '$err' == 'Connection reset by peer') {
              callDialogAction(context, 'Verifique su conexión a Internet');
            } else {
              callDialogAction(context, 'Lamentamos los inconvenientes, intentalo de nuevo');
            }
            return null;
          });
        case 'post':
          return await http.post(url, headers: headers, body: json.encode(body)).timeout(const Duration(seconds: 40)).then((value) {
            debugPrint('statusCode ${value.statusCode}');
            debugPrint('value ${value.body}');
            switch (value.statusCode) {
              case 200:
                return value;
              case 201:
                return value;
              default:
                callDialogAction(context, json.decode(value.body)['message']);
                return null;
            }
          }).catchError((err) {
            debugPrint('errA $err');
            if ('$err'.contains('html')) {
              callDialogAction(context, 'Tenemos un problema con nuestro servidor, intente luego');
            } else if ('$err' == 'Software caused connection abort' || '$err' == 'Connection reset by peer') {
              callDialogAction(context, 'Verifique su conexión a Internet');
            } else {
              callDialogAction(context, 'Lamentamos los inconvenientes, intentalo de nuevo');
            }
            return null;
          });
        case 'delete':
          return await http.delete(url, headers: headers).timeout(const Duration(seconds: 40)).then((value) {
            debugPrint('statusCode ${value.statusCode}');
            debugPrint('value ${value.body}');
            switch (value.statusCode) {
              case 200:
                return value;
              default:
                callDialogAction(context, json.decode(value.body)['message']);
                return null;
            }
          }).catchError((err) {
            debugPrint('errA $err');
            if ('$err'.contains('html')) {
              callDialogAction(context, 'Tenemos un problema con nuestro servidor, intente luego');
            } else if ('$err' == 'Software caused connection abort' || '$err' == 'Connection reset by peer') {
              callDialogAction(context, 'Verifique su conexión a Internet');
            } else {
              callDialogAction(context, 'Lamentamos los inconvenientes, intentalo de nuevo');
            }
            return null;
          });
        case 'patch':
          return await http.patch(url, headers: headers, body: json.encode(body)).timeout(const Duration(seconds: 60)).then((value) {
            debugPrint('statusCode ${value.statusCode}');
            debugPrint('value ${value.body}');
            switch (value.statusCode) {
              case 200:
                return value;
              default:
                callDialogAction(context, json.decode(value.body)['message']);
                return null;
            }
          }).catchError((err) {
            debugPrint('errA $err');
            if ('$err'.contains('html')) {
              callDialogAction(context, 'Tenemos un problema con nuestro servidor, intente luego');
            } else if ('$err' == 'Software caused connection abort' || '$err' == 'Connection reset by peer') {
              callDialogAction(context, 'Verifique su conexión a Internet');
            } else {
              callDialogAction(context, 'Lamentamos los inconvenientes, intentalo de nuevo');
            }
            return null;
          });
      }
  } on TimeoutException catch (e) {
    debugPrint('errB $e');
    if (!mounted) return;
    return callDialogAction(context, 'Tenemos un problema con nuestro servidor, intente luego');
  } on SocketException catch (e) {
    debugPrint('errC $e');
    if (!mounted) return;
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } on ClientException catch (e) {
    debugPrint('errD $e');
    if (!mounted) return;
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } on MissingPluginException catch (e) {
    debugPrint('errF $e');
    if (!mounted) return;
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } catch (e) {
    debugPrint('errG $e');
    if (!mounted) return;
    callDialogAction(context, '$e');
  }
}

void callDialogAction(BuildContext context, String message) {
  showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => DialogAction(message: message));
}

confirmDeleteSession(bool mounted, BuildContext context, bool voluntary) async {
  debugPrint('cerrando');
  final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: false);
  final loanBloc = BlocProvider.of<LoanBloc>(context, listen: false);
  

  if (voluntary) {
    if (!mounted) return;
    await serviceMethod(mounted, context, 'delete', null, serviceAuthSession(prefs!.getInt('affiliateId')!), true, false);
  } 
  await prefs!.clear();
  contributionBloc.add(ClearContributions());
  loanBloc.add(ClearLoans());
  if (!mounted) return;
  Navigator.pushReplacementNamed(context, '/');
}
