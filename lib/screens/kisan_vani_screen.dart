import 'package:flutter/material.dart';

class KisanVaniScreen extends StatefulWidget {
  const KisanVaniScreen({super.key});

  @override
  State<KisanVaniScreen> createState() => _KisanVaniScreenState();
}

class _KisanVaniScreenState extends State<KisanVaniScreen> {
  int _selectedChip = 0;

  static const _chips = [
    'All', 'Advisories', 'Schemes', 'Weather', 'Market', 'Tips',
  ];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        // ── Header ──
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, top + 14, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Kisan Vani 📢',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Farmer advisories & updates',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF888888)),
                      ),
                    ],
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        color: Color(0xFF444444), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // ── Featured Banner ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '🌧  IMD Alert',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Heavy rain expected in Tamil Nadu this week',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Protect your crops · Avoid spraying pesticides',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_queue,
                          color: Colors.white, size: 26),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),

        // ── Chip Filter ──
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: _chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = _selectedChip == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedChip = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 0),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFEEEEEE),
                      ),
                    ),
                    child: Text(
                      _chips[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF666666),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),

        // ── Feed ──
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            physics: const BouncingScrollPhysics(),
            itemCount: _feedItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _VaniCard(item: _feedItems[i]),
          ),
        ),
      ],
    );
  }

  static final _feedItems = [
    _VaniItem(
      tag: 'Advisory',
      tagColor: const Color(0xFF1565C0),
      tagBg: const Color(0xFFE3F2FD),
      icon: Icons.tips_and_updates_outlined,
      iconColor: const Color(0xFF1565C0),
      title: 'Manage Leaf Curl in Chilli',
      body:
          'Spray Imidacloprid 0.3 ml/litre to control thrips causing leaf curl. Repeat after 10 days if infection persists.',
      source: 'TNAU Advisory',
      time: '2h ago',
      likes: 148,
      bookmarked: false,
    ),
    _VaniItem(
      tag: 'Scheme',
      tagColor: const Color(0xFF6A1B9A),
      tagBg: const Color(0xFFF3E5F5),
      icon: Icons.account_balance_outlined,
      iconColor: const Color(0xFF6A1B9A),
      title: 'PM Kisan 19th Instalment Released',
      body:
          'The 19th instalment of PM-KISAN (₹2,000) has been transferred to eligible farmers. Check your registered bank account.',
      source: 'Government of India',
      time: '5h ago',
      likes: 412,
      bookmarked: true,
    ),
    _VaniItem(
      tag: 'Market',
      tagColor: const Color(0xFFE65100),
      tagBg: const Color(0xFFFFF3E0),
      icon: Icons.trending_up,
      iconColor: const Color(0xFFE65100),
      title: 'Tomato Prices Rise 20% This Week',
      body:
          'Due to reduced arrivals from Andhra Pradesh, tomato prices at Koyambedu APMC surged to ₹2,200/quintal.',
      source: 'Agmarknet · Market Intelligence',
      time: '8h ago',
      likes: 265,
      bookmarked: false,
    ),
    _VaniItem(
      tag: 'Tips',
      tagColor: const Color(0xFF2E7D32),
      tagBg: const Color(0xFFE8F5E9),
      icon: Icons.eco_outlined,
      iconColor: const Color(0xFF2E7D32),
      title: 'Summer Crop Water Management',
      body:
          'Irrigate sugarcane and banana in the early morning (5–7 AM) to reduce evaporation losses. Mulching can save up to 30% water.',
      source: 'Crop Care Expert',
      time: '1d ago',
      likes: 89,
      bookmarked: false,
    ),
    _VaniItem(
      tag: 'Weather',
      tagColor: const Color(0xFF00838F),
      tagBg: const Color(0xFFE0F7FA),
      icon: Icons.wb_sunny_outlined,
      iconColor: const Color(0xFF00838F),
      title: 'Clear Skies Expected Next Week',
      body:
          'Post-rain, clear weather is forecast from March 8–14. Ideal window for Rabi harvest operations and land preparation.',
      source: 'IMD · Tamil Nadu',
      time: '1d ago',
      likes: 197,
      bookmarked: false,
    ),
  ];
}

// ─────────────────────────────────────────────
// VANI CARD
// ─────────────────────────────────────────────
class _VaniCard extends StatefulWidget {
  final _VaniItem item;
  const _VaniCard({required this.item});

  @override
  State<_VaniCard> createState() => _VaniCardState();
}

class _VaniCardState extends State<_VaniCard> {
  late bool _bookmarked;
  late int _likes;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.item.bookmarked;
    _likes = widget.item.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: widget.item.tagBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.item.tag,
                  style: TextStyle(
                    color: widget.item.tagColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                widget.item.time,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFFAAAAAA)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Icon + Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.item.tagBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.item.icon,
                    color: widget.item.iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.item.body,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),
          // Footer
          Row(
            children: [
              const Icon(Icons.source_outlined,
                  size: 13, color: Color(0xFF888888)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.item.source,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF888888)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _liked = !_liked;
                    _likes += _liked ? 1 : -1;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 15,
                      color: _liked
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF888888),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$_likes',
                      style: TextStyle(
                        fontSize: 11,
                        color: _liked
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF888888),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => setState(() => _bookmarked = !_bookmarked),
                child: Icon(
                  _bookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 18,
                  color: _bookmarked
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF888888),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────
class _VaniItem {
  final String tag;
  final Color tagColor;
  final Color tagBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String source;
  final String time;
  final int likes;
  final bool bookmarked;

  const _VaniItem({
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.source,
    required this.time,
    required this.likes,
    required this.bookmarked,
  });
}