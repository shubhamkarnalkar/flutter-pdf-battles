import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_io/io.dart';

/// Compatible for all the devices
/// Used [PackageInfo] in the operation
final packageInfoProvider =
    FutureProvider.autoDispose<PackageInfo>((ref) async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    // print('App Name: $appName');
    // print('Package Name: $packageName');
    // print('Version: $version');
    // print('Build Number: $buildNumber');
  } catch (e) {
    throw ('Error getting app info: $e');
  }
});

/// Compatible for Android and iOS
final permissionProvider = FutureProvider.autoDispose<void>((ref) async {
  String _error = "";

  /// For Android
  if (Platform.isAndroid) {
    try {
      final AndroidDeviceInfo _info = await DeviceInfoPlugin().androidInfo;
      if (_info.version.sdkInt > 30) {
        if (await Permission.photos.status != PermissionStatus.granted) {
          // final sta = await Permission.manageExternalStorage.status;
          await Permission.photos.request();
          if (await Permission.photos.status ==
              PermissionStatus.permanentlyDenied) _error = _error + 'Photos';
        }
      } else {
        if (await Permission.storage.status != PermissionStatus.granted) {
          await Permission.storage.request();
          if (await Permission.storage.status == PermissionStatus.denied)
            _error = _error + Permission.storage.toString();
        }

        if (await Permission.photos.status != PermissionStatus.granted) {
          // final sta = await Permission.manageExternalStorage.status;
          await Permission.photos.request();
          if (await Permission.photos.status ==
              PermissionStatus.permanentlyDenied) _error = _error + 'Photos';
        }
      }
    } catch (e) {
      //  ('Error getting app info: $e');
    }
  }

  /// Error[_error]: Catched in the provider itself
  if (_error.isNotEmpty) throw _error;
});

/// ScaffoldMessengerKey Provider
final messengerKeyProvider = Provider<GlobalKey<ScaffoldMessengerState>>((ref) {
  return GlobalKey<ScaffoldMessengerState>();
});

final messCtxProvider = Provider((ref) {
  return ref.watch(messengerKeyProvider).currentState!.context;
});
