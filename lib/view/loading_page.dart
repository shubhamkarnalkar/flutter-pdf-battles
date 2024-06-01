import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/model/loading_model.dart';

final loadingProvider = StateProvider<LoadingModel>((ref) {
  return LoadingModel();
});

class LoadingWidget extends ConsumerWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // RiveAnimation.asset(
            //   'assets/animations/earth.riv',
            // ),
            Text(ref.watch(loadingProvider).message),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
