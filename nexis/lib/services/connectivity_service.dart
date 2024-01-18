import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  final StreamController<ConnectivityResult> _connectivityController =
      StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivityController.stream;

  ConnectivityService() {
    init();
  }

  void init() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _connectivityController.add(result);
    });
  }

  void dispose() {
    _subscription.cancel();
    _connectivityController.close();
  }
}
