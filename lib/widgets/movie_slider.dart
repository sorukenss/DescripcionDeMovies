import 'package:flutter/material.dart';
import 'package:pelicula/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> popular;
  final String? title;
  final Function onPage;

  const MovieSlider({
    super.key,
    required this.popular, 
    this.title, 
    required this.onPage
   });

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

    @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
          widget.onPage();
      }

    });


  }


  @override
  void dispose() {
    



    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [

          if(widget.title !=null)
           Padding(
            padding:const  EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.title!,style: const TextStyle(fontSize:20,fontWeight:FontWeight.bold),),
            ),

            const SizedBox(height: 5,),

           Expanded(
             child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.popular.length, 
              itemBuilder: (_ , int index) => _MoviPoster(popular: widget.popular[index] ,heroId: '${widget.title}-$index-${widget.popular[index].id}'),
              ),
           ),
        ],
      ),
    );
  }
}

class _MoviPoster extends StatelessWidget {
  
  final Movie popular;
  final String heroId;

   const _MoviPoster({
   required this.popular,
    required this.heroId
   });
  @override
  Widget build(BuildContext context) {
    
    popular.heroId = heroId;
    return Container(
        width: 130,
        height: 190, 
        margin: const EdgeInsets.symmetric(horizontal:10),

        child: Column(
          children: [
            GestureDetector(
              onTap: ()=> Navigator.pushNamed(context, 'details',arguments: popular),
              child: Hero(
                tag: popular.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/no-image.jpg'),
                     image: NetworkImage(popular.fullPosterImg),
                     width: 130,
                     height: 190,
                     fit: BoxFit.cover,
                     ),
                ),
              ),
            ),

              const SizedBox(height:5),

             Text(popular.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
   );
  }
}