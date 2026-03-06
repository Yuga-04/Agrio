import 'package:flutter/material.dart';
import 'package:agrio/l10n/app_localizations.dart';
import 'app_drawer.dart';
import 'order_screen.dart';
import 'kisan_vani_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, this.userName = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);

    final bodies = [
      _HomeBody(
        onAvatarTap: () => _scaffoldKey.currentState?.openDrawer(),
        userName: widget.userName,
      ),
      const OrderScreen(),
      const KisanVaniScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: const AppDrawer(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: const Color(0xFF888888),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: s.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              label: s.orders,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.campaign_outlined),
              activeIcon: const Icon(Icons.campaign),
              label: s.kisanVani,
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: bodies),
    );
  }
}

// ─────────────────────────────────────────────
// HOME BODY
// ─────────────────────────────────────────────
class _HomeBody extends StatelessWidget {
  final VoidCallback onAvatarTap;
  final String userName;
  const _HomeBody({required this.onAvatarTap, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopBar(onAvatarTap: onAvatarTap, userName: userName),
          const SizedBox(height: 20),
          const _SearchBar(),
          const SizedBox(height: 24),
          const _CategoryRow(),
          const SizedBox(height: 24),
          const _ToolsAndServices(),
          const SizedBox(height: 24),
          const _MandiPriceSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback onAvatarTap;
  final String userName;
  const _TopBar({required this.onAvatarTap, required this.userName});

  static const int _unreadCount = 3;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final displayName = userName.isNotEmpty ? userName : 'Farmer';
    final s = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.10),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF2E7D32),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.goodMorning,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          // Coins chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.monetization_on,
                    color: Color(0xFFFF8C00), size: 15),
                SizedBox(width: 4),
                Text(
                  '50',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Notification bell
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/notification'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const _IconBtn(icon: Icons.notifications_outlined),
                if (_unreadCount > 0)
                  Positioned(
                    top: 2,
                    right: 4,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF8C00),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Cart
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const _IconBtn(icon: Icons.shopping_cart_outlined),
                if (_unreadCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF8C00),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _unreadCount > 9 ? '9+' : '$_unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  const _IconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Icon(icon, color: const Color(0xFF444444), size: 18),
    );
  }
}

// ─────────────────────────────────────────────
// SEARCH BAR
// ─────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: Color(0xFF888888), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                decoration: InputDecoration(
                  hintText: s.searchHint,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFAAAAAA),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CATEGORY ROW
// ─────────────────────────────────────────────
class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  static const _categories = [
    {'label': 'Offers', 'icon': Icons.local_offer_outlined},
    {'label': 'Mango', 'icon': Icons.eco_outlined},
    {'label': 'Insecticides', 'icon': Icons.bug_report_outlined},
    {'label': 'Nutrients', 'icon': Icons.science_outlined},
    {'label': 'Fungicides', 'icon': Icons.grass_outlined},
    {'label': 'Seeds', 'icon': Icons.spa_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            s.categories,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final cat = _categories[i];
              return Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF2E7D32).withOpacity(0.15),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: const Color(0xFF2E7D32),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['label'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF444444),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// TOOLS & SERVICES
// ─────────────────────────────────────────────
class _ToolsAndServices extends StatelessWidget {
  const _ToolsAndServices();

  static const _tools = [
    {'label': 'Verify\nProduct', 'icon': Icons.qr_code_scanner, 'isNew': true},
    {'label': 'Weather', 'icon': Icons.cloud_outlined, 'isNew': false},
    {'label': 'Mandi\nPrice', 'icon': Icons.trending_up, 'isNew': false},
    {'label': 'Crop\nCare', 'icon': Icons.eco_outlined, 'isNew': false},
    {'label': 'Fertilizer\nCalc', 'icon': Icons.calculate_outlined, 'isNew': false},
    {'label': 'Protection', 'icon': Icons.shield_outlined, 'isNew': false},
    {'label': 'Bazaar', 'icon': Icons.storefront_outlined, 'isNew': false},
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.toolsServices,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            s.smartSolutions,
            style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tools.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, i) {
              final tool = _tools[i];
              final isNew = tool['isNew'] as bool;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFEEEEEE),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          tool['icon'] as IconData,
                          color: const Color(0xFF2E7D32),
                          size: 26,
                        ),
                      ),
                      if (isNew)
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'New',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tool['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF444444),
                      height: 1.3,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MANDI PRICE SECTION
// ─────────────────────────────────────────────
class _MandiPriceSection extends StatelessWidget {
  const _MandiPriceSection();

  static const _prices = [
    {
      'name': 'Brinjal',
      'variety': 'Round',
      'date': '1 Mar 2026',
      'market': 'Devaram (Uzhavar Sandhai) APMC, Theni',
      'price': '₹2,400',
      'icon': Icons.egg_alt_outlined,
    },
    {
      'name': 'Tomato',
      'variety': 'Hybrid',
      'date': '1 Mar 2026',
      'market': 'Koyambedu APMC, Chennai',
      'price': '₹1,800',
      'icon': Icons.circle_outlined,
    },
    {
      'name': 'Onion',
      'variety': 'Red',
      'date': '1 Mar 2026',
      'market': 'Madurai APMC, Madurai',
      'price': '₹3,200',
      'icon': Icons.lens_blur,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.mandiPrice,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    s.livePrices,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF888888)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  s.viewAll,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 152,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: _prices.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final item = _prices[i];
              return Container(
                width: 195,
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
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2E7D32).withOpacity(0.07),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: const Color(0xFF2E7D32),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                '${item['variety']}  ·  ${item['date']}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            item['market'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      item['price'] as String,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}