import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virtual_officine/components/containers.dart';
import 'package:virtual_officine/components/headers.dart';
import 'package:virtual_officine/components/table_row.dart';
import 'package:virtual_officine/model/contribution_model.dart';
class CardExpanded extends StatefulWidget {
  final String index;
  final Contribution contribution;
  final Color colorRefund;
  const CardExpanded({Key? key, required this.colorRefund, required this.index, required this.contribution}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.5),
        body: GestureDetector(
          child: Center(
            child: Hero(
                tag: widget.index,
                child: Material(
                  type: MaterialType.transparency,
                  child: GestureDetector(
                    onTap: () {},
                    child: ContainerComponent(
                        height: (widget.contribution.state == 'ACTIVO') ? size.height / 1.5 : size.height / 3,
                        width:  (size.width > 800) ? size.width /4 : size.width/1.1,
                        color: const Color(0xfff2f2f2),
                        child: Column(
                            children: [
                              HedersComponent(
                                titleHeader: widget.contribution.state,
                                title: DateFormat(' dd, MMMM yyyy ', "es_ES").format(widget.contribution.monthYear!)
                              ),
                              Expanded(
                                  child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(5),
                                            1: FlexColumnWidth(0.3),
                                            2: FlexColumnWidth(5),
                                          },
                                          border: const TableBorder(
                                            horizontalInside: BorderSide(
                                              width: 0.5,
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          children: [
                                            tableInfo('Cotizable', Text(widget.contribution.quotable!)),
                                            if (widget.contribution.state == 'ACTIVO')
                                              tableInfo('Fondo de retiro', Text(widget.contribution.retirementFund!)),
                                            if (widget.contribution.state == 'ACTIVO')
                                              tableInfo('Cuota mortuoria', Text(widget.contribution.mortuaryQuota!)),
                                            if (widget.contribution.state == 'ACTIVO')
                                              tableInfo('Aporte', Text(widget.contribution.contributionTotal!)),
                                            if (widget.contribution.state == 'ACTIVO')
                                              tableInfo('Reintegro', Text('${widget.contribution.reimbursementTotal!} Bs')),
                                            tableInfo(widget.contribution.state == 'ACTIVO' ? 'Total Aporte con Reintegro' : 'Total Aporte',
                                                Text('${widget.contribution.total!} Bs')),
                                          ])
                                    ],
                                  ),
                                ),
                              ))
                            ],
                        )),
                  ),
                )),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
