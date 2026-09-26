import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Top header for the ParaCare dashboard: brand mark, tagline, notification
/// bell, and the signed-in doctor/caregiver's profile panel — styled to
/// match the login screen's blue/cyan medical glassmorphism.
///
/// The profile photo picked here is LOCAL-ONLY for now: it lives in this
/// widget's state for the current session and is not uploaded or persisted.
/// Firebase Storage persistence (upload + save photoUrl to Firestore) is a
/// separate later step, once Storage is enabled on a Blaze plan.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.displayName,
    required this.role,
    required this.onLogout,
  });

  final String displayName;
  final String role;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF22D3EE);
    const deepBlue = Color(0xFF1D4ED8);

    final roleLabel =
        role.isEmpty ? 'Unknown' : role[0].toUpperCase() + role.substring(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _brandMark(cyan, deepBlue),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 22,
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
                  const SizedBox(height: 2),
                  const Text(
                    'Smart Vital Fusion & Real-Time\nEmergency Intervention',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF475569),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _bellButton(deepBlue),
          ],
        ),
        const SizedBox(height: 14),
        _ProfilePanel(
          displayName: displayName,
          roleLabel: roleLabel,
          accent: deepBlue,
          onLogout: onLogout,
        ),
      ],
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

  Widget _bellButton(Color deepBlue) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.7),
        border: Border.all(color: const Color(0xFFDCEAFE)),
      ),
      child: Icon(Icons.notifications_none, color: deepBlue, size: 20),
    );
  }
}

class _ProfilePanel extends StatefulWidget {
  const _ProfilePanel({
    required this.displayName,
    required this.roleLabel,
    required this.accent,
    required this.onLogout,
  });

  final String displayName;
  final String roleLabel;
  final Color accent;
  final VoidCallback onLogout;

  @override
  State<_ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<_ProfilePanel> {
  final _picker = ImagePicker();

  // Session-only. Not uploaded or persisted — resets on app restart.
  // Firebase Storage persistence is added in a later step.
  File? _localPhoto;
  bool _isPicking = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _localPhoto = File(picked.path));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open image picker.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.6),
        border: Border.all(color: const Color(0xFFDCEAFE).withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22D3EE).withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _avatarWithBadge(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  widget.roleLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: widget.accent, size: 20),
            tooltip: 'Sign out',
            onPressed: widget.onLogout,
          ),
        ],
      ),
    );
  }

  Widget _avatarWithBadge() {
    return GestureDetector(
      onTap: _showPickerSheet,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: widget.accent.withOpacity(0.12),
            backgroundImage: _localPhoto != null
                ? FileImage(_localPhoto!)
                : null,
            child: _localPhoto == null
                ? Icon(Icons.person, color: widget.accent, size: 24)
                : null,
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.accent,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: _isPicking
                  ? const Padding(
                      padding: EdgeInsets.all(3),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      size: 11,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}