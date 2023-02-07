
import 'package:flutter/material.dart';
import 'package:virtual_officine/components/animate.dart';
import 'package:virtual_officine/components/button.dart';

class DialogAction extends StatelessWidget {
  final String message;
  const DialogAction({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ComponentAnimate(
        child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
      content: ButtonComponent(text: 'Aceptar', onPressed: () => Navigator.pop(context)),
    ));
  }
}

class DialogOneFunction extends StatelessWidget {
  final String title;
  final String message;
  final String textButton;
  final Function() onPressed;
  const DialogOneFunction({Key? key, required this.title, required this.message, required this.textButton, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: ComponentAnimate(
            child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                message,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          actions: <Widget>[ButtonComponent(text: textButton, onPressed: () => onPressed())],
        )));
  }

  Future<bool> _onBackPressed() async {
    return false;
  }
}

class DialogTwoAction extends StatefulWidget {
  final String message;
  final Function() actionCorrect;
  final Function()? actionCancel;
  final String messageCorrect;

  const DialogTwoAction({Key? key, required this.message, required this.actionCorrect, this.actionCancel, required this.messageCorrect})
      : super(key: key);

  @override
  State<DialogTwoAction> createState() => _DialogTwoActionState();
}

class _DialogTwoActionState extends State<DialogTwoAction> {
  bool stateBottons = true;
  @override
  Widget build(BuildContext context) {
    return ComponentAnimate(
        child: AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        widget.message,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ButtonWhiteComponent(
              text: 'Cancelar',
              onPressed: stateBottons ? widget.actionCancel ?? () => Navigator.of(context).pop() : () {},
            ),
            ButtonWhiteComponent(
                text: widget.messageCorrect,
                onPressed: () async {
                  setState(() => stateBottons = !stateBottons);
                  await widget.actionCorrect();
                  setState(() => stateBottons = !stateBottons);
                })
          ],
        )
      ],
    ));
  }
}
