import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/controller/settings_controller.dart';
import 'package:pdf_battles/model/hive/pdf_files.dart';
import 'package:pdf_battles/view/pdf_from_asset.dart';
import 'package:pdf_battles/view/pdf_from_asset_widget.dart';

import '../controller/history_file_names_controller.dart';

class CarasoulWidget extends ConsumerWidget {
  final List<PdfFiles> pdfs;
  const CarasoulWidget({super.key, required this.pdfs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isDark = identical(ref.read(themeModeProvider), ThemeMode.dark);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: CarouselSlider(
        items: pdfs.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  if (i.name.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewerFromFilePath(
                          pdfAssetPath: i.path,
                          name: i.name,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: _isDark ? Colors.white : null,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${i.name}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            IconButton.outlined(
                              onPressed: () => ref
                                  .read(historyFilesProvider.notifier)
                                  .changePinnedStatus(i.isPinned, i.name),
                              icon: Icon(i.isPinned
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PDFViewerFromFilePathWidget(
                          pdfAssetPath: i.path,
                        ),
                      ),
                    ],
                  ),
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
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          // onPageChanged: onChange,
          scrollDirection: Axis.horizontal,
        ),
      ),
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
