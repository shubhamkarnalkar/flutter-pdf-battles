import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

final intentFilesProvider =
    FutureProvider.autoDispose<List<SharedMediaFile>>((ref) async {
  return getFilesFromPlatform();
});
Future<List<SharedMediaFile>> getFilesFromPlatform() async {
  final _sharedFiles = <SharedMediaFile>[];
  // Get the media sharing coming from outside the app while the app is closed.
  final value = await ReceiveSharingIntent.instance.getInitialMedia();
  _sharedFiles.clear();
  _sharedFiles.addAll(value);
  // print(_sharedFiles.map((f) => f.toMap()));

  // Tell the library that we are done processing the intent.
  ReceiveSharingIntent.instance.reset();
  return _sharedFiles;
}

final intentFilesProviderStr =
    StreamProvider.autoDispose<List<SharedMediaFile>>((ref) async* {
  yield* getFilesFromPlatformStr();
});
Stream<List<SharedMediaFile>> getFilesFromPlatformStr() async* {
  final _sharedFiles = <SharedMediaFile>[];
  void onData(List<SharedMediaFile> event) {
    _sharedFiles.clear();
    _sharedFiles.addAll(event);
  }

  if (_sharedFiles.length > 0) yield _sharedFiles;

  // Listen to media sharing coming from outside the app while the app is in the memory.
  ReceiveSharingIntent.instance.getMediaStream().listen(
        (event) => onData(event),
        cancelOnError: true,
      );
}
