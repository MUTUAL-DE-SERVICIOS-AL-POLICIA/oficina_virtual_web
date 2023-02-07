import 'package:flutter/material.dart';
// import 'package:theme_provider/theme_provider.dart';

class ContainerComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool? stateBorder;
  const ContainerComponent(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      this.color,
      this.stateBorder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color??const Color(0xfff2f2f2),
              boxShadow: [
                if(stateBorder!)
                const BoxShadow(
                  color: Color(0xff419388),
                  blurRadius: 1.0,
                  offset: Offset(0, 0.5),
                )
              ],
            ),
            child: child));
  }
}
