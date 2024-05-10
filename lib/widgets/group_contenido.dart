// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupContenido extends StatelessWidget {
  final String textoTitulo;
  final String textoHint;
  final String textoButton;
  final String? textoInfo;

  const GroupContenido({
    Key? key,
    required this.textoTitulo,
    required this.textoHint,
    required this.textoButton,
    this.textoInfo,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomController = TextEditingController();
    final chatProvider = BlocProvider.of<RoomBloc>(context, listen: false);
    final blocRoom = BlocProvider.of<RoomBloc>(context);
    final FocusNode focusNode = FocusNode();
    focusNode.requestFocus();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textoTitulo,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Colors.black,
            focusNode: focusNode,
            maxLength: 35,
            decoration: InputDecoration(
              hintText: textoHint,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(106, 162, 142, 1)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(106, 162, 142, 1)),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
            controller: nomController,
          ),
          if (textoInfo != null) ...[
            const SizedBox(height: 10),
            Text(
              textoInfo!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (textoButton == 'Crear Grupo') {
                  chatProvider.add(SalaCreateEvent(nomController.text));
                  focusNode.unfocus();
                  Navigator.pop(context);
                } else {
                  final res = await chatProvider.joinSala(nomController.text);
                  if (!res) {
                    blocRoom.add(CargandoEventFalse());
                    Fluttertoast.showToast(
                      msg: 'No existe el grupo ${nomController.text}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    focusNode.unfocus();
                    Fluttertoast.showToast(
                      msg: 'Te uniste al grupo ${nomController.text}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pop(context);
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(2, 79, 49, 1),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(14),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text(
                textoButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
