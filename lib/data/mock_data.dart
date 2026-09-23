import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/scene.dart';
import '../models/room.dart';

class MockData {
  // ─── Rooms ───────────────────────────────────────────────────────────────────
  static final List<Room> rooms = [
    Room(id: 'all',      name: 'All',         deviceCount: 14, activeCount: 6),
    Room(id: 'living',   name: 'Living Room', deviceCount: 5,  activeCount: 3),
    Room(id: 'bedroom',  name: 'Bedroom',     deviceCount: 3,  activeCount: 1),
    Room(id: 'kitchen',  name: 'Kitchen',     deviceCount: 2,  activeCount: 1),
    Room(id: 'bathroom', name: 'Bathroom',    deviceCount: 1,  activeCount: 1),
    Room(id: 'office',   name: 'Office',      deviceCount: 2,  activeCount: 0),
    Room(id: 'outdoor',  name: 'Outdoor',     deviceCount: 1,  activeCount: 0),
  ];

  // ─── Devices — SnarF product range only ──────────────────────────────────────
  static final List<Device> devices = [
    // ── Living Room ─────────────────────────────────────────────────────────
    Device(
      id: 'd1',
      name: '3 Gang Switch',
      room: 'Living Room',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: true,
      icon: Icons.toggle_on_rounded,
      iconColor: const Color(0xFF2563EB),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
      attributes: {'gangs': 3},
    ),
    Device(
      id: 'd2',
      name: 'Dimming Switch',
      room: 'Living Room',
      type: DeviceType.light,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: true,
      icon: Icons.wb_incandescent_rounded,
      iconColor: const Color(0xFFF59E0B),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
      attributes: {'brightness': 70},
    ),
    Device(
      id: 'd3',
      name: '2 Gang Socket',
      room: 'Living Room',
      type: DeviceType.socket,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: true,
      icon: Icons.electrical_services_rounded,
      iconColor: const Color(0xFF059669),
      remoteAccess: true,
      powerWatts: 142.5,
      installationStatus: InstallationStatus.installed,
      attributes: {'power': 142.5},
    ),
    Device(
      id: 'd4',
      name: '1 Gang Switch',
      room: 'Living Room',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: false,
      icon: Icons.toggle_on_rounded,
      iconColor: const Color(0xFF2563EB),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
    ),
    Device(
      id: 'd5',
      name: 'Fountain Jet Controller',
      room: 'Living Room',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: false,
      icon: Icons.water_rounded,
      iconColor: const Color(0xFF0EA5E9),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
    ),

    // ── Bedroom ──────────────────────────────────────────────────────────────
    Device(
      id: 'd6',
      name: '2 Gang Switch',
      room: 'Bedroom',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: true,
      icon: Icons.toggle_on_rounded,
      iconColor: const Color(0xFF2563EB),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
      attributes: {'gangs': 2},
    ),
    Device(
      id: 'd7',
      name: 'Water Heater Switch',
      room: 'Bedroom',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: false,
      icon: Icons.hot_tub_rounded,
      iconColor: const Color(0xFFEF4444),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
    ),
    Device(
      id: 'd8',
      name: 'USB + Socket',
      room: 'Bedroom',
      type: DeviceType.socket,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: false,
      icon: Icons.usb_rounded,
      iconColor: const Color(0xFF059669),
      remoteAccess: true,
      powerWatts: 0,
      installationStatus: InstallationStatus.installed,
      attributes: {'power': 0},
    ),

    // ── Kitchen ──────────────────────────────────────────────────────────────
    Device(
      id: 'd9',
      name: '1 Gang Socket',
      room: 'Kitchen',
      type: DeviceType.socket,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: true,
      icon: Icons.electrical_services_rounded,
      iconColor: const Color(0xFF059669),
      remoteAccess: true,
      powerWatts: 870.0,
      installationStatus: InstallationStatus.installed,
      attributes: {'power': 870.0},
    ),
    Device(
      id: 'd10',
      name: '1 Gang Switch',
      room: 'Kitchen',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: true,
      icon: Icons.toggle_on_rounded,
      iconColor: const Color(0xFF2563EB),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
    ),

    // ── Bathroom ─────────────────────────────────────────────────────────────
    Device(
      id: 'd11',
      name: 'Water Heater Switch',
      room: 'Bathroom',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: true,
      icon: Icons.hot_tub_rounded,
      iconColor: const Color(0xFFEF4444),
      remoteAccess: true,
      installationStatus: InstallationStatus.installed,
    ),

    // ── Office ───────────────────────────────────────────────────────────────
    Device(
      id: 'd12',
      name: '2 Gang Socket',
      room: 'Office',
      type: DeviceType.socket,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: false,
      icon: Icons.electrical_services_rounded,
      iconColor: const Color(0xFF059669),
      remoteAccess: false, // Simulates remote-off scenario
      powerWatts: 0,
      installationStatus: InstallationStatus.scheduled,
      attributes: {'power': 0},
    ),
    Device(
      id: 'd13',
      name: '3 Gang Switch',
      room: 'Office',
      type: DeviceType.switch_,
      status: DeviceStatus.online,
      protocol: ProtocolType.wifi,
      isOn: false,
      icon: Icons.toggle_on_rounded,
      iconColor: const Color(0xFF2563EB),
      remoteAccess: false,
      installationStatus: InstallationStatus.scheduled,
    ),

    // ── Outdoor ──────────────────────────────────────────────────────────────
    Device(
      id: 'd14',
      name: 'RGB LED Fountain Light',
      room: 'Outdoor',
      type: DeviceType.light,
      status: DeviceStatus.online,
      protocol: ProtocolType.zigbee,
      isOn: false,
      icon: Icons.light_rounded,
      iconColor: const Color(0xFF0EA5E9),
      remoteAccess: true,
      installationStatus: InstallationStatus.notInstalled,
      attributes: {'brightness': 100},
    ),
  ];

  // ─── Scenes ──────────────────────────────────────────────────────────────────
  static final List<Scene> tapToRunScenes = [
    Scene(
      id: 's1',
      name: 'Good Morning',
      icon: Icons.wb_sunny_rounded,
      color: const Color(0xFFF59E0B),
      type: SceneType.tapToRun,
      description: 'All switches on, dimmer at 80%',
      deviceActions: ['3 Gang Switch on', 'Dimmer 80%', 'Water heater on'],
    ),
    Scene(
      id: 's2',
      name: 'All Off',
      icon: Icons.nightlight_round,
      color: const Color(0xFF6366F1),
      type: SceneType.tapToRun,
      description: 'Every switch and socket off',
      deviceActions: ['All switches off', 'All sockets off'],
    ),
    Scene(
      id: 's3',
      name: 'Movie Mode',
      icon: Icons.movie_rounded,
      color: const Color(0xFFEF4444),
      type: SceneType.tapToRun,
      description: 'Dim to 20%, sockets stay on',
      deviceActions: ['Dimmer 20%', 'Other switches off'],
    ),
    Scene(
      id: 's4',
      name: 'Fountain On',
      icon: Icons.water_rounded,
      color: const Color(0xFF0EA5E9),
      type: SceneType.tapToRun,
      description: 'Fountain jets + RGB lights on',
      deviceActions: ['Fountain jet on', 'RGB lights on'],
    ),
    Scene(
      id: 's5',
      name: 'Away Mode',
      icon: Icons.directions_walk_rounded,
      color: const Color(0xFFF97316),
      type: SceneType.tapToRun,
      description: 'All off, sockets cut power',
      deviceActions: ['All switches off', 'All sockets off'],
    ),
    Scene(
      id: 's6',
      name: 'Energy Save',
      icon: Icons.bolt_rounded,
      color: const Color(0xFF10B981),
      type: SceneType.tapToRun,
      description: 'Dim lights, cut idle sockets',
      deviceActions: ['Dimmer 40%', 'Idle sockets off'],
    ),
  ];

  static final List<Scene> automationScenes = [
    Scene(
      id: 'a1',
      name: 'Water Heater Schedule',
      icon: Icons.hot_tub_rounded,
      color: const Color(0xFFEF4444),
      type: SceneType.automation,
      description: 'On at 05:00 · Off at 06:30',
      isEnabled: true,
    ),
    Scene(
      id: 'a2',
      name: 'Sunset Lights',
      icon: Icons.wb_twilight_rounded,
      color: const Color(0xFFF59E0B),
      type: SceneType.automation,
      description: 'Switches on at sunset daily',
      isEnabled: true,
    ),
    Scene(
      id: 'a3',
      name: 'Overload Guard',
      icon: Icons.shield_rounded,
      color: const Color(0xFF2563EB),
      type: SceneType.automation,
      description: 'Cut socket if load > 3000 W',
      isEnabled: true,
    ),
    Scene(
      id: 'a4',
      name: 'Night Mode',
      icon: Icons.bedtime_rounded,
      color: const Color(0xFF6366F1),
      type: SceneType.automation,
      description: 'All off at 23:00',
      isEnabled: false,
    ),
    Scene(
      id: 'a5',
      name: 'Fountain Timer',
      icon: Icons.water_rounded,
      color: const Color(0xFF0EA5E9),
      type: SceneType.automation,
      description: 'Fountain on 18:00–22:00',
      isEnabled: true,
    ),
  ];

  // ─── Energy data ──────────────────────────────────────────────────────────────
  static final List<double> weeklyEnergy = [
    3.8, 5.2, 4.6, 6.1, 7.4, 8.9, 5.7,
  ];

  static final List<double> monthlyEnergy = [
    24.0, 28.5, 22.0, 31.0, 38.0, 33.0,
    27.0, 40.0, 35.0, 23.0, 29.0, 37.0,
  ];

  // ─── AI Chat ──────────────────────────────────────────────────────────────────
  static final List<Map<String, String>> chatHistory = [
    {'role': 'user', 'text': 'Turn on all the lights'},
    {
      'role': 'ai',
      'text':
          'Done! All SnarF switches are now on across Living Room, Bedroom, Kitchen, and Bathroom.'
    },
    {'role': 'user', 'text': 'How much power is the kitchen socket using?'},
    {
      'role': 'ai',
      'text':
          'The Kitchen 1 Gang Socket is drawing 870 W right now — looks like the kettle or microwave is running.'
    },
  ];
}
