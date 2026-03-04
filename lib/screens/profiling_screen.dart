import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Spec-exact colour palette ───────────────────────────────────────────────
const Color _kGreen       = Color(0xFF18A369);
const Color _kGreenDark   = Color(0xFF0D7E4E);
const Color _kBgGray      = Color(0xFFFAFAFA);
const Color _kDivider     = Color(0xFFE5E5E5);
const Color _kTextDark    = Color(0xFF171717);
const Color _kTextGray    = Color(0xFF737373);
const Color _kAlertBg     = Color(0xFFFFF8E1);
const Color _kAlertBorder = Color(0xFFFFE0B2);
const Color _kAlertOrange = Color(0xFFFF9800);

// ─── Screen ──────────────────────────────────────────────────────────────────
class ProfilingScreen extends StatefulWidget {
  const ProfilingScreen({super.key});

  @override
  State<ProfilingScreen> createState() => _ProfilingScreenState();
}

class _ProfilingScreenState extends State<ProfilingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _kGreen,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  void _onProfileTypeTap(String type) {
    // Placeholder for profile type selection
    // Can be extended to navigate to different profile screens
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $type')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Status bar
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

          // App bar
          Container(
            height: 64,
            color: _kGreen,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Profiling',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      'Profiling > Pending community profile updates',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: _kTextGray,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Text(
                      'Select profile type',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: _kTextDark,
                        letterSpacing: 0.15,
                        height: 32 / 24,
                      ),
                    ),
                  ),

                  // Alert banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _kAlertBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _kAlertBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _kAlertOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '50 Farmer group profile updates pending',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: _kAlertOrange,
                                letterSpacing: 0.25,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Profile type options
                  _ProfileTypeRow(
                    icon: Icons.location_on_outlined,
                    label: 'Communities',
                    onTap: () => _onProfileTypeTap('Communities'),
                  ),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: _kDivider,
                  ),

                  _ProfileTypeRow(
                    icon: Icons.agriculture_outlined,
                    label: 'Farmers',
                    onTap: () => _onProfileTypeTap('Farmers'),
                  ),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: _kDivider,
                  ),

                  _ProfileTypeRow(
                    icon: Icons.people_alt_outlined,
                    label: 'Farmer groups',
                    onTap: () => _onProfileTypeTap('Farmer groups'),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile type row ─────────────────────────────────────────────────────────
class _ProfileTypeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTypeRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Icon
            Icon(
              icon,
              size: 24,
              color: _kGreen,
            ),

            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: _kTextDark,
                  letterSpacing: 0.15,
                  height: 24 / 16,
                ),
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}
