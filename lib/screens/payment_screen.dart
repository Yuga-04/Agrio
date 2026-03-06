import 'package:flutter/material.dart';
import 'package:agrio/l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  final int totalAmount;
  final int itemCount;
  final int savings;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.itemCount,
    required this.savings,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

enum _PayState { select, confirming, success }

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMethod = 2;
  _PayState _payState = _PayState.select;
  bool _agreedToTerms = true;

  late AnimationController _successCtrl;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _successScale =
        CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);
    _successFade =
        CurvedAnimation(parent: _successCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() => _payState = _PayState.confirming);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _payState = _PayState.success);
    _successCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.settings.name == '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        child: switch (_payState) {
          _PayState.select => _SelectView(
              key: const ValueKey('select'),
              totalAmount: widget.totalAmount,
              itemCount: widget.itemCount,
              savings: widget.savings,
              selectedMethod: _selectedMethod,
              agreedToTerms: _agreedToTerms,
              onMethodChanged: (v) => setState(() => _selectedMethod = v),
              onTermsChanged: (v) =>
                  setState(() => _agreedToTerms = v ?? true),
              onPlaceOrder: _placeOrder,
            ),
          _PayState.confirming => _ConfirmingView(
              key: const ValueKey('confirming'),
              totalAmount: widget.totalAmount,
            ),
          _PayState.success => _SuccessView(
              key: const ValueKey('success'),
              totalAmount: widget.totalAmount,
              itemCount: widget.itemCount,
              savings: widget.savings,
              scaleAnim: _successScale,
              fadeAnim: _successFade,
            ),
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SELECT VIEW
// ─────────────────────────────────────────────
class _SelectView extends StatelessWidget {
  final int totalAmount, itemCount, savings, selectedMethod;
  final bool agreedToTerms;
  final ValueChanged<int> onMethodChanged;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onPlaceOrder;

  const _SelectView({
    super.key,
    required this.totalAmount,
    required this.itemCount,
    required this.savings,
    required this.selectedMethod,
    required this.agreedToTerms,
    required this.onMethodChanged,
    required this.onTermsChanged,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final s = AppLocalizations.of(context);

    return Column(
      children: [
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
              Expanded(
                child: Text(
                  'Checkout',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline,
                        color: Color(0xFF2E7D32), size: 13),
                    SizedBox(width: 4),
                    Text(
                      'Secure',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),

        Expanded(
          child: ListView(
            padding:
                EdgeInsets.fromLTRB(16, 14, 16, 16 + bottom),
            physics: const BouncingScrollPhysics(),
            children: [
              _OrderSummaryCard(
                  totalAmount: totalAmount,
                  itemCount: itemCount,
                  savings: savings),
              const SizedBox(height: 16),
              const _DeliveryAddressCard(),
              const SizedBox(height: 16),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              _PayMethodTile(
                icon: Icons.account_balance_wallet_outlined,
                iconBg: const Color(0xFFE8F0FE),
                iconColor: const Color(0xFF1A73E8),
                label: 'UPI',
                subtitle: 'GPay, PhonePe, Paytm',
                selected: selectedMethod == 0,
                badge: null,
                onTap: () => onMethodChanged(0),
              ),
              const SizedBox(height: 8),
              _PayMethodTile(
                icon: Icons.credit_card_outlined,
                iconBg: const Color(0xFFF3E5F5),
                iconColor: const Color(0xFF7B1FA2),
                label: 'Debit / Credit Card',
                subtitle: 'Visa, Mastercard, RuPay',
                selected: selectedMethod == 1,
                badge: null,
                onTap: () => onMethodChanged(1),
              ),
              const SizedBox(height: 8),
              _PayMethodTile(
                icon: Icons.payments_outlined,
                iconBg: const Color(0xFFFFF8E1),
                iconColor: const Color(0xFFFF8C00),
                label: 'Cash on Delivery',
                subtitle: 'Pay when your order arrives',
                selected: selectedMethod == 2,
                badge: 'Available',
                onTap: () => onMethodChanged(2),
              ),
              if (selectedMethod == 2) ...[
                const SizedBox(height: 10),
                const _CodInfoCard(),
              ],
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => onTermsChanged(!agreedToTerms),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: agreedToTerms
                            ? const Color(0xFF2E7D32)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: agreedToTerms
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFCCCCCC),
                          width: 1.8,
                        ),
                      ),
                      child: agreedToTerms
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 13)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'I agree to the Terms & Conditions and confirm my delivery address is correct.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
                top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
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
                    '₹$totalAmount',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'Total payable',
                    style: TextStyle(
                        fontSize: 10, color: Color(0xFF888888)),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: agreedToTerms ? onPlaceOrder : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 50,
                    decoration: BoxDecoration(
                      color: agreedToTerms
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFBDBDBD),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_shipping_outlined,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          s.placeOrder,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CONFIRMING VIEW
// ─────────────────────────────────────────────
class _ConfirmingView extends StatefulWidget {
  final int totalAmount;
  const _ConfirmingView({super.key, required this.totalAmount});

  @override
  State<_ConfirmingView> createState() => _ConfirmingViewState();
}

class _ConfirmingViewState extends State<_ConfirmingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotCtrl;

  @override
  void initState() {
    super.initState();
    _dotCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _dotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping_outlined,
                    color: Color(0xFF2E7D32), size: 42),
              ),
              const SizedBox(height: 24),
              const Text(
                'Placing your order...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '₹${widget.totalAmount} · Cash on Delivery',
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF888888)),
              ),
              const SizedBox(height: 28),
              AnimatedBuilder(
                animation: _dotCtrl,
                builder: (_, __) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final delay = i / 3;
                      final t =
                          ((_dotCtrl.value - delay + 1) % 1.0);
                      final scale = 0.6 +
                          0.4 *
                              (1 -
                                  (t * 2 - 1)
                                      .abs()
                                      .clamp(0.0, 1.0));
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            const Color(0xFFCCCCCC),
                            const Color(0xFF2E7D32),
                            scale,
                          ),
                          shape: BoxShape.circle,
                        ),
                        transform: Matrix4.identity()
                          ..scale(scale, scale),
                        transformAlignment: Alignment.center,
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SUCCESS VIEW
// ─────────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final int totalAmount, itemCount, savings;
  final Animation<double> scaleAnim, fadeAnim;

  const _SuccessView({
    super.key,
    required this.totalAmount,
    required this.itemCount,
    required this.savings,
    required this.scaleAnim,
    required this.fadeAnim,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final s = AppLocalizations.of(context);
    final orderId =
        '#AGR${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
          child: FadeTransition(
            opacity: fadeAnim,
            child: Column(
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: scaleAnim,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32)
                              .withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 92,
                        height: 92,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 50),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  s.orderPlaced,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  orderId,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    children: [
                      _ReceiptRow(
                        label: 'Items',
                        value:
                            '$itemCount item${itemCount > 1 ? 's' : ''}',
                      ),
                      const SizedBox(height: 10),
                      _ReceiptRow(
                          label: 'Amount to Pay',
                          value: '₹$totalAmount'),
                      const SizedBox(height: 10),
                      _ReceiptRow(
                          label: 'Payment',
                          value: 'Cash on Delivery'),
                      const SizedBox(height: 10),
                      _ReceiptRow(
                        label: 'Estimated Delivery',
                        value: '3 – 5 Business Days',
                        valueColor: const Color(0xFF2E7D32),
                      ),
                      if (savings > 0) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                              height: 1,
                              color: Color(0xFFEEEEEE)),
                        ),
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
                                  color: Color(0xFF2E7D32),
                                  size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'You saved ₹$savings on this order!',
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
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFFFFECB3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Color(0xFFFF8C00), size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Keep exact cash ready at the time of delivery.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A5500),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Text(
                  'Redirecting to home...',
                  style: TextStyle(
                      fontSize: 11, color: Color(0xFFAAAAAA)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
class _OrderSummaryCard extends StatelessWidget {
  final int totalAmount, itemCount, savings;
  const _OrderSummaryCard(
      {required this.totalAmount,
      required this.itemCount,
      required this.savings});

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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long_outlined,
                    color: Color(0xFF2E7D32), size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Order Summary',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$itemCount item${itemCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF666666))),
              Text(
                '₹$totalAmount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          if (savings > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.savings_outlined,
                      color: Color(0xFF2E7D32), size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'Saving ₹$savings on this order',
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

class _DeliveryAddressCard extends StatelessWidget {
  const _DeliveryAddressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on_outlined,
                color: Color(0xFF2E7D32), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2),
                Text(
                  'Survey No. 14, Theni Main Road',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A)),
                ),
                Text(
                  'Devaram, Theni – 625 531, Tamil Nadu',
                  style: TextStyle(
                      fontSize: 11, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: Color(0xFFCCCCCC), size: 20),
        ],
      ),
    );
  }
}

class _CodInfoCard extends StatelessWidget {
  const _CodInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFECB3)),
      ),
      child: const Column(
        children: [
          _CodPoint(
              icon: Icons.payments_outlined,
              text: 'Pay in cash when your order is delivered.'),
          SizedBox(height: 10),
          _CodPoint(
              icon: Icons.access_time_outlined,
              text: 'Expected delivery in 3–5 business days.'),
          SizedBox(height: 10),
          _CodPoint(
              icon: Icons.swap_horiz_outlined,
              text: 'Easy returns within 7 days of delivery.'),
        ],
      ),
    );
  }
}

class _CodPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  const _CodPoint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFFF8C00), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7A5500),
                  height: 1.4)),
        ),
      ],
    );
  }
}

class _PayMethodTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label, subtitle;
  final bool selected;
  final String? badge;
  final VoidCallback onTap;

  const _PayMethodTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF2E7D32)
                : const Color(0xFFEEEEEE),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF888888))),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? const Color(0xFF2E7D32)
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFCCCCCC),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check,
                      color: Colors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _ReceiptRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF888888))),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: valueColor ?? const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}