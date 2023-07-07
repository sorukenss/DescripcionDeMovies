import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pelicula/helpers/debouncer.dart';
import '../models/models.dart';


class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '5b5877668a39f892dec33596ee6e49be';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-Es';

    List<Movie> onDisplayMovies=[];
    List<Movie> popularMovies=[];

    Map<int , List<Cast>> moviesCast ={};

    int _popularPage = 0;

    final debouncer = Debouncer(
      duration: Duration(milliseconds: 500),
    );

    final StreamController<List<Movie>> _suggestionStreamController = StreamController();
    Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider(){
    // ignore: avoid_print
    print('Movies provider inicializado');

    // ignore: unnecessary_this
    this.getOnDisplayMovies();
    // ignore: unnecessary_this
    this.getPopularMovies();

    

  }

  Future<String> _getJsonData(String endpoint,[int page = 1]) async {
    final url = Uri.https(
    _baseUrl, // host (autoridad)
    endpoint, // ruta
    {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    },
  );
      // Await the http get response, then decode the json-formatted response.
       final response = await http.get(url);
        return response.body;

  }

   // ignore: non_constant_identifier_names
   getOnDisplayMovies() async {

     final jsonData = await _getJsonData('3/movie/now_playing');
      final nowPlayingResponse = NowPlayingResponse.fromRawJson(jsonData);

      // ignore: avoid_print
      print(nowPlayingResponse.results[0].title);

      onDisplayMovies = nowPlayingResponse.results;

      notifyListeners();
     
    }

    getPopularMovies() async {
      _popularPage++;
     final jsonData = await _getJsonData('3/movie/popular',_popularPage);
      final popularResponse = PopularResponse.fromRawJson(jsonData);

      // ignore: avoid_print
      print(popularResponse.results[0].title);

      popularMovies = [...popularMovies, ...popularResponse.results];

      notifyListeners();
    }

    Future< List<Cast>> getMovieCast(int movieId) async {

      if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

      final jsonData = await _getJsonData('3/movie/$movieId/credits');
      final creditsResponse = CreditsResponse.fromRawJson(jsonData);

      moviesCast[movieId] = creditsResponse.cast;
      return creditsResponse.cast;

    }


    Future <List<Movie>> searchMovie (String query) async {

      final url = Uri.https(
    _baseUrl, // host (autoridad)
    '3/search/movie', // ruta
    {
      'api_key': _apiKey,
      'language': _language,
      'query' : query,
    });
      final response = await http.get(url);
      final searchResponse = SearchResponse.fromRawJson(response.body);
      return searchResponse.results;

    }


     void getSuggestionsByQuery( String searchTerm ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchMovie(value);
      this._suggestionStreamController.add( results );
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), ( _ ) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration( milliseconds: 301)).then(( _ ) => timer.cancel());

   
  }

    


}