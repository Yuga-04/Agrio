import 'package:flutter/material.dart';
import 'package:agrio/l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<_CartItem> _items = [
    _CartItem(
      id: 1,
      productName: 'NPK Fertilizer (50 kg)',
      brand: 'Iffco',
      price: 620,
      quantity: 2,
      unit: 'Bag',
      icon: Icons.science_outlined,
      tagLabel: 'Best Seller',
      tagColor: const Color(0xFF1565C0),
      tagBg: const Color(0xFFE3F2FD),
    ),
    _CartItem(
      id: 2,
      productName: 'Chlorpyrifos Insecticide',
      brand: 'Bayer CropScience',
      price: 340,
      quantity: 1,
      unit: 'Bottle',
      icon: Icons.bug_report_outlined,
      tagLabel: '10% Off',
      tagColor: const Color(0xFFE65100),
      tagBg: const Color(0xFFFFF3E0),
    ),
    _CartItem(
      id: 3,
      productName: 'Hybrid Tomato Seeds',
      brand: 'Syngenta',
      price: 175,
      quantity: 2,
      unit: 'Packet',
      icon: Icons.spa_outlined,
      tagLabel: 'New',
      tagColor: const Color(0xFF2E7D32),
      tagBg: const Color(0xFFE8F5E9),
    ),
  ];

  bool _couponApplied = false;
  final _couponController = TextEditingController();
  String _couponError = '';

  int get _subtotal =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  int get _discount => _couponApplied ? (_subtotal * 0.10).round() : 0;
  int get _delivery => _subtotal >= 1500 ? 0 : 60;
  int get _total => _subtotal - _discount + _delivery;

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'AGRIO10') {
      setState(() {
        _couponApplied = true;
        _couponError = '';
      });
    } else {
      setState(() {
        _couponApplied = false;
        _couponError = 'Invalid coupon code';
      });
    }
  }

  void _removeItem(int id) =>
      setState(() => _items.removeWhere((e) => e.id == id));

  void _changeQty(int id, int delta) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == id);
      if (idx == -1) return;
      final newQty = _items[idx].quantity + delta;
      if (newQty <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx] = _items[idx].copyWith(quantity: newQty);
      }
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final s = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          // ── App Bar ──
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(4, top + 6, 16, 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Color(0xFF1A1A1A), size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    s.myCart,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                if (_items.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _items.clear()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3F3),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: const Color(0xFFFFCDD2)),
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          color: Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // ── Body ──
          Expanded(
            child: _items.isEmpty
                ? _EmptyCart(
                    onShopTap: () => Navigator.of(context).pop(),
                    s: s,
                  )
                : ListView(
                    padding:
                        const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '${_items.length} item${_items.length > 1 ? 's' : ''} in cart',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ..._items.map((item) => _CartCard(
                            item: item,
                            onRemove: () => _removeItem(item.id),
                            onQtyChange: (d) => _changeQty(item.id, d),
                          )),
                      const SizedBox(height: 14),
                      if (_delivery > 0)
                        _FreeDeliveryBanner(remaining: 1500 - _subtotal),
                      if (_delivery == 0) _FreeDeliveryUnlocked(),
                      const SizedBox(height: 14),
                      _CouponBox(
                        controller: _couponController,
                        applied: _couponApplied,
                        error: _couponError,
                        onApply: _applyCoupon,
                        onRemove: () => setState(() {
                          _couponApplied = false;
                          _couponController.clear();
                          _couponError = '';
                        }),
                      ),
                      const SizedBox(height: 14),
                      _PriceSummary(
                        subtotal: _subtotal,
                        discount: _discount,
                        delivery: _delivery,
                        total: _total,
                        couponApplied: _couponApplied,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
          ),

          // ── Checkout bar ──
          if (_items.isNotEmpty)
            Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                    top: BorderSide(
                        color: Color(0xFFEEEEEE), width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹$_total',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (_discount > 0)
                        Text(
                          'You save ₹$_discount',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/payment',
                          arguments: {
                            'total': _total,
                            'itemCount': _items.length,
                            'savings':
                                _discount + (_delivery == 0 ? 60 : 0),
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              s.checkout,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 16),
                          ],
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

// ─────────────────────────────────────────────
// CART CARD
// ─────────────────────────────────────────────
class _CartCard extends StatelessWidget {
  final _CartItem item;
  final VoidCallback onRemove;
  final void Function(int delta) onQtyChange;

  const _CartCard({
    required this.item,
    required this.onRemove,
    required this.onQtyChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon,
                    color: const Color(0xFF2E7D32), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.tagBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.tagLabel,
                        style: TextStyle(
                          color: item.tagColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.brand,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3F3),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: const Icon(Icons.close,
                      color: Color(0xFFD32F2F), size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${item.price} / ${item.unit}',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF888888)),
                  ),
                  Text(
                    '₹${item.price * item.quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFF2E7D32)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QtyBtn(
                      icon: Icons.remove,
                      onTap: () => onQtyChange(-1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9),
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 34,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    _QtyBtn(
                      icon: Icons.add,
                      onTap: () => onQtyChange(1),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(9),
                        bottomRight: Radius.circular(9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  const _QtyBtn(
      {required this.icon,
      required this.onTap,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32).withOpacity(0.07),
          borderRadius: borderRadius,
        ),
        child: Icon(icon, color: const Color(0xFF2E7D32), size: 16),
      ),
    );
  }
}

class _FreeDeliveryBanner extends StatelessWidget {
  final int remaining;
  const _FreeDeliveryBanner({required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFECB3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              color: Color(0xFFFF8C00), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF555555)),
                children: [
                  const TextSpan(text: 'Add '),
                  TextSpan(
                    text: '₹$remaining more',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE65100),
                    ),
                  ),
                  const TextSpan(text: ' to unlock '),
                  const TextSpan(
                    text: 'Free Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
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

class _FreeDeliveryUnlocked extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping_outlined,
              color: Color(0xFF2E7D32), size: 18),
          SizedBox(width: 8),
          Text(
            "🎉 You've unlocked Free Delivery!",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponBox extends StatelessWidget {
  final TextEditingController controller;
  final bool applied;
  final String error;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const _CouponBox({
    required this.controller,
    required this.applied,
    required this.error,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: applied
              ? const Color(0xFFA5D6A7)
              : const Color(0xFFEEEEEE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_offer_outlined,
                  color: Color(0xFF2E7D32), size: 16),
              SizedBox(width: 6),
              Text(
                'Apply Coupon',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: applied
                          ? const Color(0xFF2E7D32)
                          : error.isNotEmpty
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFFEEEEEE),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          enabled: !applied,
                          textCapitalization:
                              TextCapitalization.characters,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 1,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter coupon code',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFAAAAAA),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (applied)
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.check_circle,
                              color: Color(0xFF2E7D32), size: 18),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: applied ? onRemove : onApply,
                child: Container(
                  height: 42,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: applied
                        ? const Color(0xFFFFF3F3)
                        : const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: applied
                          ? const Color(0xFFFFCDD2)
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      applied ? 'Remove' : 'Apply',
                      style: TextStyle(
                        color: applied
                            ? const Color(0xFFD32F2F)
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (error.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFD32F2F), size: 13),
                const SizedBox(width: 4),
                Text(error,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFFD32F2F))),
              ],
            ),
          ],
          if (applied) ...[
            const SizedBox(height: 6),
            const Row(
              children: [
                Icon(Icons.check_circle_outline,
                    color: Color(0xFF2E7D32), size: 13),
                SizedBox(width: 4),
                Text(
                  'Coupon applied! 10% discount added.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final int subtotal, discount, delivery, total;
  final bool couponApplied;
  const _PriceSummary({
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.total,
    required this.couponApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Subtotal', value: '₹$subtotal'),
          if (couponApplied)
            _SummaryRow(
              label: 'Coupon Discount (10%)',
              value: '- ₹$discount',
              valueColor: const Color(0xFF2E7D32),
            ),
          _SummaryRow(
            label: 'Delivery Charges',
            value: delivery == 0 ? 'FREE' : '₹$delivery',
            valueColor:
                delivery == 0 ? const Color(0xFF2E7D32) : null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A)),
              ),
              Text(
                '₹$total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          if (couponApplied || delivery == 0) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_outlined,
                      color: Color(0xFF2E7D32), size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'You are saving ₹${discount + (delivery == 0 ? 60 : 0)} on this order!',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _SummaryRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF666666))),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback onShopTap;
  final AppLocalizations s;
  const _EmptyCart({required this.onShopTap, required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                color: Color(0xFF2E7D32), size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            s.cartEmpty,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add products to start your order',
            style:
                TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onShopTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                s.shopNow,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────
class _CartItem {
  final int id;
  final String productName;
  final String brand;
  final int price;
  final int quantity;
  final String unit;
  final IconData icon;
  final String tagLabel;
  final Color tagColor;
  final Color tagBg;

  const _CartItem({
    required this.id,
    required this.productName,
    required this.brand,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.icon,
    required this.tagLabel,
    required this.tagColor,
    required this.tagBg,
  });

  _CartItem copyWith({int? quantity}) => _CartItem(
        id: id,
        productName: productName,
        brand: brand,
        price: price,
        quantity: quantity ?? this.quantity,
        unit: unit,
        icon: icon,
        tagLabel: tagLabel,
        tagColor: tagColor,
        tagBg: tagBg,
      );
}