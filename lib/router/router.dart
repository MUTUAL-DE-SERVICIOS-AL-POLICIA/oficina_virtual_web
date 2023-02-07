import 'package:fluro/fluro.dart';
import 'package:virtual_officine/router/route_handlers.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static void configureRoutes() {
    router.define('/', handler: checkAuthHandler, transitionType: TransitionType.fadeIn);
    router.define('/auth', handler: loginHandler, transitionType: TransitionType.fadeIn);
    router.define('/contacts', handler: contactsHandler, transitionType: TransitionType.fadeIn);
    router.define('/forgot', handler: forgotHandler, transitionType: TransitionType.fadeIn);
    router.define('/office', handler: officeHandler, transitionType: TransitionType.fadeIn);
    // 404 - Not Page Found
    router.notFoundHandler = pageNotFound;
  }
}
