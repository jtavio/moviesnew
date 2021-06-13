import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodnews/src/models/pelicula_model.dart';
import 'package:foodnews/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'Spiderman',
    'Aguaman',
    'Batman',
    'Shazamn',
    'Iroman',
    'Capitan Amrica'
  ];
  final peliculasRecientes = ['spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // ignore: todo
    // TODO: son las acciones de nuestro appbar limpiar o cancelar la busqueda
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // ignore: todo
    // TODO: icono a la izquierda del appBar
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // ignore: todo
    // TODO: Builder Crealos resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.00,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // ignore: todo
    // TODO: Soon las sugerencias que muestra cuando se escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPeliculas(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((peli) {
              return ListTile(
                leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(peli.getPosterImg()),
                    width: 50.0,
                    fit: BoxFit.contain),
                title: Text(peli.title),
                subtitle: Text(peli.originalTitle),
                onTap: () {
                  close(context, null);
                  peli.uniqueId = '';
                  Navigator.pushNamed(context, '/detalle', arguments: peli);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // final listaSugerida = (query.isEmpty)
    //     ? peliculasRecientes
    //     : peliculas
    //         .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
    //         .toList();

    // return ListView.builder(
    //   itemBuilder: (context, i) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       onTap: () {
    //         seleccion = listaSugerida[i];
    //         showResults(context);
    //       },
    //     );
    //   },
    //   itemCount: listaSugerida.length,
    // );
  }
}
