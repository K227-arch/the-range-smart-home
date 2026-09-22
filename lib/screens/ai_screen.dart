import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _sendMessage(AppState state) {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    state.sendMessage(text);
    _chatController.clear();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final th = ThemeHelper.of(context);

    return Scaffold(
      backgroundColor: th.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(th),
            _buildTabBar(th),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ChatTab(
                    state: state,
                    th: th,
                    scrollController: _scrollController,
                    chatController: _chatController,
                    onSend: () => _sendMessage(state),
                  ),
                  _AIServicesTab(th: th),
                  _HealthTab(th: th),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeHelper th) {
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.home_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 6),
              Text('My Home',
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: th.textPrimary)),
            ],
          ),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.aiGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: th.chipBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add_rounded,
                    size: 20, color: th.iconPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeHelper th) {
    return Container(
      color: th.topBarBg,
      child: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['Favorites', 'Living room', 'Bedroom']
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          e.value,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: e.key == 0
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: e.key == 0
                                ? th.textPrimary
                                : th.textSecondary,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: th.textSecondary,
            labelStyle:
                GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle:
                GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400),
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'AI Chat'),
              Tab(text: 'AI Services'),
              Tab(text: 'Health'),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Chat Tab ─────────────────────────────────────────────────────────────────

class _ChatTab extends StatelessWidget {
  final AppState state;
  final ThemeHelper th;
  final ScrollController scrollController;
  final TextEditingController chatController;
  final VoidCallback onSend;

  const _ChatTab({
    required this.state,
    required this.th,
    required this.scrollController,
    required this.chatController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _QuickCommandRow(th: th),
              const SizedBox(height: 16),
              // Device shortcut chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Turn on the bedroom lights', 'Turn o...']
                      .map((t) => GestureDetector(
                            onTap: () {
                              chatController.text = t;
                              onSend();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: th.isDark
                                    ? AppColors.primary.withValues(alpha: 0.12)
                                    : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                      Icons.lightbulb_outline_rounded,
                                      size: 14,
                                      color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(t,
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              ...state.chatHistory.map((msg) => _ChatBubble(message: msg, th: th)),
              const SizedBox(height: 8),
            ],
          ),
        ),
        _ChatInputBar(controller: chatController, onSend: onSend, th: th),
      ],
    );
  }
}

class _QuickCommandRow extends StatelessWidget {
  final ThemeHelper th;
  const _QuickCommandRow({required this.th});

  @override
  Widget build(BuildContext context) {
    final commands = [
      {'icon': Icons.home_rounded, 'label': 'Go home', 'color': AppColors.accentGreen},
      {'icon': Icons.directions_walk_rounded, 'label': 'Leaving home', 'color': AppColors.accentOrange},
    ];

    return Row(
      children: commands
          .map((c) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      right: commands.last == c ? 0 : 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: (c['color'] as Color).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: (c['color'] as Color).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(c['icon'] as IconData,
                          size: 16, color: c['color'] as Color),
                      const SizedBox(width: 6),
                      Text(c['label'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: c['color'] as Color)),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final Map<String, String> message;
  final ThemeHelper th;

  const _ChatBubble({required this.message, required this.th});

  @override
  Widget build(BuildContext context) {
    final isUser = message['role'] == 'user';

    return Padding(
      padding: EdgeInsets.only(
          bottom: 12, left: isUser ? 60 : 0, right: isUser ? 0 : 60),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : th.cardBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(color: th.borderColor),
                boxShadow: isUser ? [] : th.cardShadow,
              ),
              child: Text(
                message['text'] ?? '',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isUser ? Colors.white : th.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ThemeHelper th;

  const _ChatInputBar(
      {required this.controller, required this.onSend, required this.th});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: th.inputFill,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: th.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'How can I help?',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 14, color: th.textHint),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic_rounded,
                        color: th.iconSecondary, size: 20),
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AI Services Tab ──────────────────────────────────────────────────────────

class _AIServicesTab extends StatelessWidget {
  final ThemeHelper th;
  const _AIServicesTab({required this.th});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'icon': Icons.lightbulb_rounded,   'title': 'AI Lighting',      'desc': 'In large language models, we provide users with personalised lighting solutions.', 'color': AppColors.accentYellow, 'tag': 'Smart'},
      {'icon': Icons.security_rounded,    'title': 'AI Protect',       'desc': 'Select AI in large language models for personalised security and 24/7 protection of your home.', 'color': AppColors.accentBlue, 'tag': 'New'},
      {'icon': Icons.translate_rounded,   'title': 'AI Translate',     'desc': 'AI translate model. Translations are more accurate and natural. Pair with AI headphones for seamless communication.', 'color': AppColors.accentGreen, 'tag': null},
      {'icon': Icons.note_alt_rounded,    'title': 'AI Notes',         'desc': 'AI helps you record and summarise meetings, courses, and interviews.', 'color': AppColors.accentOrange, 'tag': null},
      {'icon': Icons.bolt_rounded,        'title': 'AI Energy Saving', 'desc': 'Optimise energy usage across your home automatically.', 'color': AppColors.accentGreen, 'tag': null},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Energy summary card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: th.cardBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: th.cardShadow,
            border: Border.all(color: th.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Energy saving',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: th.textSecondary)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('27',
                            style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: th.textPrimary)),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('kW·h',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: th.textSecondary)),
                        ),
                      ],
                    ),
                    Text('7 days total',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: th.textHint)),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [4, 6, 5, 8, 7, 9, 6].map((h) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: h * 5.0,
                          decoration: BoxDecoration(
                            color: AppColors.accentYellow,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        ...services.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: th.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: th.cardShadow,
                  border: Border.all(color: th.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (s['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(s['icon'] as IconData,
                          color: s['color'] as Color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(s['title'] as String,
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: th.textPrimary)),
                              if (s['tag'] != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(s['tag'] as String,
                                      style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(s['desc'] as String,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: th.textSecondary,
                                  height: 1.4),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: th.textHint),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

// ─── Health Tab ───────────────────────────────────────────────────────────────

class _HealthTab extends StatelessWidget {
  final ThemeHelper th;
  const _HealthTab({required this.th});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AI Healthy card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: th.cardBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: th.cardShadow,
            border: Border.all(color: th.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AI Healthy',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: th.textPrimary)),
                  Row(children: [
                    Icon(Icons.more_horiz_rounded,
                        color: th.textHint, size: 20),
                    const SizedBox(width: 8),
                    Icon(Icons.close_rounded, color: th.textHint, size: 20),
                  ]),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.72,
                          strokeWidth: 8,
                          backgroundColor:
                              AppColors.accentRed.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.accentRed),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            value: 0.55,
                            strokeWidth: 6,
                            backgroundColor:
                                AppColors.accentGreen.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.accentGreen),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: CircularProgressIndicator(
                            value: 0.8,
                            strokeWidth: 4,
                            backgroundColor:
                                AppColors.accentBlue.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.accentBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        _HealthStat(label: 'Steps', value: '1323', th: th),
                        const SizedBox(height: 8),
                        _HealthStat(label: 'Distance', value: '1.2 km', th: th),
                        const SizedBox(height: 8),
                        _HealthStat(
                            label: 'Calories', value: '500 kcal', th: th),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_run_rounded,
                        size: 16, color: AppColors.accentGreen),
                    const SizedBox(width: 8),
                    Text('Sports Records',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGreen)),
                    const Spacer(),
                    Text('Outdoor running 10 km · 32km · Jan 8',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: th.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _VitalCard(icon: Icons.bedtime_rounded,      label: 'Sleep',          value: '8',      unit: '32 hrs', color: AppColors.accentPurple, th: th),
            _VitalCard(icon: Icons.favorite_rounded,     label: 'Blood Pressure', value: '120/66', unit: 'mmHg',   color: AppColors.accentRed,    th: th),
            _VitalCard(icon: Icons.air_rounded,          label: 'Blood Oxygen',   value: '8',      unit: '32 %',   color: AppColors.accentBlue,   th: th),
            _VitalCard(icon: Icons.monitor_heart_rounded,label: 'Heart Rate',     value: '120/66', unit: 'bpm',    color: AppColors.accentRed,    th: th),
            _VitalCard(icon: Icons.scale_rounded,        label: 'Weight',         value: '8',      unit: '32 kg',  color: AppColors.accentOrange, th: th),
          ],
        ),

        const SizedBox(height: 16),

        // AI Notes card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: th.cardBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: th.cardShadow,
            border: Border.all(color: th.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AI Notes',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: th.textPrimary)),
                  Row(children: [
                    Icon(Icons.more_horiz_rounded,
                        color: th.textHint, size: 20),
                    const SizedBox(width: 8),
                    Icon(Icons.close_rounded, color: th.textHint, size: 20),
                  ]),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RecordMode(
                      icon: Icons.mic_rounded, label: 'Recording', th: th),
                  _RecordMode(
                      icon: Icons.closed_caption_rounded,
                      label: 'Real-time\nTranscription',
                      th: th),
                  _RecordMode(
                      icon: Icons.phone_rounded,
                      label: 'Phone\nRecording',
                      th: th),
                ],
              ),
              const SizedBox(height: 16),
              // Waveform mock
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: th.subtleFill,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(30, (i) {
                    final heights = [
                      4, 8, 12, 16, 20, 24, 20, 16, 12, 8,
                      4, 8, 14, 18, 22, 18, 14, 10, 6, 10,
                      14, 18, 22, 26, 22, 18, 14, 10, 6, 4
                    ];
                    return Container(
                      width: 3,
                      height: heights[i].toDouble(),
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Everyone here? First, let\'s have Zhang Yue from the product team report on the confirmation status of the core requirements.',
                style: GoogleFonts.inter(
                    fontSize: 12, color: th.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 12),
              // Meeting minutes
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: th.minutesBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: th.minutesBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Meeting Minutes',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text('2025/02/01 15:54',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: th.textHint)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Reminder
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: th.reminderBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_hospital_rounded,
                        size: 16, color: AppColors.accentOrange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Go to hospital',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: th.textPrimary)),
                          Text('Every Friday at 18:30',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: th.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat_bubble_rounded,
                          size: 14, color: AppColors.accentOrange),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HealthStat extends StatelessWidget {
  final String label;
  final String value;
  final ThemeHelper th;

  const _HealthStat(
      {required this.label, required this.value, required this.th});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 12, color: th.textSecondary)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: th.textPrimary)),
      ],
    );
  }
}

class _VitalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;
  final ThemeHelper th;

  const _VitalCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.th,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: th.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: th.cardShadow,
        border: Border.all(color: th.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: th.textPrimary)),
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 10, color: th.textHint)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordMode extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeHelper th;

  const _RecordMode(
      {required this.icon, required this.label, required this.th});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: th.subtleFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: th.iconSecondary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 11, color: th.textSecondary),
            textAlign: TextAlign.center),
      ],
    );
  }
}
