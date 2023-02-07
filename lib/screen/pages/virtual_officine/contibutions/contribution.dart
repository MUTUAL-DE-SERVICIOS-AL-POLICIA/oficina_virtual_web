import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:virtual_officine/bloc/contribution/contribution_bloc.dart';
import 'package:virtual_officine/components/containers.dart';
import 'package:virtual_officine/components/headers.dart';
import 'package:virtual_officine/main.dart';
import 'package:virtual_officine/screen/pages/virtual_officine/contibutions/tabs_contributions.dart';
import 'package:virtual_officine/services/service_dio.dart';
import 'package:virtual_officine/services/services.dart';

class ScreenContributions extends StatefulWidget {
  final GlobalKey? keyNotification;
  const ScreenContributions({Key? key, required this.keyNotification}) : super(key: key);

  @override
  State<ScreenContributions> createState() => _ScreenContributionsState();
}

class _ScreenContributionsState extends State<ScreenContributions> {
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: true).state;
    return Column(children: [
      HedersComponent(
          keyNotification: widget.keyNotification,
          title: 'Mis Aportes',
          stateBell: true,
          stateBack: (size.width > 1000) ? false : true),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !stateLoading
                ? Row(
                    children: [
                      if (contributionBloc.existContribution)
                        if (contributionBloc.contribution!.payload.hasContributionsActive!)
                          documentContribution(() => getContributionActive(), 'Certificación de Activo'),
                      if (contributionBloc.existContribution)
                        if (contributionBloc.contribution!.payload.hasContributionsPassive!)
                          documentContribution(() => getContributionPasive(), 'Certificación de Pasivo')
                    ],
                  )
                : Center(
                    child: Image.asset(
                    'assets/images/load.gif',
                    fit: BoxFit.cover,
                    height: 20,
                  )),
            if (contributionBloc.existContribution)
              const Text('Mis Aportes por año:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      !contributionBloc.existContribution
          ? Center(
              child: Image.asset(
              'assets/images/load.gif',
              fit: BoxFit.cover,
              height: 20,
            ))
          : const TabsContributions(),
    ]);
  }

  Widget documentContribution(Function() onPressed, String text) {
    final contributionBloc = BlocProvider.of<ContributionBloc>(context, listen: true).state;
    return contributionBloc.existContribution
        ? Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: MaterialButton(
                onPressed: () => onPressed(),
                child: ContainerComponent(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  getContributionPasive() async {
    debugPrint('disinto de null');
    setState(() => stateLoading = true);
    if (!mounted) return;
    var response = await serviceMethoDio(
        context, 'get', null, servicePrintContributionPasive(prefs!.getInt('affiliateId')!), true);
    setState(() => stateLoading = false);
    if (response != null) {
      await Printing.sharePdf(bytes: response.data, filename: 'my-document.pdf');
    }
  }

  getContributionActive() async {
    setState(() => stateLoading = true);
    if (!mounted) return;
    var response = await serviceMethoDio(
        context, 'get', null, servicePrintContributionActive(prefs!.getInt('affiliateId')!), true);
    setState(() => stateLoading = false);
    if (response != null) {
      await Printing.sharePdf(bytes: response.data, filename: 'my-document.pdf');
    }
  }
}
