import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:virtual_officine/utils/nav.dart';

class NavigationDown extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final GlobalKey keyBottomNavigation1;
  final GlobalKey keyBottomNavigation2;
  const NavigationDown(
      {Key? key, required this.currentIndex, required this.onTap, required this.keyBottomNavigation1, required this.keyBottomNavigation2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: Center(
                child: SizedBox(
                  key: keyBottomNavigation1,
                  height: 40,
                  width: MediaQuery.of(context).size.width / 4,
                ),
              )),
              Expanded(
                  child: Center(
                child: SizedBox(
                  key: keyBottomNavigation2,
                  height: 40,
                  width: MediaQuery.of(context).size.width / 4,
                ),
              )),
            ],
          ),
        ),
        CurvedNavigationBar(
          height: 76.0,
          items: [
            CurvedNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/newProcedure.svg', height: 25, color: currentIndex == 0 ? Colors.black : Colors.white),
                label: "Aportes"),
            CurvedNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/historyProcedure.svg', height: 25, color: currentIndex == 1 ? Colors.black : Colors.white),
                label: "Préstamos"),
          ],
          animationCurve: Curves.fastOutSlowIn,
          onTap: (i) => onTap(i),
          letIndexChange: (index) => true,
        ),
      ],
    );
  }
}
