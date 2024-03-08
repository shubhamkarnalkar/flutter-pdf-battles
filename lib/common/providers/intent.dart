// import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// List<SharedMediaFile> receiveSharingIntent() {
//   final sharedFiles = <SharedMediaFile>[];
//   // Listen to media sharing coming from outside the app while the app is in the memory.
//   ReceiveSharingIntent.getMediaStream().listen((value) {
//     sharedFiles.clear();
//     sharedFiles.addAll(value);
//     return sharedFiles;
//     // debugPrint(_sharedFiles.map((f) => f.toMap()) );
//   }, onError: (err) {
//     // debugPrint("getIntentDataStream error: $err")
//   });

//   // Get the media sharing coming from outside the app while the app is closed.
//   ReceiveSharingIntent.getInitialMedia().then((value) {
//     sharedFiles.clear();
//     sharedFiles.addAll(value);
//     // debugPrint(_sharedFiles.map((f) => f.toMap() ) );
//     List<String> listPdfs = [];
//     for (final SharedMediaFile file in sharedFiles) {
//       file.mimeType == "application/pdf" ? listPdfs.add(file.path) : null;
//     }
//     if (listPdfs.isNotEmpty) {
//       return listPdfs.first;
//     }
//     // Tell the library that we are done processing the intent.
//     ReceiveSharingIntent.reset();
//   });
// }
