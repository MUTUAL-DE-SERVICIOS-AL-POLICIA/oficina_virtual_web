import 'package:flutter/material.dart';
import 'package:virtual_officine/components/button.dart';
import 'package:virtual_officine/components/containers.dart';
import 'package:virtual_officine/model/loan_model.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:virtual_officine/screen/pages/virtual_officine/loans/card_expanded.dart';

class CardLoan extends StatefulWidget {
  final InProcess? itemProcess;
  final Color? color;
  final Current? itemCurrent;
  const CardLoan({Key? key, this.itemProcess, this.color, this.itemCurrent}) : super(key: key);

  @override
  State<CardLoan> createState() => _CardLoanState();
}

class _CardLoanState extends State<CardLoan> {
  late ValueNotifier<double> valueNotifier;
  @override
  void initState() {
    super.initState();
    if (widget.itemCurrent != null) {
      valueNotifier = ValueNotifier(widget.itemCurrent!.percentagePaid!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
          transitionOnUserGestures: true,
          tag: widget.itemProcess != null ? widget.itemProcess!.code! : widget.itemCurrent!.code!,
          child: Material(
              type: MaterialType.transparency,
              child: ContainerComponent(
                  color: widget.color ??const Color(0xfff2f2f2),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        if (widget.itemCurrent != null)
                          Expanded(
                            flex: 1,
                            child: SimpleCircularProgressBar(
                              valueNotifier: valueNotifier,
                              mergeMode: true,
                              animationDuration: 3,
                              progressColors: const [
                                Color(0xff419388),
                              ],
                              onGetText: (double value) {
                                return Text('${value.toInt()}%');
                              },
                            ),
                          ),
                          if (widget.itemCurrent != null)
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.itemProcess != null ? widget.itemProcess!.stateName! : widget.itemCurrent!.state!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(widget.itemProcess != null ? widget.itemProcess!.code! : widget.itemCurrent!.code!),
                              ButtonIconComponent(
                                text: 'DETALLES',
                                onPressed: () => onPressed(context),
                                icon: Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )))),
      onTap: () => onPressed(context),
    );
  }

  onPressed(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => CardExpanded(
            tag: widget.itemProcess != null ? widget.itemProcess!.code! : widget.itemCurrent!.code!,
            inProcess: widget.itemProcess,
            itemCurrent: widget.itemCurrent),
      ),
    );
  }
}
