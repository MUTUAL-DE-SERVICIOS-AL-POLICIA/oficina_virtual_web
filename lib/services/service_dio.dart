import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:virtual_officine/components/dialog_action.dart';
import 'package:virtual_officine/main.dart';

serviceMethoDio(BuildContext context, String method, Map<String, dynamic>? data, String urlAPI, bool accessToken) async {
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  if (accessToken) {
    headers["Authorization"] = "Bearer ${prefs!.getString('token')}";
  }
  final options = Options(responseType: ResponseType.bytes, validateStatus: (status) => status! <= 500, headers: headers);
  debugPrint('==========================================');
  debugPrint('== method $method');
  debugPrint('== url $urlAPI');
  debugPrint('== body $data');
  debugPrint('== headers $headers');
  debugPrint('==========================================');
  var dio = Dio();

  switch (method) {
    case 'get':
      try {
        debugPrint('enviando metodo get');
        return await dio.get(urlAPI, options: options).timeout(const Duration(seconds: 10)).then((value) {
          debugPrint('response.data ${value.data}');
          debugPrint('value.statusCode ${value.statusCode}');
          switch (value.statusCode) {
            case 200:
              return value;
            default:
              Navigator.of(context).pop();
              return null;
          }
        }).catchError((err) {
          debugPrint('err $err');
          Navigator.of(context).pop();
          callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
          return null;
        });
      } on DioError catch (error) {
        Navigator.of(context).pop();
        callDialogAction(context, error.response!.data);
        return null;
      }
    case 'post':
      try {
        return await dio.post(urlAPI, data: data, options: options).timeout(const Duration(seconds: 10)).then((value) {
          debugPrint('response.data ${value.data}');
          debugPrint('value.statusCode ${value.statusCode}');
          switch (value.statusCode) {
            case 200:
              return value;
            default:
              Navigator.of(context).pop();
              callDialogAction(context, json.decode(value.data)['message']);
              return null;
          }
        }).catchError((err) {
          debugPrint('err $err');
          Navigator.of(context).pop();
          return callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
        });
      } on DioError catch (error) {
        Navigator.of(context).pop();
        return callDialogAction(context, error.response!.data);
      }
  }
}

void callDialogAction(BuildContext context, String message) {
  showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => DialogAction(message: message));
}
