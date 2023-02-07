import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as urlauncher;
import 'package:virtual_officine/components/containers.dart';
import 'package:virtual_officine/components/table_row.dart';
import 'package:virtual_officine/model/contacts_model.dart';

class CardContact extends StatefulWidget {
  final City city;
  const CardContact({Key? key, required this.city}) : super(key: key);

  @override
  State<CardContact> createState() => _CardContactState();
}

class _CardContactState extends State<CardContact> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: ContainerComponent(
            color: const Color(0xfff2f2f2),
            child: Row(children: [
              Expanded(
                  child: Column(
                children: [
                  Text(widget.city.name!),
                  const SizedBox(height: 20),
                  Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3.5),
                        1: FlexColumnWidth(0.5),
                        2: FlexColumnWidth(6),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        tableInfo(
                            'Dirección:',
                            GestureDetector(
                              onTap: () {
                                urlauncher.launchUrl(
                                  Uri(
                                    scheme: 'https',
                                    host: 'www.google.com',
                                    path: 'maps/search/',
                                    queryParameters: {"api": '1', "query": "${widget.city.latitude!},${widget.city.longitude!}"},
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on),
                                  Flexible(
                                      child: Text(
                                    widget.city.companyAddress!,
                                    style: const TextStyle(color: Color(0xff439CAB)),
                                  ))
                                ],
                              ),
                            )),
                        if (json.decode(json.decode(widget.city.companyPhones!)).length > 0)
                          tableInfo(
                              'Teléfonos:',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var item in json.decode(json.decode(widget.city.companyPhones!)))
                                    GestureDetector(
                                      onTap: () => urlauncher.launchUrl(Uri(scheme: 'tel', path: '$item')),
                                      child: Text('$item', style: const TextStyle(color: Color(0xff439CAB))),
                                    )
                                ],
                              )),
                        if (json.decode(json.decode(widget.city.companyCellphones!)).length > 0)
                          tableInfo(
                              'Celulares:',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var item in json.decode(json.decode(widget.city.companyCellphones!)))
                                    GestureDetector(
                                      onTap: () => urlauncher.launchUrl(Uri(scheme: 'tel', path: '$item')),
                                      child: Text('$item', style: const TextStyle(color: Color(0xff439CAB))),
                                    )
                                ],
                              )),
                      ])
                ],
              ))
            ])));
  }
}
