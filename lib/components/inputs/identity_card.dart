import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:virtual_officine/components/button.dart';
import 'package:virtual_officine/components/input.dart';

class IdentityCard extends StatefulWidget {
  final String title;
  final TextEditingController dniCtrl;
  final TextEditingController dniComCtrl;
  final FocusNode textSecondFocusNode;
  final TextInputFormatter formatter;
  final TextInputType keyboardType;
  final Function() onEditingComplete;
  final Function() stateAlphanumericFalse;
  final bool? stateAlphanumeric;
  const IdentityCard(
      {Key? key,
      required this.title,
      required this.dniCtrl,
      required this.dniComCtrl,
      required this.textSecondFocusNode,
      required this.formatter,
      required this.keyboardType,
      required this.onEditingComplete,
      this.stateAlphanumeric = true,
      required this.stateAlphanumericFalse})
      : super(key: key);

  @override
  State<IdentityCard> createState() => _IdentityCardState();
}

class _IdentityCardState extends State<IdentityCard> {
  final tooltipController = JustTheController();
  bool dniComplement = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: InputComponent(
                    textInputAction: TextInputAction.next,
                    controllerText: widget.dniCtrl,
                    onEditingComplete: () => widget.onEditingComplete(),
                    validator: (value) {
                      if (value.length > 3) {
                        return null;
                      } else {
                        return 'Ingrese su cédula de indentidad';
                      }
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(10), widget.formatter],
                    keyboardType: widget.keyboardType,
                    textCapitalization: TextCapitalization.characters,
                    icon: Icons.person,
                    labelText: "Cédula de indentidad",
                  ),
                ),
                if (dniComplement)
                  const Text(
                    '  _  ',
                    style: TextStyle(fontSize: 15, color: Color(0xff419388)),
                  ),
                if (dniComplement)
                  Expanded(
                    flex: 1,
                    child: InputComponent(
                      focusNode: widget.textSecondFocusNode,
                      textInputAction: TextInputAction.next,
                      controllerText: widget.dniComCtrl,
                      inputFormatters: [LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
                      onEditingComplete: () => widget.onEditingComplete(),
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return null;
                        } else {
                          return 'complemento';
                        }
                      },
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      icon: Icons.person,
                      labelText: "Complemento",
                    ),
                  ), //container
              ], //widget
            ),
          ],
        ),
        if (widget.stateAlphanumeric!)
          Buttontoltip(
            tooltipController: tooltipController,
            onPressed: (bool state) => functionToltip(state),
          )
      ],
    );
  }

  functionToltip(bool state) async {
    setState(() {
      if (!state) widget.stateAlphanumericFalse();
      dniComplement = state;
      tooltipController.hideTooltip();
    });
  }
}
