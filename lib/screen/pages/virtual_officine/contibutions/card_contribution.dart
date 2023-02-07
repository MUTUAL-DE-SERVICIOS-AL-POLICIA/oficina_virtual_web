import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virtual_officine/components/containers.dart';
import 'package:virtual_officine/model/contribution_model.dart';
import 'package:virtual_officine/screen/pages/virtual_officine/contibutions/card_expanded.dart';

class ContributionsYear extends StatelessWidget {
  final TabController tabController;
  final String year;
  final List<Contribution> contributions;
  const ContributionsYear({
    Key? key,
    required this.year,
    required this.contributions,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return contributions.isNotEmpty
        ? GridView.count(
            crossAxisCount: ( size.width > 1000 )?6:3,
            children: List.generate(contributions.length, (index) {
              return Hero(
                  tag: 'flipcardHero$index',
                  child: Material(
                      type: MaterialType.transparency, // likely needed
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: card(
                            contributions[index].reimbursementTotal != '0,00' && contributions[index].reimbursementTotal != null
                                ? const Color(0xffE0A44C)
                                : const Color(0xfff2f2f2),
                            context,
                            contributions[index],
                            'flipcardHero$index'),
                      )));
            }),
          )
        : const Center(
            child: Text('Gestión sin aportes'),
          );
  }

  Widget card(Color colorRefund, BuildContext context, Contribution key, String hero) {
    return MaterialButton(
      textColor:Colors.black, 
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => CardExpanded(index: hero, contribution: key, colorRefund: colorRefund),
            ),
          );
        },
        child: ContainerComponent(
            color: colorRefund,
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${key.state}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  DateFormat('MMMM', "es_ES").format(key.monthYear!).toUpperCase(),
                  style: const TextStyle(fontSize: 15),
                ),
                Text('${key.total} Bs.'),
              ],
            )))));
  }
}
