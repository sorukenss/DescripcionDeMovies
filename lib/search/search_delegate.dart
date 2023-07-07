import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/movies_provider.dart';


class MovieSearchDelegate extends SearchDelegate {

  @override
  String get searchFieldLabel => 'Buscar Pelicula';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
         icon: const Icon(Icons.clear),
         ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon( Icons.arrow_back ),
        onPressed: () {
          close(context, null );
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
     //if(query.isEmpty){
      return Text('Busqueda');
     }
  
  Widget _emptyContainer(){
    return Container(
        child:const  Center(
          child:  Icon(Icons.movie_creation_outlined,size: 200, color:Colors.black38),
          ),
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    
    if(query.isEmpty){
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen:false);
    moviesProvider.getSuggestionsByQuery(query);
    return StreamBuilder(
      stream: moviesProvider.suggestionStream, 
      builder: (_, AsyncSnapshot <List<Movie>> snapshot){

        if(!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length, 
          itemBuilder: (_, int index) => _MovieItem(movie:movies[index]),
          );
      }
      );
  }

}


class _MovieItem extends StatelessWidget {

 final Movie movie;

  const _MovieItem({
    required this.movie
    });

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'Search-${movie.id}';
    return ListTile(
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            placeholder:const AssetImage('assets/no-image.jpg'),
             image: NetworkImage(movie.fullPosterImg),
             width:100,
             height: 100,
             fit: BoxFit.contain,
             ),
        ),
           title : Text(movie.title),
           subtitle: Text(movie.originalTitle),
           onTap: (){
            Navigator.pushNamed(context, 'details',arguments: movie);
           },
    );
  }
}