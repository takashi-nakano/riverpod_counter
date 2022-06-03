import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/data/count_data.dart';

final titleProvider = Provider<String>((ref) {
  return "Riverpod demo page";
});

final messageProvider =
    Provider<String>((ref) => 'You have pushed the button this many times:');

final countProvider = StateProvider<int>((ref) => 10);
final countDataProvider = StateProvider<CountData>(
    (ref) => const CountData(count: 0, countDown: 0, countUp: 0));
