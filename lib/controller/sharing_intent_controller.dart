import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

final intentFilesProvider = FutureProvider<List<SharedMediaFile>>((ref) async {
  return getFilesFromPlatform();
});
Future<List<SharedMediaFile>> getFilesFromPlatform() async {
  final sharedFiles = <SharedMediaFile>[];

  // // Listen to media sharing coming from outside the app while the app is in the memory.
  // intentSub = ReceiveSharingIntent.getMediaStream().listen((value) {
  //   sharedFiles.clear();
  //   sharedFiles.addAll(value);
  //   // debugPrint(_sharedFiles.map((f) => f.toMap()) );
  // }, onError: (err) {
  //   // debugPrint("getIntentDataStream error: $err");
  //   // throw '$err';
  // });

  // // Get the media sharing coming from outside the app while the app is closed.
  // ReceiveSharingIntent.getInitialMedia().then((value) {
  //   sharedFiles.clear();
  //   sharedFiles.addAll(value);
  //   // debugPrint(_sharedFiles.map((f) => f.toMap() ) );

  //   // Tell the library that we are done processing the intent.
  //   ReceiveSharingIntent.reset();
  // });

  // Get the media sharing coming from outside the app while the app is closed.
  final List<SharedMediaFile> values =
      await ReceiveSharingIntent.getInitialMedia();
  sharedFiles.clear();
  sharedFiles.addAll(values);
  // debugPrint(_sharedFiles.map((f) => f.toMap() ) );

  // Tell the library that we are done processing the intent.
  ReceiveSharingIntent.reset();
  // intentSub.cancel();
  return sharedFiles;
}
