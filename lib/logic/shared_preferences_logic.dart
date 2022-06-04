import 'package:riverpod_countup/data/count_data.dart';
import 'package:riverpod_countup/logic/count_data_changed_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLogic with CountDataChangedNotifier {
  static const keyCountUp = 'COUNT_UP';
  static const keyCountDown = 'COUNT_DOWN';
  static const keyCount = 'COUNT';

  @override
  void valueChanged(CountData oldData, CountData newData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt(keyCount, newData.count);
    sharedPreferences.setInt(keyCountUp, newData.countUp);
    sharedPreferences.setInt(keyCountDown, newData.countDown);
  }

  static Future<CountData> read() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return CountData(
        count: await sharedPreferences.getInt(keyCount) ?? 0,
        countUp: await sharedPreferences.getInt(keyCountUp) ?? 0,
        countDown: await sharedPreferences.getInt(keyCountDown) ?? 0);
  }
}
