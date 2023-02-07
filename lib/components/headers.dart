import 'package:flutter/material.dart';

class HedersComponent extends StatefulWidget {
  final String? titleHeader;
  final String? title;
  final bool center;
  final bool? stateBell;
  final GlobalKey? keyNotification;
  final bool? stateIconMuserpol;
  final bool stateBack;
  const HedersComponent(
      {Key? key,
      this.titleHeader,
      this.title = '',
      this.center = false,
      this.stateBell = false,
      this.keyNotification,
      this.stateIconMuserpol = true,
      this.stateBack = true})
      : super(key: key);

  @override
  State<HedersComponent> createState() => _HedersComponentState();
}

class _HedersComponentState extends State<HedersComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
            automaticallyImplyLeading: widget.stateBack,
            leadingWidth: 20,
            title: Text(widget.titleHeader ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
            actions: [
              if (widget.stateIconMuserpol!)
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: Image.asset(
                      'assets/icons/favicon.png',
                      color: const Color(0xff419388),
                      width: 30,
                    )),
            ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(widget.title!,
              textAlign: widget.center ? TextAlign.center : TextAlign.start, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
