import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/home/table_alertas_comunidad.dart';
import 'package:flutter_maps_adv/widgets/home/table_alertas_seguridad.dart';

class AlertsScreen extends StatelessWidget {
  static const String routeName = 'alertas';
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Reportar", style: TextStyle(color: Colors.white)),
          //color de la flcha de regreso blanco
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("SEGURIDAD", style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text("COMUNIDAD", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(2, 79, 49, 1),
          child: const TabBarView(
            //color de fondo de la pantalla

            children: [
              TableAlertsSeguridad(),
              TableAlertsCompunidad(),
            ],
          ),
        ),
      ),
    );
  }
}
