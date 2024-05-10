// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final authService = BlocProvider.of<AuthBloc>(context, listen: false);
    final publicationBloc =
        BlocProvider.of<PublicationBloc>(context, listen: false);
    final roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: false);
    return BlocBuilder<NavigatorBloc, NavigatorStateInit>(
  builder: (context, state) {
    return Container(
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
      child: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.white, // Cambia el color del icono seleccionado a blanco
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent, // Fondo transparente para que se muestre el gradiente
        elevation: 0.5,
        unselectedItemColor: Colors.white54,
        currentIndex: state.index,
        onTap: (int i) async {
          BlocProvider.of<NavigatorBloc>(context)
              .add(NavigatorIndexEvent(index: i));

          mapBloc.add(OnMapMovedEvent());
          BlocProvider.of<SearchBloc>(context)
              .add(OnDeactivateManualMarkerEvent());

          if (i == 0) {
            await notificationBloc.loadNotification();
          }
          if (i == 1) {
            authService.add(const MarcarPublicacionPendienteFalse(false));
            // await publicationBloc.getAllPublicaciones();
          }

          if (i == 2) {
            authService.add(const MarcarSalasPendienteFalse());
            roomBloc.salasInitEvent();
          }

          if (i == 3) {
            navigatorBloc.add(
                const NavigatorIsPlaceSelectedEvent(isPlaceSelected: false));
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.mapLocationDot,
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, states) {
                return Stack(
                  children: [
                    const Icon(
                      FontAwesomeIcons.newspaper,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: states.usuario!.isPublicacionPendiente == true
                          ? Container(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 2,
                                bottom: 2,
                              ),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 9,
                                minHeight: 9,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                );
              },
            ),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, states) {
                return Stack(
                  children: [
                    const Icon(
                      FontAwesomeIcons.users,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: states.usuario!.isSalasPendiente == true
                          ? Container(
                              padding: const EdgeInsets.only(
                                left: 1,
                                right: 5,
                                top: 2,
                                bottom: 2,
                              ),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 9,
                                minHeight: 9,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                );
              },
            ),
            label: 'Grupos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.locationDot,
            ),
            label: 'Lugares',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.bars,
            ),
            label: 'Menú',
          ),
        ],
      ),
    );
  },
);

  }
}
