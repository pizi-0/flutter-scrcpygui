import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BonsoirNotifier extends Notifier<List<BonsoirService>> {
  @override
  build() {
    return [];
  }

  void addService(BonsoirService service) {
    final newstate = state;

    newstate.removeWhere((e) => e.name == service.name);
    newstate.add(service);

    state = [...newstate];
  }

  void removeService(BonsoirService service) {
    final newstate = state;

    newstate.removeWhere((e) => e.name == service.name);

    state = [...newstate];
  }
}

final bonsoirDeviceProvider =
    NotifierProvider<BonsoirNotifier, List<BonsoirService>>(
        () => BonsoirNotifier());

class BonsoirPairingNotifier extends Notifier<List<BonsoirService>> {
  @override
  build() {
    return [];
  }

  void addService(BonsoirService service) {
    final newstate = state;

    newstate.removeWhere((e) => e.name == service.name);
    newstate.add(service);

    state = [...newstate];
  }

  void removeService(BonsoirService service) {
    final newstate = state;

    newstate.removeWhere((e) => e.name == service.name);

    state = [...newstate];
  }
}

final pairingDeviceProvider =
    NotifierProvider<BonsoirPairingNotifier, List<BonsoirService>>(
        () => BonsoirPairingNotifier());
