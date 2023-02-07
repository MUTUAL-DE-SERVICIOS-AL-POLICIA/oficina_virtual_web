import 'package:fluro/fluro.dart';
import 'package:virtual_officine/check_auth_screen.dart';
import 'package:virtual_officine/screen/access/contacts/screen_contact.dart';
import 'package:virtual_officine/screen/access/forgot_password/forgot_pwd.dart';

import 'package:virtual_officine/screen/access/login.dart';
import 'package:virtual_officine/screen/check_auth_nav.dart';
import 'package:virtual_officine/screen/view_404.dart';

// Handlers
final checkAuthHandler = Handler(handlerFunc: (context, params) {
  return const CheckAuthScreen();
});
final loginHandler = Handler(handlerFunc: (context, params) {
  return const ScreenLogin();
});

final contactsHandler = Handler(handlerFunc: (context, params) {
  return const ScreenContact();
});

final forgotHandler = Handler(handlerFunc: (context, params) {
  return const ForgotPwd();
});

final officeHandler = Handler(handlerFunc: (context, params) {
  return const CheckAuthNav();
});

// 404
final pageNotFound = Handler(handlerFunc: (_, __) => const View404());
