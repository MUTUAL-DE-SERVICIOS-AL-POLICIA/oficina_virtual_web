import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_officine/bloc/user/user_bloc.dart';
import 'package:virtual_officine/components/animate.dart';
import 'package:virtual_officine/components/section_title.dart';
import 'package:virtual_officine/components/dialog_action.dart';
import 'package:virtual_officine/services/service_method.dart';
import 'package:virtual_officine/services/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatefulWidget {
  final TabController tabController;
  const MenuDrawer({Key? key, required this.tabController}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool colorValue = false;
  bool biometricValue = false;
  bool autentificaction = false;
  String? fullPaths;
  String stateApp = '';
  bool status = true;
  bool sendNotifications = true;
  bool darkTheme = false;
  bool stateLoading = false;

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: true).state.user;
    final size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: const Color(0xfff2f2f2),
      width: MediaQuery.of(context).size.width / 1.4,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: [
              const Image(
                  image: AssetImage(
                'assets/images/muserpol-logo2.png',
              )),
              const Divider(height: 0.03),
              if (size.width > 1000)
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: TabBar(
                      controller: widget.tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          color: const Color(0xff419388)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        RotatedBox(
                          quarterTurns: 1,
                          child: Tab(
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(child: Text('Préstamos')),
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Tab(
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(child: Text('Aportes')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Mis datos',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        IconName(
                          icon: Icons.person_outline,
                          text: userBloc!.fullName!,
                        ),
                        if (userBloc.degree != null)
                          IconName(
                            icon: Icons.local_police_outlined,
                            text: 'GRADO: ${userBloc.degree!}',
                          ),
                        IconName(
                          icon: Icons.contact_page_outlined,
                          text: 'C.I.: ${userBloc.identityCard!}',
                        ),
                        if (userBloc.category != null)
                          IconName(
                            icon: Icons.av_timer,
                            text: 'CATEGORÍA: ${userBloc.category!}',
                          ),
                        if (userBloc.pensionEntity != null)
                          IconName(
                            icon: Icons.account_balance,
                            text: 'GESTORA: ${userBloc.pensionEntity!}',
                          ),
                      ],
                    ),
                    const Divider(height: 0.03),
                    const Text(
                      'Configuración general',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SectiontitleComponent(
                        title: 'Contactos a nivel nacional',
                        icon: Icons.contact_phone_rounded,
                        onTap: () => Navigator.pushNamed(context, '/contacts')),
                    SectiontitleComponent(
                      title: 'Políticas de Privacidad',
                      icon: Icons.privacy_tip,
                      stateLoading: stateLoading,
                      onTap: () => launchUrl(Uri.parse(serviceGetPrivacyPolicy()), mode: LaunchMode.externalApplication),
                    ),
                    SectiontitleComponent(title: 'Cerrar Sesión', icon: Icons.info_outline, onTap: () => closeSession(context)),
                  ],
                )),
              )
            ],
          )),
    );
  }

  closeSession(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ComponentAnimate(
              child: DialogTwoAction(
                  message: '¿Estás seguro que quieres cerrar sesión?',
                  actionCorrect: () => confirmDeleteSession(mounted, context, true),
                  messageCorrect: 'Salir'));
        });
  }
}

class IconName extends StatelessWidget {
  final IconData icon;
  final String text;
  const IconName({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [Icon(icon), Flexible(child: Text(text))],
      ),
    );
  }
}
