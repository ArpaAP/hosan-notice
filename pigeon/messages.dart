import 'package:pigeon/pigeon.dart';

class MinewBeaconData {
  late String uuid;
  late String name;
  late int major;
  late int minor;
  late String mac;
  late int rssi;
  late int batteryLevel;
  late double temperature;
  late double humidity;
  late int txPower;
  late bool inRange;
}

@HostApi()
abstract class Api {
  List<MinewBeaconData> getScannedBeacons();
  void startScan();
  void stopScan();
}