import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNumber;
  // const RegistrationScreen({super.key, this.phoneNumber = '+91 98765 43210'});
  const RegistrationScreen({super.key, this.phoneNumber = ''});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDistrict;
  String? _selectedBlock;
  String? _selectedVillage;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _districts = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Tiruchirappalli',
    'Salem',
    'Tirunelveli',
    'Erode',
    'Vellore',
    'Thoothukudi',
    'Dindigul',
  ];

  final List<String> _blocks = [
    'Block 1',
    'Block 2',
    'Block 3',
    'Block 4',
    'Block 5',
  ];

  final List<String> _villages = [
    'Village A',
    'Village B',
    'Village C',
    'Village D',
    'Village E',
  ];

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _selectedDistrict != null &&
      _selectedBlock != null &&
      _selectedVillage != null;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideController.forward();
    _fadeController.forward();

    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String phoneNumber = widget.phoneNumber.isNotEmpty
        ? widget.phoneNumber
        : (ModalRoute.of(context)?.settings.arguments as String? ?? '');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Image section ──
          SizedBox(
            height: size.height * 0.38,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/ocean_background.png',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.2),
                ),
                // Gradient fade
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: size.height * 0.12,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white],
                      ),
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: 48,
                  left: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/otp',
                        arguments: phoneNumber,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ),
                // Language toggle
                Positioned(
                  top: 48,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 16,
                          color: Color(0xFF2E7D32),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'தமிழ்',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // App title
                Positioned(
                  bottom: size.height * 0.07,
                  left: 24,
                  child: const Text(
                    'Uzhavar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── White form section ──
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            const Text(
                              'One-time\nRegistration',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                                height: 1.25,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    size: 14,
                                    color: Color(0xFF2E7D32),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'New User',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Fill in your details to get started',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Name field
                        _buildLabel('Full Name'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _nameController,
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                        ),

                        const SizedBox(height: 14),

                        // Mobile (pre-filled, disabled)
                        _buildLabel('Mobile Number'),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7F0),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF2E7D32).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: Color(0xFF2E7D32),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                phoneNumber, // ← was widget.phoneNumber
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.lock_outline_rounded,
                                size: 15,
                                color: Color(0xFF888888),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // District
                        _buildLabel('District'),
                        const SizedBox(height: 6),
                        _buildDropdown(
                          hint: 'Select your district',
                          icon: Icons.location_city_outlined,
                          value: _selectedDistrict,
                          items: _districts,
                          onChanged: (val) =>
                              setState(() => _selectedDistrict = val),
                        ),

                        const SizedBox(height: 14),

                        // Block
                        _buildLabel('Block'),
                        const SizedBox(height: 6),
                        _buildDropdown(
                          hint: 'Select your block',
                          icon: Icons.map_outlined,
                          value: _selectedBlock,
                          items: _blocks,
                          onChanged: _selectedDistrict != null
                              ? (val) => setState(() => _selectedBlock = val)
                              : null,
                          disabled: _selectedDistrict == null,
                        ),

                        const SizedBox(height: 14),

                        // Village
                        _buildLabel('Village'),
                        const SizedBox(height: 6),
                        _buildDropdown(
                          hint: 'Select your village',
                          icon: Icons.holiday_village_outlined,
                          value: _selectedVillage,
                          items: _villages,
                          onChanged: _selectedBlock != null
                              ? (val) => setState(() => _selectedVillage = val)
                              : null,
                          disabled: _selectedBlock == null,
                        ),

                        const SizedBox(height: 24),

                        // Submit button
                        GestureDetector(
                          onTap: _isFormValid
                              ? () => Navigator.pushNamed(context, '/menu')
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _isFormValid
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: _isFormValid
                                    ? Colors.white
                                    : const Color(0xFFAAAAAA),
                              ),
                              child: const Text('SUBMIT'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF444444),
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: controller.text.isNotEmpty
              ? const Color(0xFF2E7D32).withOpacity(0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFBBBBBB),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, size: 18, color: const Color(0xFF888888)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    bool disabled = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFFF0F0F0) : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value != null
              ? const Color(0xFF2E7D32).withOpacity(0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            size: 18,
            color: disabled ? const Color(0xFFCCCCCC) : const Color(0xFF888888),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
        ),
        hint: Text(
          hint,
          style: TextStyle(
            color: disabled ? const Color(0xFFCCCCCC) : const Color(0xFFBBBBBB),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: disabled ? const Color(0xFFCCCCCC) : const Color(0xFF888888),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(14),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
