import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        // ── Header ──
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, top + 14, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list,
                            color: Color(0xFF2E7D32), size: 15),
                        SizedBox(width: 4),
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // ── Tab Bar ──
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF2E7D32),
                unselectedLabelColor: const Color(0xFF888888),
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13),
                unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 13),
                indicatorColor: const Color(0xFF2E7D32),
                indicatorWeight: 2.5,
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),

        // ── Tab Views ──
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _OrderList(orders: _activeOrders),
              _OrderList(orders: _completedOrders),
              _EmptyState(
                icon: Icons.cancel_outlined,
                message: 'No cancelled orders',
                subtitle: 'Cancelled orders will appear here',
              ),
            ],
          ),
        ),
      ],
    );
  }

  static final _activeOrders = [
    _OrderItem(
      id: '#AGR20240301',
      productName: 'NPK Fertilizer (50 kg)',
      date: '01 Mar 2026',
      status: 'Out for Delivery',
      statusColor: const Color(0xFF1565C0),
      statusBg: const Color(0xFFE3F2FD),
      price: '₹1,240',
      icon: Icons.science_outlined,
      quantity: '2 Bags',
    ),
    _OrderItem(
      id: '#AGR20240298',
      productName: 'Chlorpyrifos Insecticide',
      date: '28 Feb 2026',
      status: 'Processing',
      statusColor: const Color(0xFFE65100),
      statusBg: const Color(0xFFFFF3E0),
      price: '₹680',
      icon: Icons.bug_report_outlined,
      quantity: '1 Bottle',
    ),
    _OrderItem(
      id: '#AGR20240285',
      productName: 'Hybrid Tomato Seeds',
      date: '25 Feb 2026',
      status: 'Confirmed',
      statusColor: const Color(0xFF2E7D32),
      statusBg: const Color(0xFFE8F5E9),
      price: '₹350',
      icon: Icons.spa_outlined,
      quantity: '500 g Packet',
    ),
  ];

  static final _completedOrders = [
    _OrderItem(
      id: '#AGR20240210',
      productName: 'Urea Fertilizer (45 kg)',
      date: '10 Feb 2026',
      status: 'Delivered',
      statusColor: const Color(0xFF2E7D32),
      statusBg: const Color(0xFFE8F5E9),
      price: '₹920',
      icon: Icons.eco_outlined,
      quantity: '3 Bags',
    ),
    _OrderItem(
      id: '#AGR20240195',
      productName: 'Mancozeb Fungicide',
      date: '28 Jan 2026',
      status: 'Delivered',
      statusColor: const Color(0xFF2E7D32),
      statusBg: const Color(0xFFE8F5E9),
      price: '₹460',
      icon: Icons.grass_outlined,
      quantity: '1 kg Pack',
    ),
  ];
}

// ─────────────────────────────────────────────
// ORDER LIST
// ─────────────────────────────────────────────
class _OrderList extends StatelessWidget {
  final List<_OrderItem> orders;
  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _OrderCard(order: orders[i]),
    );
  }
}

// ─────────────────────────────────────────────
// ORDER CARD
// ─────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final _OrderItem order;
  const _OrderCard({required this.order});

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
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(order.icon,
                    color: const Color(0xFF2E7D32), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.quantity}  ·  ${order.date}',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
              Text(
                order.price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: order.statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
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
// EMPTY STATE
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;
  const _EmptyState(
      {required this.icon,
      required this.message,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────
class _OrderItem {
  final String id;
  final String productName;
  final String date;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String price;
  final IconData icon;
  final String quantity;

  const _OrderItem({
    required this.id,
    required this.productName,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.price,
    required this.icon,
    required this.quantity,
  });
}