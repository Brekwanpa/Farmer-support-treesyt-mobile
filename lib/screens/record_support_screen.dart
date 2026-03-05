import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'farmer_selection_screen.dart';
import 'saved_group_details_screen.dart';

// ─── Colours (spec-exact) ─────────────────────────────────────────────────────
const Color _kGreen       = Color(0xFF18A369);
const Color _kGreenLight  = Color(0xFFE8F5F1);  // community tag background
const Color _kDivider     = Color(0xFFE5E5E5);
const Color _kHomeBar     = Color(0xFF1D1B20);

// Status colours
const Color _kStatusGreen  = Color(0xFF18A369);
const Color _kStatusOrange = Color(0xFFF59E0B);
const Color _kStatusRed    = Color(0xFFEF4444);
const Color _kStatusGray   = Color(0xFF9CA3AF);

// ─── Group status enum ────────────────────────────────────────────────────────
enum _Status { submitted, pending, incomplete, processed }

extension _StatusX on _Status {
  Color get color => switch (this) {
    _Status.submitted  => _kStatusGreen,
    _Status.pending    => _kStatusOrange,
    _Status.incomplete => _kStatusRed,
    _Status.processed  => _kStatusGray,
  };

  String get label => switch (this) {
    _Status.submitted  => 'Request submitted',
    _Status.pending    => 'Tap to record request',
    _Status.incomplete => 'Tap to complete request',
    _Status.processed  => 'Processed',
  };
}

// ─── Data model ───────────────────────────────────────────────────────────────
class _Group {
  final String name;
  final String type;
  final _Status status;
  final String community;
  final bool hasAlert;

  const _Group({
    required this.name,
    required this.type,
    required this.status,
    required this.community,
    this.hasAlert = false,
  });
}

const List<_Group> _kGroups = [
  _Group(name: 'Northern Star Farmers',      type: 'VSLA Group',    status: _Status.submitted, community: 'Achubunyou', hasAlert: true),
  _Group(name: 'Jirapa Fields Cooperative',  type: 'VSLA Group',    status: _Status.pending, community: 'Baali', hasAlert: true),
  _Group(name: 'Afari simpa',                type: 'Farmer Group',  status: _Status.pending, community: 'Baali Kene'),
  _Group(name: 'Tumu Prosper Farmers Guild', type: 'Farmer Group',  status: _Status.incomplete, community: 'Bakayiri'),
  _Group(name: 'Northern Star Farmers',      type: 'VSLA Group',    status: _Status.submitted, community: 'Blema'),
  _Group(name: 'Unity Fields Network',       type: 'VSLA Group',    status: _Status.processed, community: 'Achubunyou'),
  _Group(name: 'Tumu Prosper Farmers Guild', type: 'Farmer Group',  status: _Status.incomplete, community: 'Chirag'),
  _Group(name: 'Afari simpa',                type: 'Farmer Group',  status: _Status.pending, community: 'Daffiama'),
  _Group(name: 'Bawku Farmers Association',  type: 'Farmer Group',  status: _Status.submitted, community: 'Achubunyou'),
];

const List<String> _kCommunities = [
  'Achubunyou',
  'Baali',
  'Baali Kene',
  'Bakayiri',
  'Blema',
  'Chirag',
  'Daffiama',
];

// ─── Screen ───────────────────────────────────────────────────────────────────
class RecordSupportScreen extends StatefulWidget {
  final int year;

  const RecordSupportScreen({super.key, required this.year});

  @override
  State<RecordSupportScreen> createState() => _RecordSupportScreenState();
}

class _RecordSupportScreenState extends State<RecordSupportScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _selectedCommunity = 'All communities';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Group> get _filtered {
    final query = _query.toLowerCase();
    final communities = _selectedCommunity == 'All communities'
        ? _kCommunities
        : [_selectedCommunity];

    return _kGroups
        .where(
          (g) =>
              communities.contains(g.community) &&
              (g.name.toLowerCase().contains(query) ||
                  g.type.toLowerCase().contains(query)),
        )
        .toList();
  }

  void _openGroupFarmers(BuildContext ctx, _Group group) {
    if (group.hasAlert) {
      _showUpdateDetailsModal(ctx, group);
    } else {
      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (_) => FarmerSelectionScreen(groupName: group.name, year: widget.year),
        ),
      );
    }
  }

  void _showUpdateDetailsModal(BuildContext ctx, _Group group) {
    showDialog(
      context: ctx,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Alert icon
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.info,
                      color: Color(0xFFC62828),
                      size: 32,
                    ),
                  ),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Update group details',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                    letterSpacing: 0.15,
                    height: 28 / 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'This group has been flagged due to incomplete or incorrect data.\nKindly update group data to continue',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF666666),
                    letterSpacing: 0.25,
                    height: 20 / 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Update details button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => SavedGroupDetailsScreen(
                            groupName: group.name,
                            selectedFarmers: [],
                            totalFarmers: 0,
                            year: widget.year,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Update details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 24 / 16,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _openFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _FilterModal(
        selectedCommunity: _selectedCommunity,
        onCommunitySelected: (community) {
          Navigator.pop(ctx);
          setState(() => _selectedCommunity = community);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _filtered;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _kGreen,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _kGreen,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // §1 Status bar · 52 px
            const _StatusBar(),

            // §2 Top app bar · 64 px
            const _TopAppBar(),

            // §3 White content area
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Non-scrollable header block ─────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // §4 Header text
                          const Text(
                            'Select group to record needs',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black,
                              letterSpacing: 0.1,
                              height: 20 / 14,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // §5 Filters button (left-aligned, inline)
                          GestureDetector(
                            onTap: () => _openFilterModal(context),
                            child: const _FiltersButton(),
                          ),

                          // §6 Community tag (16 px top + bottom margins)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: _CommunityTag(community: _selectedCommunity),
                          ),

                          // §7 Search bar
                          _GroupSearchBar(controller: _searchCtrl),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // §8 Scrollable farmer groups list
                    Expanded(
                      child: groups.isEmpty
                          ? const _EmptyState()
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: groups.length,
                              itemBuilder: (ctx, i) => _GroupRow(
                                group: groups[i],
                                onTap: () => _openGroupFarmers(ctx, groups[i]),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // §10 Bottom indicator · 28 px
            const _BottomIndicator(),
          ],
        ),
      ),
    );
  }
}

// ─── §5 Filters button ────────────────────────────────────────────────────────
class _FiltersButton extends StatelessWidget {
  const _FiltersButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filter/sliders icon — Icons.tune matches the 3-line-with-dot spec
          const Icon(Icons.tune, color: _kGreen, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Filters',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: _kGreen,
              height: 20 / 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── §6 Community tag pill ────────────────────────────────────────────────────
class _CommunityTag extends StatelessWidget {
  final String community;

  const _CommunityTag({required this.community});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _kGreenLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        community == 'All communities'
            ? 'All communities'
            : 'Community: $community',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: _kGreen,
          height: 20 / 14,
        ),
      ),
    );
  }
}

// ─── §7 Search bar ────────────────────────────────────────────────────────────
class _GroupSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _GroupSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black,
          height: 20 / 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search group',
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF888888),
            height: 20 / 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF888888),
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 48,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _kGreen, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─── §8 Farmer group list row ─────────────────────────────────────────────────
class _GroupRow extends StatelessWidget {
  final _Group group;
  final VoidCallback onTap;

  const _GroupRow({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _kDivider, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: name + type + status (flex 1)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group name — Inter Medium 16 px
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 0.15,
                      height: 24 / 16,
                    ),
                  ),

                  // Group type — Inter Regular 14 px #737373
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      group.type,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF737373),
                        letterSpacing: 0.25,
                        height: 20 / 14,
                      ),
                    ),
                  ),

                  // Status text with alert indicator (if applicable)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (group.hasAlert)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                            ),
                          ),
                        Text(
                          group.hasAlert
                              ? 'Tap to update group details'
                              : group.status.label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: group.hasAlert
                                ? const Color(0xFFFF9800)
                                : group.status.color,
                            letterSpacing: 0.25,
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right: chevron — 24×24 container, 20 px icon, #D1D5DB
            const SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: Icon(
                  Icons.chevron_right,
                  color: Color(0xFFD1D5DB),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ───────────────────────────────────────����──────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, color: Color(0xFF9CA3AF), size: 48),
          SizedBox(height: 16),
          Text(
            'No groups found',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF737373),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Modal ─────────────────────────────────────────────────────────────
class _FilterModal extends StatefulWidget {
  final String selectedCommunity;
  final Function(String) onCommunitySelected;

  const _FilterModal({
    required this.selectedCommunity,
    required this.onCommunitySelected,
  });

  @override
  State<_FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<_FilterModal> {
  late String _tempSelected;
  bool _communitiesExpanded = false;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedCommunity;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _kDivider),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Filter list by',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 0.15,
                      height: 24 / 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Communities expandable section
          GestureDetector(
            onTap: () {
              setState(() => _communitiesExpanded = !_communitiesExpanded);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _kDivider),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Communities',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 0.15,
                        height: 24 / 16,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _communitiesExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 24),
                  ),
                ],
              ),
            ),
          ),
          
          // Communities list (expanded)
          if (_communitiesExpanded) ..._buildCommunitiesList(),
          
          // Show results button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => widget.onCommunitySelected(_tempSelected),
                child: const Text(
                  'Show results',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    height: 24 / 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildCommunitiesList() {
    return [
      Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // "All communities" option
              _CommunityRadioTile(
                label: 'All communities',
                isSelected: _tempSelected == 'All communities',
                onSelected: () {
                  setState(() => _tempSelected = 'All communities');
                },
              ),
              ..._kCommunities.map(
                (community) => _CommunityRadioTile(
                  label: community,
                  isSelected: _tempSelected == community,
                  onSelected: () {
                    setState(() => _tempSelected = community);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

// ─── Community Radio Tile ──────────────────────────────────────────────────────
class _CommunityRadioTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _CommunityRadioTile({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _kDivider, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _kGreen : Color(0xFFD1D5DB),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _kGreen,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Label
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: 0.25,
                  height: 20 / 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Status bar — 52 px (spec §1) ────────────────────────────────────────────
class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: _kGreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          // Time
          const Text(
            '9:30',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.14,
              height: 20 / 14,
            ),
          ),
          const Spacer(),
          // Camera cutout
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          // Status icons
          const Icon(Icons.wifi, color: Colors.white, size: 17),
          const SizedBox(width: 4),
          const Icon(
            Icons.signal_cellular_4_bar,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.battery_full, color: Colors.white, size: 17),
        ],
      ),
    );
  }
}

// ─── Top app bar — 64 px (spec §2) ───────────────────────────────────────────
class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: _kGreen,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Back button — 48×48
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          const SizedBox(width: 4),
          // Title
          const Expanded(
            child: Text(
              'Farmer support',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: 0.15,
                height: 24 / 16,
              ),
            ),
          ),
          // Trailing placeholder
          const SizedBox(width: 48, height: 48),
        ],
      ),
    );
  }
}

// ─── Bottom indicator — 28 px (spec §10) ─────────────────────────────────────
// Home bar: 134×5 px, #1D1B20, border-radius 100, 8 px from bottom
class _BottomIndicator extends StatelessWidget {
  const _BottomIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: Colors.white,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: _kHomeBar,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
