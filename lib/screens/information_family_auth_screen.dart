import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationFamilyAuth extends StatefulWidget {
  static const String informationFamilyAuth = 'information_familyauth';
  const InformationFamilyAuth({super.key});

  @override
  State<InformationFamilyAuth> createState() => _InformationFamilyAuthState();
}

class _InformationFamilyAuthState extends State<InformationFamilyAuth> {
  final TextEditingController telefonoController =
      TextEditingController(text: '09');
  bool areFieldsEmpty = true;
  // bool routeActive = false;
  List<String> telefonos = [];
  AuthBloc authBloc = AuthBloc();
  late SvgPicture image1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
  super.initState();
  authBloc = BlocProvider.of<AuthBloc>(context);
  telefonos = authBloc.state.usuario?.telefonos ?? [];
  telefonoController.addListener(updateFieldsState);

  image1 = SvgPicture.asset(
    "assets/info/numberfamily.svg",
    width: 75, // Ajusta el ancho según tus necesidades
    height: 75, // Ajusta la altura según tus necesidades
    fit: BoxFit.contain, // Esto puede cambiar dependiendo de tus necesidades
  );
}


  @override
  void dispose() {
    telefonoController.removeListener(updateFieldsState);
    telefonoController.dispose();
    super.dispose();
  }

  void updateFieldsState() {
    setState(() {
      areFieldsEmpty = telefonoController.text.trim().isEmpty ||
          !isValidPhoneNumber(telefonoController.text.trim());
    });
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^09\d{8}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final authService = BlocProvider.of<AuthBloc>(
      context,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    'Mis contactos de emergencia',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          controller: _scrollController,
                          shrinkWrap: true,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: image1,
                              ),
                            ),
                            const Text(
                              "Agrega los números de teléfono de tus contactos en caso de emergencia, para que puedan recibir alertas de tus seres queridos. Solo los números que hayas añadido serán notificados una vez que presiones el botón de SOS.",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 0, 0, 0.782),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _TextFieldAddTelefono(
                              telefonoController: telefonoController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 38,
                              child: ElevatedButton(
                                onPressed: areFieldsEmpty
                                    ? null
                                    : () {
                                        if (authService.state.usuario?.telefonos
                                                .contains(telefonoController
                                                    .text
                                                    .trim()) ??
                                            false) {
                                          mostrarAlerta(
                                            context,
                                            'Número ya registrado',
                                            'El número que estás intentando ingresar ya se encuentra registrado.',
                                          );
                                          return;
                                        }

                                        if (authService
                                                .state.usuario?.telefono ==
                                            telefonoController.text.trim()) {
                                          mostrarAlerta(
                                            context,
                                            'Número ya registrado',
                                            'No puedes agregar tu propio número de teléfono.',
                                          );
                                          return;
                                        }

                                        authService.addTelefonoFamily(
                                            telefonoController.text.trim());
                                        telefonoController.clear();
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6165FA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text('Agregar número'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _ListContact(
                              authService: authService,
                              telefonos: telefonos,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void mostrarAlerta(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6165FA), // Un color atractivo
            ),
          ),
          content: Text(
            mensaje,
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cerrar',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(
                      0xFF6165FA), // Mismo color que el título para coherencia
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _TextFieldAddTelefono extends StatelessWidget {
  const _TextFieldAddTelefono({
    required this.telefonoController,
  });

  final TextEditingController telefonoController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(
                "assets/ecuador.jpg",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text(
                  'EC +593',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.782),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: telefonoController,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              labelStyle: TextStyle(
                color: Color.fromRGBO(106, 162, 142, 1), // Color del texto del label
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(106, 162, 142, 1), // Color de la línea de abajo del TextField
                ),
              ),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class _ListContact extends StatelessWidget {
  _ListContact({
    required this.authService,
    required this.telefonos,
  });

  List<String> telefonos;
  final AuthBloc authService;

  @override
  Widget build(BuildContext context) {
    final state = authService.state;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.usuario?.telefonos.length ?? 0,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromRGBO(106, 162, 142, 1),
            ),
            title: Text(
              state.usuario?.telefonos[index] ?? '',
              style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.782),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                _showDeleteConfirmationDialog(
                    context, state.usuario?.telefonos[index] ?? '');
              },
              icon: const Icon(
                Icons.delete,
                color: Color.fromRGBO(0, 0, 0, 0.782),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String telefono) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Eliminación',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este número de teléfono?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo sin eliminar
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                authService.deleteTelefonoFamily(telefono);
                Navigator.pop(context); // Cerrar el diálogo después de eliminar
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6165FA),
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
