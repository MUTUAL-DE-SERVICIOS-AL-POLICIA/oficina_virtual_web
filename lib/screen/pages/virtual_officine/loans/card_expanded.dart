import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:virtual_officine/components/button.dart';
import 'package:virtual_officine/components/containers.dart';
import 'package:virtual_officine/components/headers.dart';
import 'package:virtual_officine/components/table_row.dart';
import 'package:virtual_officine/model/loan_model.dart';
import 'package:virtual_officine/services/service_dio.dart';
import 'package:virtual_officine/services/services.dart';

class CardExpanded extends StatefulWidget {
  final String tag;
  final InProcess? inProcess;
  final Current? itemCurrent;
  const CardExpanded({Key? key, required this.tag, this.inProcess, this.itemCurrent}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  bool stateLoading = false;
  StepperType stepperType = StepperType.vertical;
  
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
                tag: widget.tag,
                child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContainerComponent(
                        height: size.height / 1.2,
                        width: (size.width > 800) ?  size.width/2.5: size.width,
                        color: const Color(0xfff2f2f2),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: HedersComponent(title: widget.inProcess != null ? widget.inProcess!.code! : widget.itemCurrent!.code!),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(4),
                                            1: FlexColumnWidth(0.3),
                                            2: FlexColumnWidth(6),
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
                                            if (widget.inProcess != null) tableInfo('Tipo de trámite', Text(widget.inProcess!.procedureTypeName!)),
                                            if (widget.inProcess != null) tableInfo('Modalidad', Text(widget.inProcess!.procedureModalityName!)),
                                            if (widget.itemCurrent != null) tableInfo('Modalidad', Text(widget.itemCurrent!.procedureModality!)),
                                            if (widget.itemCurrent != null) tableInfo('Monto', Text('${widget.itemCurrent!.amountRequested!} Bs.')),
                                            if (widget.itemCurrent != null)
                                              tableInfo('Porcentaje de Interés', Text('${widget.itemCurrent!.interest} %')),
                                            if (widget.itemCurrent != null) tableInfo('Plazos', Text('${widget.itemCurrent!.loanTerm} meses')),
                                            if (widget.itemCurrent != null) tableInfo('Tipo de pago', Text(widget.itemCurrent!.paymentType!)),
                                            if (widget.itemCurrent != null) tableInfo('Destino', Text(widget.itemCurrent!.destinyId!)),
                                            if (widget.itemCurrent != null)
                                              tableInfo(
                                                  'Apertura', Text(DateFormat(' dd, MMMM yyyy ', "es_ES").format(widget.itemCurrent!.requestDate!))),
                                          ]),
                                      if (widget.itemCurrent != null)
                                        !stateLoading
                                            ? Row(
                                                children: [
                                                  Flexible(
                                                    child: ButtonIconComponent(
                                                      text: 'Plan de pagos',
                                                      onPressed: () => getLoanPlan(context, widget.itemCurrent!.id!),
                                                      icon: Container(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: ButtonIconComponent(
                                                      text: 'Kardex',
                                                      onPressed: () => getLoanKardex(context, widget.itemCurrent!.id!),
                                                      icon: Container(),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Center(
                                                child: Image.asset(
                                                  'assets/images/load.gif',
                                                  fit: BoxFit.cover,
                                                  height: 15,
                                                ),
                                              ),
                                      if (widget.inProcess != null)
                                        Column(
                                          crossAxisAlignment : CrossAxisAlignment.start,
                                          children: const[
                                            Divider(height: 0.03, color: Colors.white),
                                            Text('Ubicación del trámite:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      if (widget.inProcess != null)
                                        Center(
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: List.generate(widget.inProcess!.flow!.length, (index) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Spacer(),
                                                        Expanded(
                                                            flex: 1,
                                                            child: NumberComponent(
                                                                text: '${index + 1}',
                                                                iconColor: widget.inProcess!.flow![index].state! ? true : false)),
                                                        Expanded(flex: 2, child: Text(widget.inProcess!.flow![index].displayName!)),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                    if (index != widget.inProcess!.flow!.length - 1)
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          const Expanded(flex: 1, child: Center(child: Text('|'))),
                                                          Expanded(flex: 2, child: Container()),
                                                          const Spacer(),
                                                        ],
                                                      ),
                                                  ],
                                                );
                                              })),
                                        )
                                    ])),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  getLoanPlan(BuildContext context, int loanId) async {
    setState(() => stateLoading = true);
    var response = await serviceMethoDio(context, 'get', null, servicePrintLoans(loanId),true);
    // var response = await serviceMethod(mounted, context, 'get', null, servicePrintLoans(loanId), true, true);
    setState(() => stateLoading = false);
    if (response != null) {
      await Printing.sharePdf(bytes: response.data, filename: 'my-document.pdf');
    }
  }

  getLoanKardex(BuildContext context, int loanId) async {
    setState(() => stateLoading = true);
    var response = await serviceMethoDio(context, 'get', null, servicePrintKadex(loanId),true);
    // var response = await serviceMethod(mounted, context, 'get', null, servicePrintKadex(loanId), true, true);
    setState(() => stateLoading = false);
    if (response != null) {
      await Printing.sharePdf(bytes: response.data, filename: 'my-document.pdf');
    }
  }
}
