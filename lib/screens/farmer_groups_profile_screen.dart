import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Spec-exact colour palette ───────────────────────────────────────────────
const Color _kGreen       = Color(0xFF18A369);
const Color _kGreenDark   = Color(0xFF0D7E4E);
const Color _kBgGray      = Color(0xFFFAFAFA);
const Color _kDivider     = Color(0xFFE5E5E5);
const Color _kTextDark    = Color(0xFF171717);
const Color _kTextGray    = Color(0xFF737373);
const Color _kAlertOrange = Color(0xFFFF9800);

// ─── Sample farmer group data ────────────────────────────────────────────────
class _FarmerGroup {
  final String name;
  final String community;
  final bool hasUpdateCTA;
  final Color avatarColor;
  final String initials;

  const _FarmerGroup({
    required this.name,
    required this.community,
    required this.hasUpdateCTA,
    required this.avatarColor,
    required this.initials,
  });
}

const List<_FarmerGroup> _kFarmerGroups = [
  _FarmerGroup(
    name: 'Goaso guild',
    community: 'Kalba',
    hasUpdateCTA: true,
    avatarColor: Color(0xFF4CAF50),
    initials: 'G',
  ),
  _FarmerGroup(
    name: 'Tumu cooperative',
    community: 'Gbaaliyiri',
    hasUpdateCTA: false,
    avatarColor: Color(0xFFC62828),
    initials: 'T',
  ),
  _FarmerGroup(
    name: 'Apengu farmers',
    community: 'Nahari',
    hasUpdateCTA: true,
    avatarColor: Color(0xFF8B7355),
    initials: 'A',
  ),
  _FarmerGroup(
    name: 'Gwollu VSLA',
    community: 'Nahari',
    hasUpdateCTA: false,
    avatarColor: Color(0xFF66BB6A),
    initials: 'G',
  ),
  _FarmerGroup(
    name: 'Apemsu cooperative',
    community: 'Kolbayiri',
    hasUpdateCTA: true,
    avatarColor: Color(0xFF5E35B1),
    initials: 'A',
  ),
  _FarmerGroup(
    name: 'Sombo cooperative',
    community: 'Uro Sarkoromaa',
    hasUpdateCTA: false,
    avatarColor: Color(0xFFB8860B),
    initials: 'S',
  ),
  _FarmerGroup(
    name: 'Ayensu farmers',
    community: 'Kunfusi',
    hasUpdateCTA: true,
    avatarColor: Color(0xFF1A237E),
    initials: 'A',
  ),
  _FarmerGroup(
    name: 'Tatale farmers',
    community: 'Uro',
    hasUpdateCTA: true,
    avatarColor: Color(0xFFFDD835),
    initials: 'T',
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────
class FarmerGroupsProfileScreen extends StatefulWidget {
  const FarmerGroupsProfileScreen({super.key});

  @override
  State<FarmerGroupsProfileScreen> createState() =>
      _FarmerGroupsProfileScreenState();
}

class _FarmerGroupsProfileScreenState extends State<FarmerGroupsProfileScreen> {
  late TextEditingController _searchController;
  List<_FarmerGroup> _filteredGroups = _kFarmerGroups;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _kGreen,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGroups(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGroups = _kFarmerGroups;
      } else {
        _filteredGroups = _kFarmerGroups
            .where((group) =>
                group.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
                  'Farmer groups',
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
                  // Filters section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        const Icon(Icons.tune, color: _kGreen, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: _kGreen,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterGroups,
                      decoration: InputDecoration(
                        hintText: 'Search by group name',
                        hintStyle: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                          letterSpacing: 0.25,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: _kGreen,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: _kTextDark,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Farmer groups list
                  ..._filteredGroups.map(
                    (group) => _FarmerGroupRow(
                      group: group,
                      onTap: () {
                        // TODO: Navigate to group profile/update details
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),

      // Profile group button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement profile group action
        },
        backgroundColor: _kGreen,
        label: const Text(
          'Profile group',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ─── Farmer group row ────────────────────────────────────────────────────────
class _FarmerGroupRow extends StatelessWidget {
  final _FarmerGroup group;
  final VoidCallback onTap;

  const _FarmerGroupRow({
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: group.avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      group.initials,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Group info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group name
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: _kTextDark,
                          letterSpacing: 0.15,
                          height: 24 / 16,
                        ),
                      ),

                      // Community
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          group.community,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: _kTextGray,
                            letterSpacing: 0.25,
                            height: 20 / 14,
                          ),
                        ),
                      ),

                      // CTA if applicable
                      if (group.hasUpdateCTA)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Tap to update details',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: _kAlertOrange,
                              letterSpacing: 0.25,
                              height: 20 / 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Chevron
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFD1D5DB),
                  size: 24,
                ),
              ],
            ),
          ),
        ),

        // Divider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
            thickness: 1,
            color: group.hasUpdateCTA ? const Color(0xFFEEEEEE) : _kDivider,
          ),
        ),

        // Light background for update CTA rows
        if (group.hasUpdateCTA)
          Container(
            height: 0,
            color: const Color(0xFFF5F5F5),
          ),
      ],
    );
  }
}
