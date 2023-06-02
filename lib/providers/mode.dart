import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrightnessMode extends StateNotifier<bool>{
  BrightnessMode():super(false);


  changeMode(){
    state = !state;
  }
}

final brightnessProvider = StateNotifierProvider<BrightnessMode, bool>((ref)=>BrightnessMode());
