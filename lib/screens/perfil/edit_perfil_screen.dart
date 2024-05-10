// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/screens/perfil/edit_nombre.dart';
import 'package:flutter_maps_adv/screens/perfil/edit_telefono.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPerfilScreen extends StatefulWidget {
  static const String editPerfilroute = 'editPerfil';
  const EditPerfilScreen({Key? key});

  @override
  State<EditPerfilScreen> createState() => _EditPerfilScreenState();
}

class _EditPerfilScreenState extends State<EditPerfilScreen> {
  final picker = ImagePicker();
  File? _imageFile;
  AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
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
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: false,
                  title: const Padding(
                    padding: EdgeInsets.only(
                        left:
                            32.0), // Aumentar el espacio entre el texto y el ícono
                    child: Text(
                      'Editar Perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileImage(state),
                      const SizedBox(height: 20),
                      _buildProfileItem(
                        context,
                        'Nombres',
                        state.usuario!.nombre,
                        const EditNombreScreen(),
                      ),
                      const SizedBox(height: 10),
                      _buildProfileItem(
                        context,
                        'Correo',
                        state.usuario!.email,
                        null,
                      ),
                      const SizedBox(height: 10),
                      _buildProfileItem(
                        context,
                        'Teléfono',
                        state.usuario!.telefono!,
                        const EditTelefonoScreen(),
                      ),
                      const SizedBox(height: 10),
                      _buildProfileItem(
                        context,
                        'Direcciones',
                        'Agregar una nueva dirección',
                        const PlacesScreen(),
                      ),
                      const SizedBox(height: 10),
                      _buildPrivacyMessage(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(AuthState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          if (!state.usuario!.google) {
            _seleccionarFoto();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _getImageProvider(state),
              ),
            ),
            if (!state.usuario!.google)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    String title,
    String subtitle,
    Widget? destinationScreen,
  ) {
    IconData icon;
    Color iconColor = Colors.green.shade800; // Nuevo color para los iconos
    switch (title) {
      case 'Nombres':
        icon = Icons.person;
        break;
      case 'Correo':
        icon = Icons.email;
        break;
      case 'Teléfono':
        icon = Icons.phone;
        break;
      case 'Direcciones':
        icon = Icons.location_on;
        break;
      default:
        icon = Icons.info; // Icono por defecto
    }

    return GestureDetector(
      onTap: destinationScreen != null
          ? () {
              Navigator.of(context).push(_createRoute(destinationScreen));
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: iconColor, // Nuevo color para los iconos
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            if (destinationScreen != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyMessage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            color: Colors.grey.shade600,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Esta información es privada y no será compartida con nadie.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              //letterSpacing: 1.2, // eEspaciado de las letras
            ),
          ),
        ],
      ),
    );
  }

  void _seleccionarFoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  ImageProvider _getImageProvider(AuthState state) {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (state.usuario!.google == true) {
      return NetworkImage(state.usuario!.img!);
    } else if (state.usuario!.img != null) {
      return NetworkImage(
          '${Environment.apiUrl}/uploads/usuario/usuarios/${state.usuario!.uid}');
    } else {
      return const AssetImage('assets/no-image.png');
    }
  }
}

Route _createRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
