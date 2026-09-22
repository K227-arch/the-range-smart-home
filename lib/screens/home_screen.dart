import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/device.dart';
import '../models/room.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';
import '../widgets/device_card.dart';
import '../widgets/section_header.dart';
import 'device_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final th = ThemeHelper.of(context);

    return Scaffold(
      backgroundColor: th.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, state, th),
            _buildRoomTabs(context, state, th),
            Expanded(child: _buildDeviceGrid(context, state, th)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppState state, ThemeHelper th) {
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.home_rounded,
                      size: 20, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'My Home',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: th.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: th.textSecondary),
                ],
              ),
              Row(
                children: [
                  // Active devices badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.active.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.active,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${state.activeDeviceCount} On',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.active,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // ── Dark / Light mode toggle ───────────────────────
                  GestureDetector(
                    onTap: () => state.toggleTheme(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: state.isDarkMode
                            ? AppColors.accentYellow.withValues(alpha: 0.12)
                            : th.chipBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => RotationTransition(
                          turns: anim,
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                        child: Icon(
                          state.isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                          key: ValueKey(state.isDarkMode),
                          size: 20,
                          color: state.isDarkMode
                              ? AppColors.accentYellow
                              : th.iconPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showAddDeviceSheet(context, state, th),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: th.chipBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add_rounded,
                          size: 20, color: th.iconPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _TabChip(
                label: 'Favorites',
                isSelected: state.selectedRoomId == 'favorites',
                onTap: () => state.selectRoom('favorites'),
                th: th,
              ),
              const SizedBox(width: 6),
              _TabChip(
                label: 'Living room',
                isSelected: state.selectedRoomId == 'living',
                onTap: () => state.selectRoom('living'),
                th: th,
              ),
              const SizedBox(width: 6),
              _TabChip(
                label: 'Bedroom',
                isSelected: state.selectedRoomId == 'bedroom',
                onTap: () => state.selectRoom('bedroom'),
                th: th,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showRoomSheet(context, state, th),
                child: Icon(Icons.menu_rounded,
                    size: 22, color: th.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildRoomTabs(
      BuildContext context, AppState state, ThemeHelper th) {
    return Container(
      color: th.topBarBg,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: state.rooms
              .map(
                (r) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => state.selectRoom(r.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: state.selectedRoomId == r.id
                            ? AppColors.primary
                            : th.chipBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        r.name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: state.selectedRoomId == r.id
                              ? Colors.white
                              : th.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDeviceGrid(
      BuildContext context, AppState state, ThemeHelper th) {
    final devices = state.filteredDevices;

    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.devices_other_rounded,
                size: 64, color: th.textHint),
            const SizedBox(height: 12),
            Text(
              'No devices in this room',
              style: GoogleFonts.inter(fontSize: 15, color: th.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async =>
          await Future.delayed(const Duration(seconds: 1)),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final device = devices[index];
                  return DeviceCard(
                    device: device,
                    onToggle: () => state.toggleDevice(device.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DeviceDetailScreen(device: device),
                      ),
                    ),
                  );
                },
                childCount: devices.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showRoomSheet(
      BuildContext context, AppState state, ThemeHelper th) {
    showModalBottomSheet(
      context: context,
      backgroundColor: th.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: th.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Rooms',
              actionLabel: 'Add room',
              onAction: () {
                Navigator.pop(ctx);
                _showAddRoomDialog(context, state, th);
              },
            ),
          ),
          ...state.rooms.map(
            (r) => ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.meeting_room_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(r.name,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: th.textPrimary)),
              subtitle: Text(
                  '${r.deviceCount} devices · ${r.activeCount} on',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: th.textSecondary)),
              trailing: state.selectedRoomId == r.id
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary)
                  : null,
              onTap: () {
                state.selectRoom(r.id);
                Navigator.pop(ctx);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Add Device bottom sheet ──────────────────────────────────────────────
  void _showAddDeviceSheet(
      BuildContext context, AppState state, ThemeHelper th) {
    final deviceTypes = [
      {'type': DeviceType.light,          'icon': Icons.lightbulb_rounded,        'label': 'Light',        'color': const Color(0xFFF59E0B)},
      {'type': DeviceType.thermostat,     'icon': Icons.thermostat_rounded,        'label': 'Thermostat',   'color': const Color(0xFFEF4444)},
      {'type': DeviceType.airConditioner,'icon': Icons.ac_unit_rounded,            'label': 'AC',           'color': const Color(0xFF3B82F6)},
      {'type': DeviceType.switch_,        'icon': Icons.toggle_on_rounded,         'label': 'Switch',       'color': const Color(0xFF10B981)},
      {'type': DeviceType.socket,         'icon': Icons.electrical_services_rounded,'label': 'Socket',      'color': const Color(0xFFF59E0B)},
      {'type': DeviceType.sensor,         'icon': Icons.sensors_rounded,           'label': 'Sensor',       'color': const Color(0xFF06B6D4)},
      {'type': DeviceType.curtain,        'icon': Icons.blinds_rounded,            'label': 'Curtain',      'color': const Color(0xFFF97316)},
      {'type': DeviceType.camera,         'icon': Icons.videocam_rounded,          'label': 'Camera',       'color': const Color(0xFFEF4444)},
      {'type': DeviceType.lock,           'icon': Icons.lock_rounded,              'label': 'Lock',         'color': const Color(0xFF2563EB)},
      {'type': DeviceType.airPurifier,    'icon': Icons.air_rounded,               'label': 'Air Purifier', 'color': const Color(0xFF06B6D4)},
    ];

    final nameCtrl = TextEditingController();
    DeviceType? selectedType;
    String? selectedRoom;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: th.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: th.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Add Device',
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        color: th.textPrimary)),
                const SizedBox(height: 4),
                Text('Choose a type and name your new device',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: th.textSecondary)),
                const SizedBox(height: 20),

                // Device type grid
                Text('Device type',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: deviceTypes.map((dt) {
                    final isSelected = selectedType == dt['type'];
                    final color = dt['color'] as Color;
                    return GestureDetector(
                      onTap: () => setSheet(() => selectedType = dt['type'] as DeviceType),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.15)
                              : th.chipBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? color : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(dt['icon'] as IconData,
                                size: 16,
                                color: isSelected ? color : th.iconPrimary),
                            const SizedBox(width: 6),
                            Text(dt['label'] as String,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? color
                                        : th.textPrimary)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Name field
                Text('Device name',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: th.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. Kitchen Light',
                    hintStyle: GoogleFonts.inter(color: th.textHint),
                    filled: true,
                    fillColor: th.inputFill,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Room picker
                Text('Room',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.rooms
                      .where((r) => r.id != 'all')
                      .map((r) {
                    final isSel = selectedRoom == r.name;
                    return GestureDetector(
                      onTap: () => setSheet(() => selectedRoom = r.name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : th.chipBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Text(r.name,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSel
                                    ? AppColors.primary
                                    : th.textSecondary)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      if (selectedType == null || name.isEmpty ||
                          selectedRoom == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please fill in all fields',
                                style: GoogleFonts.inter()),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                        return;
                      }
                      final chosen = deviceTypes.firstWhere(
                          (d) => d['type'] == selectedType);
                      state.addDevice(Device(
                        id: 'd_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        room: selectedRoom!,
                        type: selectedType!,
                        status: DeviceStatus.online,
                        protocol: ProtocolType.wifi,
                        isOn: false,
                        icon: chosen['icon'] as IconData,
                        iconColor: chosen['color'] as Color,
                      ));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('"$name" added to $selectedRoom',
                                style: GoogleFonts.inter()),
                          ]),
                          backgroundColor: AppColors.active,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text('Add Device',
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add Room dialog ──────────────────────────────────────────────────────
  void _showAddRoomDialog(
      BuildContext context, AppState state, ThemeHelper th) {
    final nameCtrl = TextEditingController();
    final roomIcons = [
      Icons.living_rounded,
      Icons.bed_rounded,
      Icons.kitchen_rounded,
      Icons.bathroom_rounded,
      Icons.work_rounded,
      Icons.garage_rounded,
      Icons.balcony_rounded,
      Icons.meeting_room_rounded,
    ];
    IconData selectedIcon = roomIcons[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: th.cardBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Add Room',
              style: GoogleFonts.inter(
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: th.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room name',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: th.textSecondary)),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                style: GoogleFonts.inter(
                    fontSize: 14, color: th.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. Dining Room',
                  hintStyle:
                      GoogleFonts.inter(color: th.textHint),
                  filled: true,
                  fillColor: th.inputFill,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Icon',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: th.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: roomIcons.map((ic) {
                  final isSel = selectedIcon == ic;
                  return GestureDetector(
                    onTap: () => setDialog(() => selectedIcon = ic),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSel
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : th.chipBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSel
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(ic,
                          size: 22,
                          color: isSel
                              ? AppColors.primary
                              : th.iconPrimary),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.inter(color: th.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final id =
                    name.toLowerCase().replaceAll(' ', '_');
                state.addRoom(Room(
                  id: id,
                  name: name,
                  deviceCount: 0,
                  activeCount: 0,
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('"$name" room added',
                          style: GoogleFonts.inter()),
                    ]),
                    backgroundColor: AppColors.active,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Add',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeHelper th;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.th,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          color: isSelected ? th.textPrimary : th.textSecondary,
          decoration:
              isSelected ? TextDecoration.underline : TextDecoration.none,
          decorationColor: AppColors.primary,
          decorationThickness: 2,
        ),
      ),
    );
  }
}

