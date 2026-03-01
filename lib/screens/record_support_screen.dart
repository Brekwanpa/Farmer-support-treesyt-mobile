import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Spec-exact colour palette ───────────────────────────────────────────────
const Color _kGreen       = Color(0xFF18A369);
const Color _kGreenLight  = Color(0xFFE8F5EE);
const Color _kBgGray      = Color(0xFFFAFAFA);
const Color _kDivider     = Color(0xFFE5E5E5);
const Color _kTextPrimary = Color(0xFF171717);
const Color _kTextSec     = Color(0xFF737373);
const Color _kChevron     = Color(0xFF4F5E71);
const Color _kHomeBar     = Color(0xFF1D1B20);

// ─── Mock farmer list — replace with API lookup in production ─────────────────
const List<String> _kFarmers = [
  'Kofi Mensah',
  'Ama Asante',
  'Kweku Boateng',
  'Abena Owusu',
  'Yaw Darko',
  'Akua Frimpong',
  'Kwame Acheampong',
  'Adwoa Boateng',
  'Kojo Asante',
  'Efua Mensah',
];

// ─── Screen 2: Record Support ─────────────────────────────────────────────────
class RecordSupportScreen extends StatefulWidget {
  const RecordSupportScreen({super.key});

  @override
  State<RecordSupportScreen> createState() => _RecordSupportScreenState();
}

class _RecordSupportScreenState extends State<RecordSupportScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get _filtered =>
      _kFarmers.where((f) => f.toLowerCase().contains(_query)).toList();

  // Opens Screen 3 — farmer selection bottom sheet
  void _openSelectionSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _FarmerSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmers = _filtered;

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
            const _AppBar(title: 'Record support'),
            // §3 — White content (116 px onwards)
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: _SearchBar(controller: _searchCtrl),
                    ),
                    const Divider(height: 1, thickness: 1, color: _kDivider),
                    // Farmer list / empty state
                    Expanded(
                      child: farmers.isEmpty
                          ? const _EmptyState()
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: farmers.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                thickness: 1,
                                color: _kDivider,
                              ),
                              itemBuilder: (ctx, i) => _FarmerRow(
                                name: farmers[i],
                                onTap: () => _openSelectionSheet(ctx),
                              ),
                            ),
                    ),
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

// ─── Search bar ───────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: _kTextPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Search farmers…',
        hintStyle: const TextStyle(
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          color: _kTextSec,
        ),
        prefixIcon: const Icon(Icons.search, color: _kTextSec, size: 24),
        filled: true,
        fillColor: _kBgGray,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _kDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _kDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _kGreen, width: 1.5),
        ),
      ),
    );
  }
}

// ─── Farmer row (56 px, spec §3) ──────────────────────────────────────────────
class _FarmerRow extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _FarmerRow({required this.name, required this.onTap});

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
              CircleAvatar(
                radius: 18,
                backgroundColor: _kGreenLight,
                child: const Icon(Icons.person_outline, color: _kGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: _kTextPrimary,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: _kChevron, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty state (search returns nothing) ────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: _kGreenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off, color: _kGreen, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'No farmers found',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              color: _kTextSec,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different name',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: _kTextSec,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Screen 3: Farmer Selection Bottom Sheet ──────────────────────────────────
class _FarmerSelectionSheet extends StatefulWidget {
  const _FarmerSelectionSheet();

  @override
  State<_FarmerSelectionSheet> createState() => _FarmerSelectionSheetState();
}

class _FarmerSelectionSheetState extends State<_FarmerSelectionSheet> {
  final Set<String> _selected = {};

  void _toggle(String name) => setState(() {
        _selected.contains(name)
            ? _selected.remove(name)
            : _selected.add(name);
      });

  void _saveDetails() {
    // Stub — logs selected farmers and dismisses sheet
    debugPrint('[FarmerSupport] Save details — selected: ${_selected.toList()}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        color: Colors.white,
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (ctx, scrollController) {
            return Column(
              children: [
                // ── Drag pill / swipe handle ────────────────────────────────
                const _DragPill(),

                // ── Sheet header ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Select farmers',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            color: _kTextPrimary,
                          ),
                        ),
                      ),
                      if (_selected.isNotEmpty)
                        Text(
                          '${_selected.length} selected',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: _kGreen,
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: _kDivider),

                // ── Farmer rows with checkboxes ─────────────────────────────
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: _kFarmers.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: _kDivider,
                    ),
                    itemBuilder: (_, i) {
                      final name = _kFarmers[i];
                      return _CheckboxFarmerRow(
                        name: name,
                        checked: _selected.contains(name),
                        onTap: () => _toggle(name),
                      );
                    },
                  ),
                ),

                // ── Save details button ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saveDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save details',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Drag pill / swipe handle (spec: 28 px tall indicator) ───────────────────
class _DragPill extends StatelessWidget {
  const _DragPill();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 72,
        height: 4,
        decoration: BoxDecoration(
          color: _kDivider,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ─── Checkbox farmer row (56 px, spec §3) ────────────────────────────────────
class _CheckboxFarmerRow extends StatelessWidget {
  final String name;
  final bool checked;
  final VoidCallback onTap;

  const _CheckboxFarmerRow({
    required this.name,
    required this.checked,
    required this.onTap,
  });

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
              // Farmer name — Inter Regular 16px
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: _kTextPrimary,
                  ),
                ),
              ),
              // Animated checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: checked ? _kGreen : Colors.transparent,
                  border: Border.all(
                    color: checked ? _kGreen : _kTextSec,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: checked
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
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
