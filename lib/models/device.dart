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

/// Tracks whether a NAJOD/SnarF technician has set up the device.
enum InstallationStatus { notInstalled, scheduled, installed }

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

  // ── SnarF-specific fields ─────────────────────────────────────────────────
  /// True when device has confirmed internet + remote access available.
  final bool remoteAccess;

  /// Live wattage reading (sockets only). null = no monitoring.
  final double? powerWatts;

  /// NAJOD installation tracking.
  final InstallationStatus installationStatus;

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
    this.remoteAccess = true,
    this.powerWatts,
    this.installationStatus = InstallationStatus.installed,
  });

  Device copyWith({
    bool? isOn,
    DeviceStatus? status,
    bool? remoteAccess,
    double? powerWatts,
    InstallationStatus? installationStatus,
  }) =>
      Device(
        id: id,
        name: name,
        room: room,
        type: type,
        status: status ?? this.status,
        protocol: protocol,
        isOn: isOn ?? this.isOn,
        icon: icon,
        iconColor: iconColor,
        attributes: attributes,
        remoteAccess: remoteAccess ?? this.remoteAccess,
        powerWatts: powerWatts ?? this.powerWatts,
        installationStatus: installationStatus ?? this.installationStatus,
      );
}
