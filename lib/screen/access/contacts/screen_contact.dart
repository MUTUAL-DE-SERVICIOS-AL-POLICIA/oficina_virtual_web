import 'package:flutter/material.dart';
import 'package:virtual_officine/components/headers.dart';
import 'package:virtual_officine/model/contacts_model.dart';
import 'package:virtual_officine/screen/access/contacts/card_contact.dart';
import 'package:virtual_officine/services/service_method.dart';
import 'package:virtual_officine/services/services.dart';

class ScreenContact extends StatefulWidget {
  const ScreenContact({Key? key}) : super(key: key);

  @override
  State<ScreenContact> createState() => _ScreenContactState();
}

class _ScreenContactState extends State<ScreenContact> {
  ContactsModel? contact;
  @override
  void initState() {
    super.initState();
    getContacts();
  }

  getContacts() async {
    final response = await serviceMethod(mounted, context, 'get', null, serviceGetContacts(), false, false);
    if (response != null) {
      setState(() => contact = contactsModelFromJson(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(children: [
              const HedersComponent(title: 'Contactos a nivel nacional'),
              contact != null
                  ? Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: [
                      for (var item in contact!.data!.cities!)
                        CardContact(
                          city: item,
                        ),
                    ])))
                  : Expanded(child: Center(child: Image.asset('assets/images/load.gif', fit: BoxFit.cover, height: 20))),
            ])));
  }
}
