import 'package:flutter/material.dart';

enum SceneType { tapToRun, automation }

class Scene {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final SceneType type;
  final String? description;
  final bool isEnabled;
  final List<String> deviceActions;

  Scene({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.description,
    this.isEnabled = true,
    this.deviceActions = const [],
  });
}
