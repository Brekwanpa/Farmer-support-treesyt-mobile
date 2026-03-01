import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'record_support_screen.dart';
import 'recoveries_screen.dart';
import 'support_progress_screen.dart';

// ─── Spec-exact colour palette ───────────────────────────────────────────────
const Color _kGreen       = Color(0xFF18A369);
const Color _kBgGray      = Color(0xFFFAFAFA);
const Color _kDivider     = Color(0xFFE5E5E5);
const Color _kTextPrimary = Color(0xFF171717);
const Color _kTextSec     = Color(0xFF737373);
const Color _kChevron     = Color(0xFF4F5E71);
const Color _kHomeBar     = Color(0xFF1D1B20);

// ─── Menu item data ───────────────────────────────────────────────────────────
class _MenuEntry {
  final Widget icon;
  final String label;
  const _MenuEntry({required this.icon, required this.label});
}

// ─── Screen 1 ────────────────────────────────────────────────────────────────
class FarmerSupportScreen extends StatelessWidget {
  const FarmerSupportScreen({super.key});

  List<_MenuEntry> _buildMenu() => [
    // Record support — custom outline, 18×18 px, #737373
    _MenuEntry(
      icon: const Icon(Icons.mic_none, color: _kTextSec, size: 18),
      label: 'Record support',
    ),
    // Support Progress — safety-divider analogue, 24×24 px, #737373
    _MenuEntry(
      icon: const Icon(Icons.bar_chart_outlined, color: _kTextSec, size: 24),
      label: 'Support Progress',
    ),
    // Recoveries — arrow rotated 180°, 16×16 px, #737373
    _MenuEntry(
      icon: Transform.rotate(
        angle: math.pi,
        child: const Icon(Icons.arrow_forward, color: _kTextSec, size: 16),
      ),
      label: 'Recoveries',
    ),
  ];

  void _onTap(BuildContext context, int index) {
    final destinations = <Widget>[
      const RecordSupportScreen(),
      const SupportProgressScreen(),
      const RecoveriesScreen(),
    ];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destinations[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menu = _buildMenu();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _kGreen,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _kGreen,
        body: Column(
          children: [
            // §1 — Status bar (0–52 px)
            const _FakeStatusBar(),
            // §2 — Top app bar (52–116 px)
            const _AppBar(title: 'Farmer support'),
            // §3 — White content (116 px onwards)
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < menu.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, thickness: 1, color: _kDivider),
                      _MenuItemRow(
                        entry: menu[i],
                        onTap: () => _onTap(context, i),
                      ),
                    ],
                    const Spacer(),
                  ],
                ),
              ),
            ),
            // §4 — Bottom indicator (28 px)
            const _BottomIndicator(),
          ],
        ),
      ),
    );
  }
}

// ─── Menu item row (56 px, spec §3) ──────────────────────────────────────────
class _MenuItemRow extends StatelessWidget {
  final _MenuEntry entry;
  final VoidCallback onTap;

  const _MenuItemRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Icon container — 40×40 px (spec)
              SizedBox(
                width: 40,
                height: 40,
                child: Center(child: entry.icon),
              ),
              const SizedBox(width: 12),
              // Label — Inter Regular 16px #171717
              Expanded(
                child: Text(
                  entry.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: _kTextPrimary,
                  ),
                ),
              ),
              // Chevron — 24×24 container, glyph #4F5E71
              const SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: Icon(Icons.chevron_right, color: _kChevron, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Fake status bar (52 px) ──────────────────────────────────────────────────
class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: _kGreen,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            '9:30',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.14,
            ),
          ),
          const Spacer(),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          const Icon(Icons.wifi, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          const Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          const Icon(Icons.battery_full, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}

// ─── Top app bar (64 px) ─────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final String title;
  const _AppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: _kGreen,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              padding: const EdgeInsets.all(8),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ─── Bottom indicator (28 px) ─────────────────────────────────────────────────
class _BottomIndicator extends StatelessWidget {
  const _BottomIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: _kBgGray,
      alignment: Alignment.center,
      child: Container(
        width: 72,
        height: 10,
        decoration: BoxDecoration(
          color: _kHomeBar,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
