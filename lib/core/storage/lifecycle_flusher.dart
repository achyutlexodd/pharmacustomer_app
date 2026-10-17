import 'package:flutter/widgets.dart';
import '../storage/user_data_registry.dart';

/// Flushes all pending writes across the app whenever app lifecycle enters background/inactive states.
class LifecycleFlusher with WidgetsBindingObserver {
  final UserDataRegistry registry;

  LifecycleFlusher(this.registry);

  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        registry.flushAll();
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }
}
