import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityConfigure {
  /// Custom method to be called when the connection is changed
  final Function(ConnectivityResult result)? onConnectivityChanged;

  /// Custom method to be called when the connection is lost
  final Function? onConnectionLost;

  /// Custom method to be called when the connection is reestablished
  final Function? onConnectionReestablished;

  /// If true, a toast will be shown when the connection is lost and reestablished.
  final bool useDefaultBehavior;

  const ConnectivityConfigure({
    this.onConnectivityChanged,
    this.onConnectionLost,
    this.onConnectionReestablished,
    this.useDefaultBehavior = false,
  });

  /// Copy with method
  ConnectivityConfigure copyWith({
    Function(ConnectivityResult result)? onConnectivityChanged,
    Function? onConnectionLost,
    Function? onConnectionReestablished,
    bool? useDefaultBehavior,
  }) {
    return ConnectivityConfigure(
      onConnectivityChanged:
          onConnectivityChanged ?? this.onConnectivityChanged,
      onConnectionLost: onConnectionLost ?? this.onConnectionLost,
      onConnectionReestablished:
          onConnectionReestablished ?? this.onConnectionReestablished,
      useDefaultBehavior: useDefaultBehavior ?? this.useDefaultBehavior,
    );
  }
}
