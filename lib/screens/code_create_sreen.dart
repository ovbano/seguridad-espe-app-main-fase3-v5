// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/group_contenido.dart';

class CodigoCreateGrupoScreen extends StatelessWidget {
  static const String codigoGruporoute = 'codigoGrupo';

  const CodigoCreateGrupoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(106, 162, 142, 1),
                  Color.fromRGBO(2, 79, 49, 1),
                ],
              ),
            ),
            child: AppBar(
              centerTitle: false,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Row(
                children: [
                  Icon(Icons.group, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Crear Grupo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
              color: Colors.white,
              child: const GroupContenido(
                textoHint: 'Nombre del grupo',
                textoButton: 'Crear Grupo',
                textoTitulo: 'Nombre',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
