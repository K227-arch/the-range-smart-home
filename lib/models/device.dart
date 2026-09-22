import 'package:flutter/material.dart';

enum DeviceType {
  light,
  thermostat,
  airPurifier,
  switch_,
  airConditioner,
  sweeper,
  curtain,
  socket,
  sensor,
  lock,
  camera,
  gateway,
  musicHost,
  intercom,
}

enum DeviceStatus { online, offline, error }

enum ProtocolType { wifi, zigbee, bluetooth }

class Device {
  final String id;
  final String name;
  final String room;
  final DeviceType type;
  final DeviceStatus status;
  final ProtocolType protocol;
  bool isOn;
  final Map<String, dynamic> attributes;
  final IconData icon;
  final Color iconColor;

  Device({
    required this.id,
    required this.name,
    required this.room,
    required this.type,
    required this.status,
    required this.protocol,
    required this.isOn,
    required this.icon,
    required this.iconColor,
    this.attributes = const {},
  });

  Device copyWith({bool? isOn}) => Device(
        id: id,
        name: name,
        room: room,
        type: type,
        status: status,
        protocol: protocol,
        isOn: isOn ?? this.isOn,
        icon: icon,
        iconColor: iconColor,
        attributes: attributes,
      );
}
