import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../widgets/Dialogs/AddBoilerDialog.dart';
import 'package:http/http.dart' as http;
import '../../logic/API.dart' as api;

class FindDeviceDialog extends StatefulWidget {
  final void Function(String name, String type,String id) onSave;
  final String? homeId;

  const FindDeviceDialog({super.key, required this.onSave, required this.homeId});

  @override
  State<FindDeviceDialog> createState() => _FindDeviceDialogState();
}

class _FindDeviceDialogState extends State<FindDeviceDialog> {
  final List<ScanResult> foundDevices = [];
  ScanResult? selectedDevice;
  BluetoothCharacteristic? ssid;
  BluetoothCharacteristic? deviceID;
  List<String> availableNetworks = [];
  String? selectedNetwork;
  TextEditingController controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    scanForDevice();
  }

  // Scan for devices
  void scanForDevice() async {
    if (await FlutterBluePlus.isSupported) {
      FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
      var subscription = FlutterBluePlus.onScanResults.listen(
        (results) {
          for (var r in results) {
            if (r.advertisementData.advName == "Boiler Device") {
              if (!foundDevices.any((device) => device.device.remoteId == r.device.remoteId)) {
                setState(() => foundDevices.add(r));
              }
            }
          }
        },
        onError: (e) => print("Error scanning for devices: $e"),
      );

      Future.delayed(Duration(seconds: 10), () {
        FlutterBluePlus.stopScan();
        print("Scan stopped after 10 seconds.");
        subscription.cancel();
      });
    } else {
      print("Bluetooth not supported");
    }
  }

  // Add device and fetch SSID list
  void _addDevice(ScanResult scanResult) async {
    bool isLoadingNetworks = false;
    print("📡 Selected device: ${scanResult.advertisementData.advName}");
    final device = scanResult.device;


    setState(() {
      isLoadingNetworks = true;
    });

    try {
      // Connect to the device
      await device.connect();
      print("✅ Connected to device: ${device.remoteId}");

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      print("📡 Discovered ${services.length} services");

      // Loop through services to find SSID list
      for (BluetoothService service in services) {
        if (service.uuid.toString() == "779b") {
          print("Found SSID service");
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if(characteristic.uuid.toString() == "eff4"){
              print("Found SSID reciver");
              ssid = characteristic;
            }
            if(characteristic.uuid.toString() == "eff3"){
              print("Found DeviceID");
              deviceID = characteristic;
            }
            if (characteristic.uuid.toString() == "eff5") {
              print("Found SSID List");
              await characteristic.setNotifyValue(true);
              List<int> data = await characteristic.read();
              String raw = utf8.decode(data, allowMalformed: true);
              print('Raw decoded string: $raw');

              List<String> ssidList = raw
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();

              print('Parsed SSIDs: $ssidList');

              setState(() {
                // Update available networks
                availableNetworks = availableNetworks.where((ssid) => ssidList.contains(ssid)).toList();
                for (String ssid in ssidList) {
                  if (!availableNetworks.contains(ssid)) {
                    availableNetworks.add(ssid);
                  }
                }

                // Select the first network if available
                if (ssidList.isNotEmpty) {
                  selectedNetwork = ssidList.first;
                }
              });
            }
          }
        }
      }

      // Update the UI with the selected device's name
      setState(() {
        selectedDevice = scanResult;
      });
    } catch (e) {
      print("❌ Error connecting to device: $e");
    }
  }

  // Submit selected network and device
  void _connectDevice() async{
    if (selectedDevice != null && selectedNetwork != null) {
      ssid!.write(utf8.encode(selectedNetwork!));
      await Future.delayed(Duration(seconds: 2));
      ssid!.write(utf8.encode(controller2.text));
      print("Selected device: ${selectedDevice!.advertisementData.advName}, Network: $selectedNetwork, Password: ${controller2.text}");
      await deviceID!.setNotifyValue(true);
      List<int> data = await deviceID!.read();
      String raw = utf8.decode(data, allowMalformed: true);
      print("Device ID: $raw");
      await Future.delayed(Duration(seconds: 2));
      if(raw == "NotSet") {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not connect to the device. Please check the device and try again.')),
        );
        return;
      }
      widget.onSave(selectedDevice!.advertisementData.advName, selectedNetwork!, raw);
      showDialog(
        context: context,
        builder: (context) => AddBoilerDialog(
          homeId: widget.homeId,
          deviceId: raw,
          onSave: (name, type) {
            widget.onSave(name, type, raw); // raw is device ID
            Navigator.pop(context); // close FindDeviceDialog if needed
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(selectedDevice == null ? 'Finding Boiler' : 'Enter Information'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedDevice == null) ...[
              if (foundDevices.isEmpty) ...[
                Text('Please wait while we find your boiler.'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ] else ...[
                Text('Select your boiler:'),
                SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundDevices.length,
                    itemBuilder: (context, index) {
                      final deviceName = foundDevices[index].advertisementData.advName;
                      return TextButton(
                        onPressed: () => _addDevice(foundDevices[index]),
                        child: Text(deviceName),
                      );
                    },
                  ),
                ),
              ],
            ] else ...[
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedNetwork,
                decoration: InputDecoration(labelText: 'Wi-Fi Network'),
                items: availableNetworks.map((ssid) {
                  return DropdownMenuItem(value: ssid, child: Text(ssid));
                }).toList(),
                onChanged: (value) => setState(() => selectedNetwork = value),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller2,
                decoration: InputDecoration(labelText: 'Wi-Fi Password'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        if (selectedDevice != null && selectedNetwork != null) ...[
          TextButton(
            onPressed: _connectDevice,
            child: Text('Connect'),
          ),
        ],
      ],
    );
  }
}
