import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/models/search_result.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/screens/place_details_screen.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green.shade900, // Color de fondo de la barra de búsqueda
        elevation: 0, // Sin sombra
        iconTheme: const IconThemeData(color: Colors.white), toolbarTextStyle: theme.textTheme.copyWith(
          titleLarge: const TextStyle(
            color: Colors.white, // Color del texto de búsqueda
            fontSize: 20, // Tamaño del texto de búsqueda
          ),
        ).bodyMedium, titleTextStyle: theme.textTheme.copyWith(
          titleLarge: const TextStyle(
            color: Colors.white, // Color del texto de búsqueda
            fontSize: 20, // Tamaño del texto de búsqueda
          ),
        ).titleLarge,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70), // Color del texto de sugerencia
        border: InputBorder.none, // Sin borde
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.green[900],
          radius: 20.0,
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              query = '';
            },
            color: Colors.white,
            iconSize: 24.0,
            splashRadius: 20.0,
            tooltip: 'Limpiar búsqueda',
          ),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.green[900],
        radius: 20.0,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            final result = SearchResult(cancel: true);
            close(context, result);
          },
          color: Colors.white,
          iconSize: 24.0,
          splashRadius: 20.0,
          tooltip: 'Atrás',
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    if (query.isEmpty) {
      return _buildNoResultsWidget();
    }

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.ubicacion;

        if (places.isEmpty) {
          return _buildNoResultsWidget();
        }

        return ListView.separated(
          itemBuilder: (_, i) {
            final place = places[i];
            return _buildPlaceItem(context, searchBloc, place);
          },
          separatorBuilder: (_, i) => const Divider(),
          itemCount: places.length,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    if (query.isEmpty) {
      return Container();
    }

    searchBloc.getSuggestionsByQuery(query);

    return StreamBuilder<List<Ubicacion>>(
      stream: searchBloc.listUbicacionStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoResultsWidget();
        }

        final places = snapshot.data!;

        return ListView.separated(
          itemBuilder: (_, i) {
            final place = places[i];
            return _buildPlaceItem(context, searchBloc, place);
          },
          separatorBuilder: (_, i) => const Divider(),
          itemCount: places.length,
        );
      },
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Text(
        'No hay resultados',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildPlaceItem(
      BuildContext context, SearchBloc searchBloc, Ubicacion place) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.place, color: Colors.white),
      ),
      title: Text(
        place.barrio,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        '${place.ciudad}, ${place.referencia ?? ''} ${place.pais}',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      onTap: () => _handlePlaceTap(context, searchBloc, place),
    );
  }

  void _handlePlaceTap(
      BuildContext context, SearchBloc searchBloc, Ubicacion place) {
    searchBloc.add(AddToHistoryEvent(place));
    final result = SearchResult(cancel: false, manual: true);
    close(context, result);
    Navigator.pushNamed(context, PlaceDetailScreen.place,
        arguments: {'ubicacion': place, 'isDelete': false});
  }
}
