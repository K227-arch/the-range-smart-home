import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/device.dart';
import '../theme/app_colors.dart';
import '../widgets/device_card.dart';
import '../widgets/section_header.dart';
import 'device_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, state),
            _buildRoomTabs(context, state),
            Expanded(
              child: _buildDeviceGrid(context, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppState state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home name
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: AppColors.textSecondary),
                ],
              ),
              Row(
                children: [
                  // Active devices badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.active.withOpacity(0.1),
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
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add_rounded,
                          size: 20, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Favourites / Room / menu row
          Row(
            children: [
              _TabChip(
                label: 'Favorites',
                isSelected: state.selectedRoomId == 'favorites',
                onTap: () => state.selectRoom('favorites'),
              ),
              const SizedBox(width: 6),
              _TabChip(
                label: 'Living room',
                isSelected: state.selectedRoomId == 'living',
                onTap: () => state.selectRoom('living'),
              ),
              const SizedBox(width: 6),
              _TabChip(
                label: 'Bedroom',
                isSelected: state.selectedRoomId == 'bedroom',
                onTap: () => state.selectRoom('bedroom'),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showRoomSheet(context, state),
                child: const Icon(Icons.menu_rounded,
                    size: 22, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildRoomTabs(BuildContext context, AppState state) {
    return Container(
      color: Colors.white,
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
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        r.name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: state.selectedRoomId == r.id
                              ? Colors.white
                              : AppColors.textSecondary,
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

  Widget _buildDeviceGrid(BuildContext context, AppState state) {
    final devices = state.filteredDevices;

    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.devices_other_rounded,
                size: 64, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(
              'No devices in this room',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
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
                        builder: (_) => DeviceDetailScreen(device: device),
                      ),
                    ),
                  );
                },
                childCount: devices.length,
              ),
            ),
          ),
          // Bottom padding for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showRoomSheet(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
              color: const Color(0xFFCBD5E1),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.meeting_room_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(r.name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              subtitle: Text('${r.deviceCount} devices · ${r.activeCount} on',
                  style: GoogleFonts.inter(fontSize: 12)),
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

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
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
          color:
              isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          decoration:
              isSelected ? TextDecoration.underline : TextDecoration.none,
          decorationColor: AppColors.primary,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
