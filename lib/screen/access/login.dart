import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_officine/bloc/user/user_bloc.dart';
import 'package:virtual_officine/components/button.dart';
import 'package:virtual_officine/components/inputs/identity_card.dart';
import 'package:virtual_officine/components/inputs/password.dart';
import 'package:virtual_officine/components/susessful.dart';
import 'package:virtual_officine/main.dart';
import 'package:virtual_officine/model/user_model.dart';
import 'package:virtual_officine/screen/access/model_update_pwd.dart';
import 'package:virtual_officine/services/service_method.dart';
import 'package:virtual_officine/services/services.dart';


class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController dniCtrl = TextEditingController();
  TextEditingController dniComCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  bool btnAccess = true;
  String dateCtrl = '';
  DateTime? dateTime;
  String? dateCtrlText;
  bool dateState = false;
  DateTime currentDate = DateTime(1950, 1, 1);
  FocusNode textSecondFocusNode = FocusNode();

  Map<String, dynamic> body = {};
String? deviceId;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String? statusDeviceId;
    try {
      statusDeviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      statusDeviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;
    setState(() => deviceId = statusDeviceId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: (size.width > 1000)
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [logo(), credentials()])
                : Column(
                    children: [logo(), credentials()],
                  )));
  }

  Future<bool> _onBackPressed() async {
    return false;
  }

  Widget logo() {
    final size = MediaQuery.of(context).size;
    return Expanded(
        flex: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (size.width > 1000) ? 80 : 20),
          child: const Center(
            child: Image(
              image: AssetImage(
                'assets/images/muserpol-logo2.png',
              ),
            ),
          ),
        ));
  }

  Widget credentials() {
    final node = FocusScope.of(context);
    final size = MediaQuery.of(context).size;
    return Expanded(
        flex: (size.width > 1000) ? 1 : 3,
        child: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: (size.width > 1000) ? 80 : 20),
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      const Text(
                        'OFICINA VIRTUAL',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (btnAccess)
                        Column(
                          children: [
                            IdentityCard(
                              title: 'Usuario:',
                              dniCtrl: dniCtrl,
                              dniComCtrl: dniComCtrl,
                              onEditingComplete: () => node.nextFocus(),
                              textSecondFocusNode: textSecondFocusNode,
                              formatter: FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z-]")),
                              keyboardType: TextInputType.text,
                              stateAlphanumericFalse: () => setState(() => dniComCtrl.text = ''),
                              stateAlphanumeric: false,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Password(passwordCtrl: passwordCtrl, onEditingComplete: () => initSession()),
                            const SizedBox(
                              height: 10,
                            ),
                            ButtonComponent(text: 'INGRESAR', onPressed: () => initSession()),
                            ButtonWhiteComponent(
                                text: 'Olvidé mi contraseña', onPressed: () => Navigator.pushNamed(context, '/forgot')),
                            ButtonWhiteComponent(
                                text: 'Contactos a nivel nacional',
                                onPressed: () => Navigator.pushNamed(context, '/contacts')),
                            ButtonWhiteComponent(
                              text: 'Política de privacidad',
                              onPressed: () =>
                                  launchUrl(Uri.parse(serviceGetPrivacyPolicy()), mode: LaunchMode.externalApplication),
                            )
                          ],
                        ),
                      if (!btnAccess)
                        Center(
                            child: Image.asset(
                          'assets/images/load.gif',
                          fit: BoxFit.cover,
                          height: 20,
                        )),
                    ])))));
  }

  initSession() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      // if (dateCtrlText == null && !widget.stateOfficeVirtual) return;
      setState(() => btnAccess = false);
      body['device_id'] = deviceId;
      body['firebase_token'] = '123';
      body['username'] = '${dniCtrl.text.trim()}${dniComCtrl.text == '' ? '' : '-${dniComCtrl.text.trim()}'}';
      body['password'] = passwordCtrl.text.trim();
      if (!mounted) return;
      var response = await serviceMethod(mounted, context, 'post', body, serviceAuthSessionOF(), false, true);
      setState(() => btnAccess = true);
      debugPrint('response $response');
      if (response != null) {
        debugPrint('save user1');
        if (json.decode(response.body)['data']['status'] != null &&
            json.decode(response.body)['data']['status'] == 'Pendiente') {
          return virtualOfficineUpdatePwd(json.decode(response.body)['message']);
        }
        debugPrint('save user2');
        UserModel user = userModelFromJson(json.encode(json.decode(response.body)['data']));
        debugPrint('save user3');
        if (!mounted) return;
        debugPrint('save user4');
        prefs!.setString('user', userModelToJson(user));
        debugPrint('save user5');
        userBloc.add(UpdateUser(user.user!));
        debugPrint('save user6');
        initSessionVirtualOfficine(response, user);
      } else {
        debugPrint('elseee');
      }
    }
  }

  initSessionVirtualOfficine(dynamic response, UserModel user) async {
    debugPrint('init session');
    prefs!.setInt('affiliateId', json.decode(response.body)['data']['user']['id']);
    if (!mounted) return;
    prefs!.setString('token', user.apiToken!);
    if (!mounted) return;
    return Navigator.pushNamed(context, '/office');
  }

  virtualOfficineUpdatePwd(String message) {
    return showBarModalBottomSheet(
      expand: false,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) => ModalUpdatePwd(
          message: message,
          stateLoading: btnAccess,
          onPressed: (password) async {
            setState(() => btnAccess = false);
            body['new_password'] = password;
            var response = await serviceMethod(mounted, context, 'patch', body, serviceChangePasswordOF(), false, true);
            setState(() => btnAccess = true);
            if (response != null) {
              if (!mounted) return;
              return showSuccessful(context, json.decode(response.body)['message'], () {
                debugPrint('res ${response.body}');
                setState(() => passwordCtrl.text = '');
                Navigator.of(context).pop();
              });
            }
          }),
    );
  }
}
