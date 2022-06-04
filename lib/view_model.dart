import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/data/count_data.dart';
import 'package:riverpod_countup/logic/button_animation_logic.dart';
import 'package:riverpod_countup/logic/count_data_changed_notifier.dart';
import 'package:riverpod_countup/logic/logic.dart';
import 'package:riverpod_countup/logic/shared_preferences_logic.dart';
import 'package:riverpod_countup/logic/sound_logic.dart';
import 'package:riverpod_countup/provider.dart';

class ViewModel {
  final Logic _logic = Logic();

  final SoundLogic _soundLogic = SoundLogic();
  late ButtonAnimationLogic _buttonAnimationLogicPlus;
  late ButtonAnimationLogic _buttonAnimationLogicMinus;
  late ButtonAnimationLogic _buttonAnimationLogicReset;

  late WidgetRef _ref;

  List<CountDataChangedNotifier> notifiers = [];

  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    this._ref = ref;
    ValueChangedCondition conditionPlus =
        (CountData oldData, CountData newData) {
      return oldData.countUp + 1 == newData.countUp;
    };

    _buttonAnimationLogicPlus =
        ButtonAnimationLogic(tickerProvider, conditionPlus);
    _buttonAnimationLogicMinus = ButtonAnimationLogic(tickerProvider,
        (CountData oldData, CountData newData) {
      return oldData.countDown + 1 == newData.countDown;
    });
    _buttonAnimationLogicReset =
        ButtonAnimationLogic(tickerProvider, ((oldData, newData) {
      return newData.countUp == 0 && newData.countDown == 0;
    }));
    _soundLogic.load();

    notifiers = [
      _soundLogic,
      _buttonAnimationLogicPlus,
      _buttonAnimationLogicMinus,
      _buttonAnimationLogicReset,
      SharedPreferencesLogic(),
    ];

    SharedPreferencesLogic.read().then((value) {
      _logic.init(value);
      ref.read(countDataProvider.state).state = value;
    });
  }

  get count => _ref.watch(countDataProvider.state).state.count.toString();

  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();

  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  get animationPlusCombination =>
      _buttonAnimationLogicPlus.animationCombination;

  get animationMinusCombination =>
      _buttonAnimationLogicMinus.animationCombination;

  get animationResetCombination =>
      _buttonAnimationLogicReset.animationCombination;

  void onIncrease() {
    _logic.increase();
    update();
  }

  void onDecrease() {
    _logic.decrease();
    update();
  }

  void onReset() {
    _logic.reset();
    update();
  }

  void update() {
    CountData oldData = _ref.watch(countDataProvider.state).state;
    _ref.watch(countDataProvider.state).state = _logic.countData;
    CountData newData = _ref.watch(countDataProvider.state).state;

    notifiers.forEach((element) => element.valueChanged(oldData, newData));
    // _soundLogic.valueChanged(oldData, newData);
    // _buttonAnimationLogicPlus.valueChanged(oldData, newData);
  }
}
