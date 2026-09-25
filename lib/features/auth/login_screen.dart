import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum _MonitorRole { doctor, caregiver }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Visual-only selector shown in the "Who is monitoring?" panel.
  // This does NOT affect Firebase Authentication or the Firestore role
  // lookup on the dashboard — it's purely a UI affordance matching the
  // reference design. Real role comes from users/{uid}.role in Firestore.
  _MonitorRole _selectedRole = _MonitorRole.doctor;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // AuthGate handles navigation to the dashboard automatically.
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = switch (e.code) {
          'invalid-email' => 'That email address looks invalid.',
          'invalid-credential' => 'Incorrect email or password.',
          'user-disabled' => 'This account has been disabled.',
          _ => 'Sign-in failed. Please try again.',
        };
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF22D3EE);
    const deepBlue = Color(0xFF1D4ED8);

    return Scaffold(
      body: Stack(
        children: [
          // ---- Background: new premium medical reference image.
          // Hologram figure, icon badges, and ECG waveform are now part
          // of this image, so the equivalent custom-drawn widgets that
          // used to sit on top have been removed to avoid duplicates.
          Positioned.fill(
            child: Image.asset(
              'assets/images/paracare_medical_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Light blue-tinted overlay for text legibility. Reduced from
          // the previous pure-white gradient — this new background is
          // already pale, so a strong white wash would erase the
          // hologram, icon badges, and ECG line baked into the image.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFEFF6FF).withOpacity(0.18),
                    const Color(0xFFEFF6FF).withOpacity(0.38),
                  ],
                ),
              ),
            ),
          ),

          // ---- Foreground content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Branding: logo + name + tagline.
                  // (Hologram mark removed — the reference image already
                  // shows the hologram figure in the upper-right.)
                  Row(
                    children: [
                      _brandMark(cyan, deepBlue),
                      const SizedBox(width: 10),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                          children: [
                            TextSpan(
                              text: 'Para',
                              style: TextStyle(color: Color(0xFF0F172A)),
                            ),
                            TextSpan(
                              text: 'Care',
                              style: TextStyle(color: deepBlue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Smart Vital Fusion & Real-Time\n'
                    'Emergency Intervention',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF475569),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Welcome heading
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                      children: [
                        TextSpan(text: 'Welcome to '),
                        TextSpan(
                          text: 'ParaCare',
                          style: TextStyle(color: deepBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Because every vital sign matters.',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Panel 1: "Who is monitoring?" (visual only)
                  _GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _iconBadge(Icons.person_outline, deepBlue),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Who is monitoring?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.5,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Select your role to continue',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _RoleCard(
                                icon: Icons.medical_services_outlined,
                                title: 'Doctor',
                                subtitle: 'Monitor assigned patients',
                                selected:
                                    _selectedRole == _MonitorRole.doctor,
                                accent: deepBlue,
                                onTap: () => setState(
                                  () => _selectedRole = _MonitorRole.doctor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _RoleCard(
                                icon: Icons.favorite_border,
                                title: 'Caregiver',
                                subtitle: "View your loved one's status",
                                selected:
                                    _selectedRole == _MonitorRole.caregiver,
                                accent: deepBlue,
                                onTap: () => setState(
                                  () =>
                                      _selectedRole = _MonitorRole.caregiver,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Panel 2: Secure login (real Firebase Auth form)
                  _GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _iconBadge(Icons.lock_outline, deepBlue),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Secure Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.5,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Enter your ParaCare account details',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _fieldDecoration(
                            label: 'Email',
                            icon: Icons.mail_outline,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: _fieldDecoration(
                            label: 'Password',
                            icon: Icons.key_outlined,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                colors: [deepBlue, cyan],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cyan.withOpacity(0.45),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _isLoading ? null : _signIn,
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Enter Securely',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15.5,
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
                  ),
                  const SizedBox(height: 18),

                  // Security indicators row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _securityBadge(Icons.verified_user_outlined, 'Secure'),
                      _securityBadge(
                        Icons.enhanced_encryption_outlined,
                        'Encrypted',
                      ),
                      _securityBadge(
                        Icons.schedule_outlined,
                        '24/7 Monitoring',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Footer tagline.
                  // (Custom ECG painter removed — the reference image
                  // already includes a waveform near the bottom.)
                  const Center(
                    child: Text(
                      'Always Watching, Always Caring',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        fontStyle: FontStyle.italic,
                      ),
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

  Widget _brandMark(Color cyan, Color deepBlue) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [deepBlue, cyan]),
        boxShadow: [
          BoxShadow(color: cyan.withOpacity(0.5), blurRadius: 12),
        ],
      ),
      child: const Icon(Icons.favorite, color: Colors.white, size: 22),
    );
  }

  Widget _iconBadge(IconData icon, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _securityBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1D4ED8)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.72),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFBFDBFE).withOpacity(0.9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFBFDBFE).withOpacity(0.9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 1.6),
      ),
    );
  }
}

/// Translucent glassmorphism panel used for both sections of the form.
class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.58),
            border: Border.all(color: const Color(0xFFDCEAFE).withOpacity(0.85)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22D3EE).withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? accent.withOpacity(0.08)
              : Colors.white.withOpacity(0.45),
          border: Border.all(
            color: selected
                ? accent.withOpacity(0.6)
                : const Color(0xFFDCEAFE).withOpacity(0.85),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accent, size: 22),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? accent : const Color(0xFFCBD5E1),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}