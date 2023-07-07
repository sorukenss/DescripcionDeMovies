import 'package:flutter/material.dart';
import 'package:pelicula/search/search_delegate.dart';
import 'package:pelicula/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';

class HomeScreen extends StatelessWidget {
 

  @override 
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas'),
        elevation: 0,
        actions: [
          IconButton(
           icon: const Icon(Icons.search_outlined),
           onPressed: () => showSearch(context: context,delegate:MovieSearchDelegate() ),
           ),
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body:SingleChildScrollView(
        child: Column(
            children:  [
               CardSwiper(movies: moviesProvider.onDisplayMovies),
              
  
              MovieSlider(
                popular : moviesProvider.popularMovies, 
                title : 'Populares',
                onPage: ()=> moviesProvider.getPopularMovies(),
              ),
              
              
      
            ],
        ),
      ),
    );
  }
}