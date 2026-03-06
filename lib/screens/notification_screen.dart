import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Order Shipped! 🚚',
      body: 'Your order #AGR-2026-0312 (Confidor Insecticide) has been shipped and is on its way.',
      time: '2 min ago',
      type: NotifType.order,
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: 'Mandi Price Alert 📈',
      body: 'Tomato prices have risen to ₹2,100 at Koyambedu APMC, Chennai. Great time to sell!',
      time: '1 hr ago',
      type: NotifType.price,
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      title: 'Weather Advisory ⛈️',
      body: 'Heavy rain expected in Theni district for the next 3 days. Protect your crops accordingly.',
      time: '3 hr ago',
      type: NotifType.weather,
      isRead: false,
    ),
    NotificationModel(
      id: '4',
      title: 'Exclusive Offer 🎁',
      body: 'Get 20% off on all NPK Fertilizers this weekend. Use code AGRIO20 at checkout.',
      time: 'Yesterday',
      type: NotifType.offer,
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: 'Order Delivered ✅',
      body: 'Your order #AGR-2026-0271 (Mancozeb Fungicide) has been delivered successfully.',
      time: 'Yesterday',
      type: NotifType.order,
      isRead: true,
    ),
    NotificationModel(
      id: '6',
      title: 'New Crop Care Tip 🌱',
      body: 'Learn how to protect your paddy crops from stem borer attack this season.',
      time: '2 days ago',
      type: NotifType.tip,
      isRead: true,
    ),
    NotificationModel(
      id: '7',
      title: 'Mandi Price Alert 📉',
      body: 'Onion prices dropped to ₹2,800 at Madurai APMC. Monitor the market closely.',
      time: '3 days ago',
      type: NotifType.price,
      isRead: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      _notifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Orange Header ──
          Container(
            padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              // gradient: LinearGradient(
              //   colors: [Color(0xFFFF8C00), Color(0xFFFFB300)],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                   
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: 25,
                        ),
                      
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    // Mark all read
                    if (_unreadCount > 0)
                      GestureDetector(
                        onTap: _markAllRead,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.4)),
                          ),
                          child: const Text(
                            'Mark all read',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (_unreadCount > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.red.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active,
                            color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '$_unreadCount unread notification${_unreadCount > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Notification List ──
          Expanded(
            child: _notifications.isEmpty
                ? _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      return _NotificationCard(
                        notification: _notifications[i],
                        onTap: () => _markRead(_notifications[i].id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NOTIFICATION CARD
// ─────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final color = _typeColor(n.type);
    final icon = _typeIcon(n.type);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: n.isRead ? Colors.white : color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: n.isRead
                ? const Color(0xFFEEEEEE)
                : color.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(n.isRead ? 0.02 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: n.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Unread dot
                      if (!n.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.body,
                    style: TextStyle(
                      fontSize: 12,
                      color: n.isRead
                          ? const Color(0xFF888888)
                          : const Color(0xFF555555),
                      height: 1.4,
                      fontWeight: n.isRead
                          ? FontWeight.w400
                          : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Type chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel(n.type),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time,
                          size: 11, color: Color(0xFFAAAAAA)),
                      const SizedBox(width: 3),
                      Text(
                        n.time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(NotifType t) {
    switch (t) {
      case NotifType.order:   return const Color(0xFF2E7D32);
      case NotifType.price:   return const Color(0xFFFF8C00);
      case NotifType.weather: return const Color(0xFF1565C0);
      case NotifType.offer:   return const Color(0xFFAB47BC);
      case NotifType.tip:     return const Color(0xFF26A69A);
    }
  }

  IconData _typeIcon(NotifType t) {
    switch (t) {
      case NotifType.order:   return Icons.shopping_bag_outlined;
      case NotifType.price:   return Icons.trending_up;
      case NotifType.weather: return Icons.cloud_outlined;
      case NotifType.offer:   return Icons.local_offer_outlined;
      case NotifType.tip:     return Icons.eco_outlined;
    }
  }

  String _typeLabel(NotifType t) {
    switch (t) {
      case NotifType.order:   return 'Order';
      case NotifType.price:   return 'Price Alert';
      case NotifType.weather: return 'Weather';
      case NotifType.offer:   return 'Offer';
      case NotifType.tip:     return 'Crop Tip';
    }
  }
}

// ─────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'We\'ll notify you about orders,\nprices and offers here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────
enum NotifType { order, price, weather, offer, tip }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final NotifType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    required this.isRead,
  });
}