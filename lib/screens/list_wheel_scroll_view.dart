import 'package:flutter/material.dart';

List<String> images = [
  "https://images.unsplash.com/photo-1494548162494-384bba4ab999?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
  "https://s.ftcdn.net/v2013/pics/all/curated/RKyaEDwp8J7JKeZWQPuOVWvkUjGQfpCx_cover_580.jpg?r=1a0fc22192d0c808b8bb2b9bcfbf4a45b1793687",
  "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg",
  "https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg",
  "https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg",
];

class ListWheelScrollViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: new ListWheelScrollView.useDelegate(
          itemExtent: 200,
          childDelegate: ListWheelChildLoopingListDelegate(
            children: List<Widget>.generate(
              images.length,
              (index) => Image(
                height: 200.0,
                width: 200.0,
                image: NetworkImage(
                    images[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
