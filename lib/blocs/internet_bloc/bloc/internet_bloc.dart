import 'dart:async';

import 'package:connectivity/connectivity.dart';

import 'internet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'internet_event.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivityStreamSubcription;
  InternetBloc() : super(InternetInitialState()) {
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));
    connectivityStreamSubcription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        add(InternetGainedEvent());
      } else {
        add(InternetLostEvent());
      }
    });

    Future<void> close() {
      connectivityStreamSubcription?.cancel();
      return super.close();
    }
  }
}
