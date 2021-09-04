import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/utils/result_state.dart';

class StateProvider extends ChangeNotifier {
  ResultState state = ResultState.Loading;
  String? error = "Ada masalah";
}
