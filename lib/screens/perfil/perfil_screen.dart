// ignore_for_file: use_build_context_synchronously, use_super_parameters, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:provider/provider.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  void toggleTheme() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class PerfilScreen extends StatelessWidget {
  static const String salesroute = 'perfil';

  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(106, 162, 142, 1),
            Color.fromRGBO(2, 79, 49, 1),
          ],
        ),
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(30),
        //   bottomRight: Radius.circular(30),
        // ),
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Cambiado a MainAxisAlignment.center
        children: [
          Text(
            'Menú',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSection('Perfil', [
            const _ListIconName(
              icon: Icons.person_2_rounded,
              name: 'Mi perfil',
              route: 'perfilDetalle',
            ),
            const _ListIconName(
              icon: Icons.house_sharp,
              name: 'Mis Direcciones',
              route: 'lugares',
            ),
            const _ListIconName(
              icon: Icons.quick_contacts_dialer_rounded,
              name: "Mis contactos",
              route: "information_familyauth",
            ),
            const _ListIconName(
              icon: Icons.group_add_rounded,
              name: "Mis Grupos",
              route: "salas",
            ),
          ]),
          const SizedBox(height: 10),
          _buildSection('Ajustes', [
            //_buildThemeSwitcher(context), // Cambio de tema (Claro - Oscuro)
            const _ListIconName(
              icon: Icons.logout,
              name: 'Cerrar sesión',
              route: 'login',
              isLogout: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true, // Para que el ListView se ajuste a su contenido
        physics: const NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento del ListView
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 75, 71, 71).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          onTap: () => notifier.toggleTheme(),
          leading: Icon(
            notifier.mode == ThemeMode.dark
                ? Icons.nightlight_round
                : Icons.wb_sunny,
            color: notifier.mode == ThemeMode.dark
                ? const Color.fromARGB(255, 75, 71, 71)
                : Colors.amber,
          ),
          title: const Text(
            'Tema',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          trailing: Switch(
            value: notifier.mode == ThemeMode.light,
            onChanged: (value) {
              notifier.toggleTheme();
            },
          ),
        ),
      ),
    );
  }
}

class _ListIconName extends StatelessWidget {
  const _ListIconName({
    required this.icon,
    required this.name,
    required this.route,
    this.isLogout = false,
  });

  final IconData icon;
  final String name;
  final String route;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 75, 71, 71).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _handleTap(context),
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.grey[800],
          size: 30,
        ),
        title: Text(
          name,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) async {
    if (isLogout) {
      final authServiceBloc = BlocProvider.of<AuthBloc>(context);
      await authServiceBloc.logout();
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      Navigator.pushNamed(context, route, arguments: true);
    }
  }
}
