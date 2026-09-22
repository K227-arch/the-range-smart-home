import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
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
                  GestureDetector(
                    onTap: () {},
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
            child: SectionHeader(title: 'Rooms', actionLabel: 'Add room'),
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
