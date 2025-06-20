import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_info_model.dart';

class DeviceInfoNotifier extends Notifier<List<DeviceInfo>> {
  @override
  build() {
    return [];
  }

  void setDevicesInfo(List<DeviceInfo> devicesInfo) {
    state = devicesInfo;
  }

  void _addDeviceInfo(DeviceInfo deviceInfo) {
    if (state.where((infos) => infos.serialNo == deviceInfo.serialNo).isEmpty) {
      state = [...state, deviceInfo];
    }
  }

  void removeDeviceInfo(DeviceInfo deviceInfo) {
    state = [...state.where((info) => info.serialNo != deviceInfo.serialNo)];
  }

  void addOrEditDeviceInfo(DeviceInfo deviceInfo) {
    removeDeviceInfo(deviceInfo);
    _addDeviceInfo(deviceInfo);
  }
}

final infoProvider = NotifierProvider<DeviceInfoNotifier, List<DeviceInfo>>(
    () => DeviceInfoNotifier());
