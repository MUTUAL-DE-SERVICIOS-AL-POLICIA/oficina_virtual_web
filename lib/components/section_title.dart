import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectiontitleComponent extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData icon;
  final Function() onTap;
  final bool? stateLoading;
  const SectiontitleComponent(
      {Key? key,
      required this.title,
      this.subTitle,
      required this.icon,
      required this.onTap,
      this.stateLoading = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle!,
            )
          : null,
      trailing: stateLoading!
          ? Image.asset(
              'assets/images/load.gif',
              fit: BoxFit.cover,
              height: 15,
            )
          : Icon(
              icon,
              size: 15,
              color:Colors.black,
            ),
      onTap: onTap,
    );
  }
}

class SectiontitleSwitchComponent extends StatelessWidget {
  final String title;
  final bool valueSwitch;
  final Function(bool) onChangedSwitch;
  const SectiontitleSwitchComponent(
      {Key? key,
      required this.title,
      required this.valueSwitch,
      required this.onChangedSwitch})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: CupertinoSwitch(
        activeColor: const Color(0xfff2f2f2),
        value: valueSwitch,
        onChanged: onChangedSwitch,
      ),
    );
  }
}
