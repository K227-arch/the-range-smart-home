import 'package:flutter/foundation.dart';
import 'device.dart';
import 'scene.dart';
import 'room.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  // ─── Navigation ───────────────────────────────────────────────────────────
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ─── Rooms & Devices ──────────────────────────────────────────────────────
  List<Room> _rooms = List.from(MockData.rooms);
  List<Room> get rooms => _rooms;
  List<Device> _devices = List.from(MockData.devices);
  List<Device> get devices => _devices;

  String _selectedRoomId = 'all';
  String get selectedRoomId => _selectedRoomId;

  void selectRoom(String roomId) {
    _selectedRoomId = roomId;
    notifyListeners();
  }

  List<Device> get filteredDevices {
    if (_selectedRoomId == 'all') return _devices;
    return _devices
        .where((d) =>
            d.room.toLowerCase().contains(_selectedRoomId.toLowerCase()) ||
            rooms
                    .firstWhere((r) => r.id == _selectedRoomId,
                        orElse: () => Room(
                            id: '', name: '', deviceCount: 0, activeCount: 0))
                    .name ==
                d.room)
        .toList();
  }

  void toggleDevice(String deviceId) {
    _devices = _devices.map((d) {
      if (d.id == deviceId) return d.copyWith(isOn: !d.isOn);
      return d;
    }).toList();
    notifyListeners();
  }

  void addDevice(Device device) {
    _devices = [..._devices, device];
    // Also bump the room's deviceCount
    _rooms = _rooms.map((r) {
      if (r.name == device.room) {
        return Room(
          id: r.id,
          name: r.name,
          deviceCount: r.deviceCount + 1,
          activeCount: device.isOn ? r.activeCount + 1 : r.activeCount,
        );
      }
      // Always update the 'all' room total
      if (r.id == 'all') {
        return Room(
          id: r.id,
          name: r.name,
          deviceCount: r.deviceCount + 1,
          activeCount: device.isOn ? r.activeCount + 1 : r.activeCount,
        );
      }
      return r;
    }).toList();
    notifyListeners();
  }

  void addRoom(Room room) {
    _rooms = [..._rooms, room];
    notifyListeners();
  }

  int get activeDeviceCount => _devices.where((d) => d.isOn).length;

  // ─── Scenes ───────────────────────────────────────────────────────────────
  List<Scene> _tapToRunScenes = List.from(MockData.tapToRunScenes);
  List<Scene> _automationScenes = List.from(MockData.automationScenes);
  List<Scene> get tapToRunScenes => _tapToRunScenes;
  List<Scene> get automationScenes => _automationScenes;

  void runScene(String sceneId) {
    // In production: fire MQTT / Tuya commands
    notifyListeners();
  }

  void addScene(Scene scene) {
    if (scene.type == SceneType.tapToRun) {
      _tapToRunScenes = [..._tapToRunScenes, scene];
    } else {
      _automationScenes = [..._automationScenes, scene];
    }
    notifyListeners();
  }

  // ─── Theme ────────────────────────────────────────────────────────────────
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ─── Energy ───────────────────────────────────────────────────────────────
  bool _energyWeekView = true;
  bool get energyWeekView => _energyWeekView;

  void toggleEnergyView(bool isWeek) {
    _energyWeekView = isWeek;
    notifyListeners();
  }

  List<double> get energyData =>
      _energyWeekView ? MockData.weeklyEnergy : MockData.monthlyEnergy;

  double get totalEnergy => energyData.fold(0, (a, b) => a + b);

  // ─── AI Chat ──────────────────────────────────────────────────────────────
  List<Map<String, String>> _chatHistory = List.from(MockData.chatHistory);
  List<Map<String, String>> get chatHistory => _chatHistory;

  void sendMessage(String text) {
    _chatHistory.add({'role': 'user', 'text': text});
    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 800), () {
      _chatHistory.add({
        'role': 'ai',
        'text': _generateAIResponse(text),
      });
      notifyListeners();
    });
    notifyListeners();
  }

  void clearChat() {
    _chatHistory = [];
    notifyListeners();
  }

  String _generateAIResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('light') || lower.contains('lights')) {
      return 'Done! I\'ve adjusted the lights as requested.';
    } else if (lower.contains('temperature') || lower.contains('thermostat')) {
      return 'The current temperature is 22°C. Would you like me to adjust it?';
    } else if (lower.contains('lock') || lower.contains('door')) {
      return 'The front door is currently locked. All secure!';
    } else if (lower.contains('scene')) {
      return 'Which scene would you like to activate?';
    } else {
      return 'Got it! Processing your request for the smart home system.';
    }
  }
}
