import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_info_model.dart';

class DeviceInfoNotifier extends Notifier<List<DeviceInfo>> {
  @override
  build() {
    return [];
  }

  setDevicesInfo(List<DeviceInfo> devicesInfo) {
    state = devicesInfo;
  }

  _addDeviceInfo(DeviceInfo deviceInfo) {
    if (state.where((infos) => infos.serialNo == deviceInfo.serialNo).isEmpty) {
      state = [...state, deviceInfo];
    }
  }

  removeDeviceInfo(DeviceInfo deviceInfo) {
    state = [...state.where((info) => info.serialNo != deviceInfo.serialNo)];
  }

  addOrEditDeviceInfo(DeviceInfo deviceInfo) {
    removeDeviceInfo(deviceInfo);
    _addDeviceInfo(deviceInfo);
  }
}

final infoProvider = NotifierProvider<DeviceInfoNotifier, List<DeviceInfo>>(
    () => DeviceInfoNotifier());
