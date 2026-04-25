import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkCubit extends Cubit<ConnectivityResult> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _sub;

  NetworkCubit() : super(ConnectivityResult.none) {
    monitorNetwork();
  }

  void monitorNetwork() {
    _sub = _connectivity.onConnectivityChanged.listen((result) {
      emit(result as ConnectivityResult);
    });
  }

  bool get isConnected =>
      state != ConnectivityResult.none;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}