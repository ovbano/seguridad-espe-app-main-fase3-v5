// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/group_contenido.dart';

class CodigoAddGrupoScreen extends StatelessWidget {
  static const String codigoAddGruporoute = 'codigoGrupoAdd';

  final TextEditingController nomController = TextEditingController();

  CodigoAddGrupoScreen({Key? key});

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
              // ignore: prefer_const_constructors
              title: Row(
                children: const [
                  Icon(Icons.group, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Únete a un grupo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: const GroupContenido(
                    textoHint: '000-000',
                    textoButton: 'Únete a un grupo',
                    textoTitulo: 'Código',
                    textoInfo:
                        'Ingresa el código del grupo que te compartieron para unirte al grupo que fuiste invitado.',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
