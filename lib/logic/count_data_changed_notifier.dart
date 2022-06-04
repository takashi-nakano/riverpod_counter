import 'package:riverpod_countup/data/count_data.dart';

typedef ValueChangedCondition = bool Function(
    CountData oldData, CountData newData);

abstract class CountDataChangedNotifier {
  void valueChanged(CountData oldData, CountData newData);
}
