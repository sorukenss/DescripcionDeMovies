import 'package:flutter/material.dart';
import 'package:pelicula/screens/screens.dart';
import 'package:provider/provider.dart';
import 'providers/movies_provider.dart';


void main() => runApp(AppState());


class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (_) => MoviesProvider(),lazy:false)
      ],
      child: const MyApp(),
      );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peliculas',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home' : (_) =>   HomeScreen(),
        'details' : (_) =>  DetailsScreen(),
      },
     theme: ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
        color: Colors.teal,
      ),
     ),
    );
  }
}