import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarasoulPage extends ConsumerWidget {
  final List<String> pdfs;
  const CarasoulPage({super.key, required this.pdfs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: CarouselSlider(
          items: pdfs.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: Text(
                    'text $i',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: double.maxFinite,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            // onPageChanged: onChange,
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  // onChange(int index, CarouselPageChangedReason reason) {}
  //  final List<Widget> imageSliders = pdfs
  //     .map((item) => Container(
  //           child: Container(
  //             margin: EdgeInsets.all(5.0),
  //             child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                 child: Stack(
  //                   children: <Widget>[
  //                     Image.network(item, fit: BoxFit.cover, width: 1000.0),
  //                     Positioned(
  //                       bottom: 0.0,
  //                       left: 0.0,
  //                       right: 0.0,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           gradient: LinearGradient(
  //                             colors: [
  //                               Color.fromARGB(200, 0, 0, 0),
  //                               Color.fromARGB(0, 0, 0, 0)
  //                             ],
  //                             begin: Alignment.bottomCenter,
  //                             end: Alignment.topCenter,
  //                           ),
  //                         ),
  //                         padding: EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 20.0),
  //                         child: Text(
  //                           'No. ${imgList.indexOf(item)} image',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )),
  //           ),
  //         ))
  //     .toList();
}
