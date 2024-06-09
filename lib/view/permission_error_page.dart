// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionErrorPage extends ConsumerWidget {
  final String errorMessage;
  const PermissionErrorPage({
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.key,
            color: Colors.amberAccent,
            size: 120,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Follwing permissions are needed to run this app\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () => openAppSettings(),
            label: Text('Go to Settings'),
            icon: Icon(Icons.settings),
          )
        ],
      ),
    );
  }
}
