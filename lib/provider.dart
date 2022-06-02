import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleProvider = Provider<String>((ref) {
  return "Riverpod demo page";
});

final messageProvider =
    Provider<String>((ref) => 'You have pushed the button this many times:');

final countProvider = StateProvider<int>((ref) => 10);
