import 'package:flutter/material.dart';
import 'package:virtual_officine/components/animate.dart';
import 'package:virtual_officine/components/dialog_action.dart';
import 'package:virtual_officine/components/headers.dart';
import 'package:virtual_officine/components/susessful.dart';
import 'package:virtual_officine/screen/access/forgot_password/code.dart';
import 'package:virtual_officine/screen/access/forgot_password/credentials.dart';
import 'package:virtual_officine/services/service_method.dart';
import 'package:virtual_officine/services/services.dart';

class ForgotPwd extends StatefulWidget {
  const ForgotPwd({Key? key}) : super(key: key);

  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  TextEditingController dniCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController dniComCtrl = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();

  bool dateState = false;
  bool btnAccess = true;
  bool stateSendSms = false;
  String? dateCtrlText;

  String stateForgot = "credentials";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String dateCtrl = '';
  DateTime currentDate = DateTime(1950, 1, 1);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => backAcction(),
        child: Scaffold(
            body: Column(children: [
                  const HedersComponent(title: 'Recuperar Contraseña'),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if(size.width > 1000)
                                 const Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 40),
                                        child: Center(
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/forget.png',
                                            ),
                                          ),
                                        ),
                                      )),
                                Expanded(
                                      flex: 1,
                                    child: Center(
                                  child: SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(horizontal: 40),
                                      child: Column(children: [
                                    btnAccess
                                        ? Form(
                                            key: formKey,
                                            child: Column(
                                              children: [
                                                if (stateForgot == 'credentials')
                                                  CredentialForgotPwd(
                                                      dniCtrl: dniCtrl,
                                                      dniComCtrl: dniComCtrl,
                                                      phoneCtrl: phoneCtrl,
                                                      dateState: dateState,
                                                      currentDate: currentDate,
                                                      dateCtrl: dateCtrl,
                                                      selectDate: (date, dateCurrent, dateFormat) {
                                                        setState(() {
                                                          dateCtrl = date;
                                                          currentDate = dateCurrent;
                                                          dateCtrlText = dateFormat;
                                                          dateState = false;
                                                        });
                                                      },
                                                      sendCredentials: () => sendCredentials(),
                                                      stateAlphanumericFalse: () => setState(() => dniComCtrl.text = '')),
                                                if (stateForgot == 'code')
                                                  CodeForgotPwd(
                                                    cellPhoneNumber: phoneCtrl.text,
                                                    dni: '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-${dniComCtrl.text.trim()}'}',
                                                    stateSendSms: stateSendSms,
                                                    resendcode: () => sendCredentials(),
                                                    correct: () {
                                                      if (!mounted) return;
                                                      return showSuccessful(context, 'CORRECTO', () {
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                  ),
                                              ],
                                            ))
                                        : Center(
                                            child: Image.asset(
                                            'assets/images/load.gif',
                                            fit: BoxFit.cover,
                                            height: 20,
                                          )),
                                  ])),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ])));
  }

  sendCredentials() async {
    setState(() => stateForgot = 'credentials');
    FocusScope.of(context).unfocus();
    validateDate();
    if (formKey.currentState!.validate()) {
      final Map<String, dynamic> body = {
        'ci': '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-${dniComCtrl.text.trim()}'}',
        'birth_date': dateCtrlText,
        'cell_phone_number': phoneCtrl.text.trim()
      };
      await Future.delayed(const Duration(milliseconds: 50), () {});
      setState(() {
        stateForgot = 'code';
        stateSendSms = !stateSendSms;
      });
      if (!mounted) return;
      var response = await serviceMethod(mounted, context, 'patch', body, serviceForgotPasswordOF(), false, true);
      setState(() => stateSendSms = !stateSendSms);
      if (response == null) {
        setState(() => stateForgot = 'credentials');
      }
    }
  }

  validateDate() {
    if (dateCtrlText == null) return setState(() => dateState = true);
    return setState(() => dateState = false);
  }
  Future<bool> backAcction() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ComponentAnimate(
              child: DialogTwoAction(
                  message: '¿Deseas salir de la actualización de contraseña?',
                  actionCorrect: () => Navigator.pushNamed(context, '/'),
                  messageCorrect: 'Salir'));
        });
  }
}
