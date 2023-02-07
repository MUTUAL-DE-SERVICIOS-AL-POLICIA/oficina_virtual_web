

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_officine/bloc/contribution/contribution_bloc.dart';
import 'package:virtual_officine/bloc/loan/loan_bloc.dart';
import 'package:virtual_officine/components/animate.dart';
import 'package:virtual_officine/components/dialog_action.dart';
import 'package:virtual_officine/main.dart';
import 'package:virtual_officine/model/contribution_model.dart';
import 'package:virtual_officine/model/loan_model.dart';
import 'package:virtual_officine/screen/navigator_down.dart';
import 'package:virtual_officine/screen/pages/menu.dart';
import 'package:virtual_officine/services/service_method.dart';
import 'package:virtual_officine/services/services.dart';

import 'pages/virtual_officine/contibutions/contribution.dart';
import 'pages/virtual_officine/loans/loan.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({Key? key}) : super(key: key);

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> with SingleTickerProviderStateMixin {
  var _currentIndex = 0;

  int pageCurrent = 1;
  int pageHistory = 1;
  bool stateProcessing = false;

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomHeader = GlobalKey();
  GlobalKey keyCreateProcedure = GlobalKey();
  GlobalKey keyNotification = GlobalKey();
  GlobalKey keyMenu = GlobalKey();
  GlobalKey keyRefresh = GlobalKey();

  List<Widget> pageList = [];

  bool stateLoad = true;
  bool? stateLoadTutorial;
  bool consumeService = true;

  late TabController tabController;

  @override
  void initState() {
    services();
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  services() async {
    debugPrint('OBTENINENDO TODOS LOS APORTES Y PRESTAMOS');
    await getLoans();
    await getContributions();
    
  }

  getContributions() async {
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null, serviceContributions(prefs!.getInt('affiliateId')!), true, true);
    if (response != null) {
      contributionBloc.add(UpdateContributions(contributionModelFromJson(response.body)));
    }
  }

  getLoans() async {
    final loanBloc = BlocProvider.of<LoanBloc>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(mounted, context, 'get', null, serviceLoans(prefs!.getInt('affiliateId')!), true, true);
    if (response != null) {
      loanBloc.add(UpdateLoan(loanModelFromJson(response.body)));
    }
  }

  @override
  Widget build(BuildContext context) {
    pageList = [ScreenContributions(keyNotification: keyNotification), ScreenPageLoans(keyNotification: keyNotification)];

    final size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            drawer: MenuDrawer(tabController: tabController),
            drawerEnableOpenDragGesture: true,
            endDrawerEnableOpenDragGesture: true,
            body: Stack(children: [
              Column(
                children: [
                  const SizedBox(height: 25),
                  SizedBox(
                    key: keyMenu,
                    height: MediaQuery.of(context).size.width / 6,
                    width: MediaQuery.of(context).size.width / 6,
                  )
                ],
              ),
              Row(
                children: [
                  if (size.width > 1000) Expanded(flex: 1, child: MenuDrawer(tabController: tabController)),
                  size.width > 1000
                      ? Expanded(
                          flex: 3,
                          child: TabBarView(
                            controller: tabController,
                            children: [ScreenPageLoans(keyNotification: keyNotification), ScreenContributions(keyNotification: keyNotification)],
                          ),
                        )
                      : Expanded(child: pageList.elementAt(_currentIndex))
                ],
              ),
            ]),
            bottomNavigationBar: (size.width > 1000)
                ? null
                : NavigationDown(
                    currentIndex: _currentIndex,
                    keyBottomNavigation1: keyBottomNavigation1,
                    keyBottomNavigation2: keyBottomNavigation2,
                    onTap: (i) => setState(() => _currentIndex = i),
                  )));
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ComponentAnimate(
              child: DialogTwoAction(
                  message: '¿Estás seguro de salir de la oficina virtual?',
                  actionCorrect: () => confirmDeleteSession(mounted, context, true),
                  messageCorrect: 'Salir'));
        });
  }
}
