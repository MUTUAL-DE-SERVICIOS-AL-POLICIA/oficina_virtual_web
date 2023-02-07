import 'package:flutter/material.dart';
import 'package:virtual_officine/components/animate.dart';
import 'package:virtual_officine/components/button.dart';
import 'package:virtual_officine/components/dialog_action.dart';
import 'package:virtual_officine/components/headers.dart';
import 'package:virtual_officine/components/inputs/password.dart';

class ModalUpdatePwd extends StatefulWidget {
  final String message;
  final Function(String) onPressed;
  final bool stateLoading;
  const ModalUpdatePwd({Key? key, required this.message, required this.onPressed, required this.stateLoading})
      : super(key: key);

  @override
  State<ModalUpdatePwd> createState() => _ModalUpdatePwdState();
}

class _ModalUpdatePwdState extends State<ModalUpdatePwd> with TickerProviderStateMixin {
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController newPasswordConfirmCtrl = TextEditingController();

  bool hidePassword = true;
  bool hidePasswordConfirm = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: HedersComponent(title: widget.message, center: true)),
          Expanded(
              child: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Password(passwordCtrl: newPasswordCtrl, onEditingComplete: () => node.nextFocus()),
                      Password(
                          passwordCtrl: newPasswordConfirmCtrl,
                          onEditingComplete: () => updatePassword(),
                          validator: (value) {
                            if (value == newPasswordCtrl.text) {
                              return null;
                            } else {
                              return 'No coincide la contraseña';
                            }
                          })
                    ],
                  ),
                )),
          )),
          widget.stateLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWhiteComponent(
                        text: 'Cancelar',
                        onPressed: () => _onBackPressed(),
                      ),
                      ButtonComponent(text: 'Actualizar', onPressed: () => updatePassword())
                    ],
                  ),
                )
              : Center(
                  child: Image.asset(
                  'assets/images/load.gif',
                  fit: BoxFit.cover,
                  height: 20,
                ))
        ])));
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ComponentAnimate(
            child: DialogTwoAction(
                message: '¿Deseas salir de la actualización de contraseña?',
                actionCorrect: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                messageCorrect: 'Salir')));
  }

  updatePassword() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    widget.onPressed(newPasswordConfirmCtrl.text.trim());
  }
}
