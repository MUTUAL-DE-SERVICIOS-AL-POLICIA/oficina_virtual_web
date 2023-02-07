import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:virtual_officine/components/button.dart';
import 'package:virtual_officine/components/inputs/birth_date.dart';
import 'package:virtual_officine/components/inputs/identity_card.dart';
import 'package:virtual_officine/components/inputs/phone.dart';

class CredentialForgotPwd extends StatefulWidget {
  final TextEditingController dniCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController dniComCtrl;
  final bool dateState;
  final Function(String, DateTime, String) selectDate;
  final Function() sendCredentials;
  final Function() stateAlphanumericFalse;
  final DateTime currentDate;
  final String dateCtrl;
  const CredentialForgotPwd(
      {Key? key,
      required this.dniCtrl,
      required this.phoneCtrl,
      required this.dniComCtrl,
      required this.dateState,
      required this.selectDate,
      required this.sendCredentials,
      required this.currentDate,
      required this.dateCtrl,
      required this.stateAlphanumericFalse})
      : super(key: key);

  @override
  State<CredentialForgotPwd> createState() => _CredentialForgotPwdState();
}

class _CredentialForgotPwdState extends State<CredentialForgotPwd> {
  bool btnAccess = true;

  FocusNode textSecondFocusNode = FocusNode();
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IdentityCard(
            title: 'Cédula de identidad:',
            dniCtrl: widget.dniCtrl,
            dniComCtrl: widget.dniComCtrl,
            onEditingComplete: () => node.nextFocus(),
            textSecondFocusNode: textSecondFocusNode,
            keyboardType: TextInputType.number,
            formatter: FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            stateAlphanumericFalse: widget.stateAlphanumericFalse),
        const SizedBox(
          height: 10,
        ),
        BirthDate(
          dateState: widget.dateState,
          currentDate: widget.currentDate,
          dateCtrl: widget.dateCtrl,
          selectDate: (date, dateCurrent, dateFormat) => widget.selectDate(date, dateCurrent, dateFormat),
        ),
        const SizedBox(
          height: 10,
        ),
        PhoneNumber(phoneCtrl: widget.phoneCtrl, onEditingComplete: () {}),
        const SizedBox(
          height: 10,
        ),
        ButtonComponent(text: 'ENVIAR', onPressed: () => widget.sendCredentials())
      ],
    );
  }
}
