import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_officine/bloc/loan/loan_bloc.dart';
import 'package:virtual_officine/components/button.dart';
import 'package:virtual_officine/components/headers.dart';
import 'package:virtual_officine/main.dart';
import 'package:virtual_officine/model/loan_model.dart';
import 'package:virtual_officine/screen/pages/virtual_officine/loans/card_loan.dart';
import 'package:virtual_officine/services/service_method.dart';
import 'package:virtual_officine/services/services.dart';

class ScreenPageLoans extends StatefulWidget {
  final GlobalKey keyNotification;
  const ScreenPageLoans({Key? key, required this.keyNotification}) : super(key: key);

  @override
  State<ScreenPageLoans> createState() => _ScreenPageLoansState();
}

class _ScreenPageLoansState extends State<ScreenPageLoans> {
  @override
  Widget build(BuildContext context) {
    final loanBloc = BlocProvider.of<LoanBloc>(context, listen: true);
    final size = MediaQuery.of(context).size;
    return Column(children: [
      HedersComponent(
        keyNotification: widget.keyNotification,
        title: 'Mis Préstamos',
        stateBell: true,
        stateBack: (size.width > 1000) ? false : true,
      ),
      Expanded(
        child: CustomRefreshIndicator(
          onRefresh: () async {
            Future.delayed(const Duration(seconds: 3));
            reloadLoans();
          },
          builder: MaterialIndicatorDelegate(builder: (context, controller) {
            return Image.asset(
              'assets/images/load.gif',
              fit: BoxFit.cover,
              height: 10,
            );
          }),
          child: SingleChildScrollView(
              child: loanBloc.state.existLoan
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        if (loanBloc.state.loan!.notification! != '')
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0), color: const Color(0xffD2EAFA)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline_rounded),
                                    const SizedBox(width: 10),
                                    Flexible(
                                        child: Text(
                                      loanBloc.state.loan!.notification!,
                                    )),
                                  ],
                                ),
                              )),
                        if (loanBloc.state.loan!.payload!.inProcess!.isNotEmpty)
                          loans('Prestamos en proceso:', [
                            for (var item in loanBloc.state.loan!.payload!.inProcess!)
                              CardLoan(itemProcess: item, color: const Color(0xffB3D4CF))
                          ]),
                        if (loanBloc.state.loan!.payload!.current!.isNotEmpty)
                          loans('Prestamos vigentes:',
                              [for (var item in loanBloc.state.loan!.payload!.current!) CardLoan(itemCurrent: item)]),
                        if (loanBloc.state.loan!.payload!.liquited!.isNotEmpty)
                          loans('Prestamos Liquidados:',
                              [for (var item in loanBloc.state.loan!.payload!.liquited!) CardLoan(itemCurrent: item)]),
                        if (loanBloc.state.loan!.error == 'true') Text(loanBloc.state.loan!.message!),
                        Center(
                            child:
                                IconBtnComponent(iconText: 'assets/icons/reload.svg', onPressed: () => reloadLoans())),
                        const SizedBox(height: 70)
                      ]),
                    )
                  : Image.asset(
                      'assets/images/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    )),
        ),
      ),
    ]);
  }

  reloadLoans() async {
    final loanBloc = BlocProvider.of<LoanBloc>(context, listen: false);

    loanBloc.add(ClearLoans());
    if (!mounted) return;
    var response =
        await serviceMethod(mounted, context, 'get', null, serviceLoans(prefs!.getInt('affiliateId')!), true, true);
    if (response != null) {
      loanBloc.add(UpdateLoan(loanModelFromJson(response.body)));
    }
  }

  Widget loans(String text, List<Widget> cards) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(text, style: const TextStyle(fontWeight: FontWeight.bold)), ...cards],
      ),
    );
  }
}
