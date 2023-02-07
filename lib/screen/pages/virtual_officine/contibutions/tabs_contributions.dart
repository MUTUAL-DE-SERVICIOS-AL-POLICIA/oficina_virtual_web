import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:virtual_officine/bloc/contribution/contribution_bloc.dart';
import 'package:virtual_officine/components/containers.dart';
import 'package:virtual_officine/model/contribution_model.dart';
import 'package:virtual_officine/screen/pages/virtual_officine/contibutions/card_contribution.dart';

class TabsContributions extends StatefulWidget {
  const TabsContributions({Key? key}) : super(key: key);

  @override
  State<TabsContributions> createState() => _TabsContributionsState();
}

class _TabsContributionsState extends State<TabsContributions> with TickerProviderStateMixin {
  List<ContributionsTotal> contributionsTotal = [];
  TabController? tabController;
  bool stateSubtract = true;
  bool stateAdd = false;
  @override
  void initState() {
    super.initState();
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: false).state;
    setState(() {
      contributionsTotal = contributionBloc.contribution!.payload.contributionsTotal!;
      tabController = TabController(vsync: this, length: contributionsTotal.length, initialIndex: contributionsTotal.length - 1);
    });
    tabController!.addListener(() {
      setState(() {
        if (tabController!.index == 0) {
          stateSubtract = false;
        } else {
          stateSubtract = true;
        }
        if (tabController!.index == tabController!.length - 1) {
          stateAdd = false;
        } else {
          stateAdd = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:Column(
      children: [
           Table(columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(3),
          }, children: [
            TableRow(children: [
              stateSubtract
                  ? years(stateSubtract, TextDirection.ltr, contributionsTotal[tabController!.index - 1].year,
                      () => setState(() => tabController!.animateTo(tabController!.index - 1)), 1)
                  : Container(),
              ContainerComponent(
                color: const Color(0xff419388),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    contributionsTotal[tabController!.index].year,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              stateAdd
                  ? years(stateAdd, TextDirection.rtl, contributionsTotal[tabController!.index + 1].year,
                      () => setState(() => tabController!.animateTo(tabController!.index + 1)), 0.5)
                  : Container()
            ])
          ]),
        Expanded(
          child: DefaultTabController(
              length: contributionsTotal.length,
              initialIndex: contributionsTotal.length - 1,
              child: TabBarView(
                controller: tabController,
                children: [
                  for (var i = 0; i <= contributionsTotal.length - 1; i++)
                    ContributionsYear(
                      tabController: tabController!,
                      year: '${contributionsTotal[i].year}',
                      contributions: contributionsTotal[i].contributions,
                    ),
                ],
              )),
        ),
      ],
    )));
  }

  Widget years(bool state, TextDirection textDirection, String text, Function() onTap, double value) {
    return MaterialButton(
        onPressed: () => onTap(),
        child: Row(
          textDirection: textDirection,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: RotationTransition(
                  turns: AlwaysStoppedAnimation(value),
                  child: SvgPicture.asset(
                    'assets/icons/back.svg',
                    height: 20,
                    color: Colors.black
                  )),
            ),
            Text(text, style: const TextStyle(fontSize: 20)),
          ],
        ));
  }
}
