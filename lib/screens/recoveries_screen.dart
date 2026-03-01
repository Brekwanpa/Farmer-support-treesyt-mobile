import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color _kGreen   = Color(0xFF18A369);
const Color _kBgGray  = Color(0xFFFAFAFA);
const Color _kHomeBar = Color(0xFF1D1B20);
const Color _kTextSec = Color(0xFF737373);

/// Stub screen — wire up full implementation in a future sprint.
class RecoveriesScreen extends StatelessWidget {
  const RecoveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _kGreen,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _kGreen,
        body: Column(
          children: [
            // Status bar (52 px)
            Container(
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
                  const Icon(Icons.signal_cellular_4_bar,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Icon(Icons.battery_full, color: Colors.white, size: 16),
                ],
              ),
            ),
            // App bar (64 px)
            Container(
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
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 24),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Recoveries',
                      style: TextStyle(
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
            ),
            // Placeholder content
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5EE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.undo, color: _kGreen, size: 40),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Recoveries',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: _kTextSec,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Coming soon',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: _kTextSec,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom indicator (28 px)
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
