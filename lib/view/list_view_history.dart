import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/controller/history_file_names_controller.dart';
import 'package:pdf_battles/model/hive/pdf_files.dart';
import 'package:pdf_battles/view/pdf_from_asset.dart';

class ListViewHistory extends ConsumerStatefulWidget {
  final List<PdfFiles> _files;
  const ListViewHistory({super.key, required List<PdfFiles> files})
      : _files = files;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListViewHistoryState();
}

class _ListViewHistoryState extends ConsumerState<ListViewHistory> {
  @override
  Widget build(BuildContext context) {
    void showPdf(String name, String path) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerFromFilePath(
            pdfAssetPath: path,
            name: name,
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              clipBehavior: Clip.none,
              shape: const StadiumBorder(),
              scrolledUnderElevation: 0.0,
              titleSpacing: 0.0,
              backgroundColor: Colors.transparent,
              floating:
                  true, // We can also uncomment this line and set `pinned` to true to see a pinned search bar.
              title: SearchAnchor.bar(
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return widget._files.map(
                    (i) => GestureDetector(
                      onTap: () => showPdf(i.name, i.path),
                      child: ListTile(
                        title: Text(i.name),
                        trailing: Icon(Icons.directions),
                      ),
                    ),
                  );
                },
              ),
            ),
            // The listed items below are just for filling the screen
            // so we can see the scrolling effect.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 100.0,
                  child: ListView.builder(
                    itemCount: widget._files.length,
                    itemBuilder: (context, index) {
                      final i = widget._files[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              i.name,
                              maxLines: 1,
                            ),
                            IconButton.outlined(
                              onPressed: () => ref
                                  .read(historyFilesProvider.notifier)
                                  .changePinnedStatus(i.isPinned, i.name),
                              icon: Icon(i.isPinned
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget withoutSearchBar() {
//   return SizedBox(
//     height: double.maxFinite,
//     width: double.maxFinite,
//     child: ListView.builder(
//       itemCount: _files.length,
//       itemBuilder: (context, index) {
//         final i = _files[index];
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 i.name,
//                 maxLines: 1,
//               ),
//               IconButton.outlined(
//                 onPressed: () => ref
//                     .read(historyFilesProvider.notifier)
//                     .changePinnedStatus(i.isPinned, i.name),
//                 icon:
//                     Icon(i.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
//               )
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }
