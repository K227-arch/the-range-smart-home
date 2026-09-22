import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _doorLocked = true;
  bool _alarmArmed = false;
  int _selectedCamera = 0;

  final List<Map<String, dynamic>> _cameras = [
    {'name': 'Front Door', 'room': 'Entrance', 'status': 'Live'},
    {'name': 'Back Garden', 'room': 'Garden', 'status': 'Live'},
    {'name': 'Living Room', 'room': 'Interior', 'status': 'Recording'},
    {'name': 'Garage', 'room': 'Garage', 'status': 'Offline'},
  ];

  final List<Map<String, dynamic>> _events = [
    {
      'type': 'Motion',
      'location': 'Front Door',
      'time': '2 min ago',
      'icon': Icons.directions_walk_rounded,
      'color': AppColors.warning,
    },
    {
      'type': 'Door Opened',
      'location': 'Back Door',
      'time': '14 min ago',
      'icon': Icons.door_front_door_rounded,
      'color': AppColors.accentBlue,
    },
    {
      'type': 'Face Recognised',
      'location': 'Front Door',
      'time': '1 h ago',
      'icon': Icons.face_rounded,
      'color': AppColors.accentGreen,
    },
    {
      'type': 'Delivery',
      'location': 'Entrance',
      'time': '3 h ago',
      'icon': Icons.local_shipping_rounded,
      'color': AppColors.accentPurple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildCameraViewer()),
            SliverToBoxAdapter(child: _buildCameraList()),
            SliverToBoxAdapter(child: _buildAccessControl()),
            SliverToBoxAdapter(child: _buildSmartLock()),
            SliverToBoxAdapter(child: _buildEventLog()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Protect Your Home',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              // Arm/disarm button
              GestureDetector(
                onTap: () => setState(() => _alarmArmed = !_alarmArmed),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _alarmArmed
                        ? AppColors.error.withValues(alpha: 0.1)
                        : AppColors.active.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _alarmArmed
                          ? AppColors.error.withValues(alpha: 0.3)
                          : AppColors.active.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _alarmArmed
                            ? Icons.security_rounded
                            : Icons.shield_outlined,
                        size: 16,
                        color:
                            _alarmArmed ? AppColors.error : AppColors.active,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _alarmArmed ? 'Armed' : 'Disarmed',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _alarmArmed
                              ? AppColors.error
                              : AppColors.active,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraViewer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main camera view
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Simulated camera feed background
                ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_rounded,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.3)),
                          const SizedBox(height: 8),
                          Text(
                            _cameras[_selectedCamera]['name'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          Text(
                            'Live Feed',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Live badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Camera controls
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Row(
                    children: [
                      _CameraControlBtn(
                          icon: Icons.mic_rounded, onTap: () {}),
                      const SizedBox(width: 8),
                      _CameraControlBtn(
                          icon: Icons.screenshot_rounded, onTap: () {}),
                      const SizedBox(width: 8),
                      _CameraControlBtn(
                          icon: Icons.fullscreen_rounded, onTap: () {}),
                    ],
                  ),
                ),
                // Camera name overlay
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Text(
                    _cameras[_selectedCamera]['room'] ?? '',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraList() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cameras.length,
        itemBuilder: (context, i) {
          final cam = _cameras[i];
          final isSelected = _selectedCamera == i;
          final isOffline = cam['status'] == 'Offline';

          return GestureDetector(
            onTap: () => setState(() => _selectedCamera = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 130,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.videocam_rounded,
                        size: 14,
                        color: isOffline
                            ? AppColors.textHint
                            : isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cam['name'],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isOffline
                                ? AppColors.textHint
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isOffline
                              ? AppColors.textHint
                              : AppColors.active,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        cam['status'],
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isOffline
                              ? AppColors.textHint
                              : AppColors.active,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccessControl() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Intercom & Access',
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.video_call_rounded,
                  label: 'Video Call',
                  subLabel: 'Front door',
                  color: AppColors.accentBlue,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.face_rounded,
                  label: 'Face Unlock',
                  subLabel: '3 faces stored',
                  color: AppColors.accentPurple,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.fingerprint_rounded,
                  label: 'Fingerprint',
                  subLabel: '5 prints',
                  color: AppColors.accentGreen,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartLock() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _doorLocked
                    ? AppColors.accentBlue.withValues(alpha: 0.1)
                    : AppColors.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _doorLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                color: _doorLocked
                    ? AppColors.accentBlue
                    : AppColors.accentGreen,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Door Lock',
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    _doorLocked ? 'Locked · Secure' : 'Unlocked',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _doorLocked
                          ? AppColors.accentBlue
                          : AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'IP65 · Face + Fingerprint + PIN',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _doorLocked = !_doorLocked),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 52,
                height: 28,
                decoration: BoxDecoration(
                  color: _doorLocked
                      ? AppColors.accentBlue
                      : AppColors.accentGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: _doorLocked
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventLog() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Events',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View all',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._events.map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (e['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(e['icon'] as IconData,
                        color: e['color'] as Color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['type'],
                          style: GoogleFonts.inter(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          e['location'],
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    e['time'],
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CameraControlBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              subLabel,
              style: GoogleFonts.inter(
                  fontSize: 10, color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
