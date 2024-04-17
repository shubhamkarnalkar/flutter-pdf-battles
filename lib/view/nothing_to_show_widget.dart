import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/constants/constants.dart';

class NothingToShow extends ConsumerWidget {
  const NothingToShow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Image.asset(
                    emptyImage,
                    fit: BoxFit.fitHeight,
                  ),
                  const Text('It\'s empty in here'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
