// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserMembers extends StatefulWidget {
  final String uid;

  const UserMembers({super.key, required this.uid});

  @override
  State<UserMembers> createState() => _UserMembersState();
}

class _UserMembersState extends State<UserMembers> {
  late MembersBloc membersBloc;
  late RoomBloc roomBloc;
  late AuthBloc authBloc;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    membersBloc = BlocProvider.of<MembersBloc>(context, listen: false);
    roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
    authBloc = BlocProvider.of<AuthBloc>(context);
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6165FA),
            ),
          );
        }
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _loadUsers,
          child: _buildUserListView(state.usuariosAll),
        );
      },
    );
  }

  ListView _buildUserListView(List<Usuario> usuarios) {
    return ListView.separated(
      itemCount: usuarios.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final usuario = usuarios[index];
        return ListTile(
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  leading: Stack(
    children: [
      CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: usuario.google
            ? NetworkImage(usuario.img!)
            : usuario.img == null
                ? const AssetImage('assets/no-image.png') as ImageProvider
                : NetworkImage(
                    '${Environment.apiUrl}/uploads/usuario/usuarios/${usuario.uid}'),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: usuario.online ? Colors.green : Colors.green,
          ),
          child: const Icon(
            Icons.circle,
            color: Colors.white,
            size: 12,
          ),
        ),
      ),
    ],
  ),
  title: Text(
    usuario.nombre,
    style: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
  subtitle: Text(
    usuario.email,
    style: const TextStyle(
      color: Colors.black54,
      fontSize: 14,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
  trailing: roomBloc.state.salaSeleccionada.propietario == usuario.uid
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(179, 5, 71, 45),
          ),
          child: const Text(
            'Admin. del grupo',
            style: TextStyle(
              color: Color.fromARGB(221, 255, 255, 255),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      : null,
  onTap: () {
    if (roomBloc.state.salaSeleccionada.propietario ==
            authBloc.state.usuario!.uid &&
        usuario.uid != authBloc.state.usuario!.uid) {
      _showDeleteDialog(usuario);
    }
  },
);

      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  Future<void> _loadUsers() async {
    await membersBloc.cargarUsuariosSala(widget.uid);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _showDeleteDialog(Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text('Eliminar miembro'),
            content: Text(
              '¿Está seguro que desea eliminar a ${usuario.nombre} del grupo?',
              style: const TextStyle(color: Colors.black87),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF6165FA)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  membersBloc.add(DeleteMemberByIdEvent(
                      roomBloc.state.salaSeleccionada.uid, usuario.uid));
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Eliminar miembro'),
            content: Text(
              '¿Está seguro que desea eliminar a ${usuario.nombre} del grupo?',
              style: const TextStyle(color: Colors.black87),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF6165FA)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  membersBloc.add(DeleteMemberByIdEvent(
                      roomBloc.state.salaSeleccionada.uid, usuario.uid));
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
