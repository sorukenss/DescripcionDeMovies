import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pelicula/models/models.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({
    required this.movieId
    });
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen:false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot){
        if(!snapshot.hasData){
          return Container(
            constraints: const BoxConstraints(maxHeight: 150),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }

        final List<Cast> cast = snapshot.data!;
          return Container(
            margin:const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,
            child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_,int index)=> _CastCard(actor:cast[index]),
         ),

        );
       },
     );
   
   }
}


class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({ 
    required this.actor
    });
  @override
  Widget build(BuildContext context) {
    return Container(
    
      margin:const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(actor.fullProfilePath),
            height: 140,
            width: 100,
            fit: BoxFit.cover,

           ),
        ),

        const SizedBox(height: 5,),

        Text(
          actor.name,
          //style: Theme.of(context).textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,


          ),

      ]),

    );
  }
}