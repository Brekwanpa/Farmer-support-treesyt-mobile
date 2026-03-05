import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'group_details_screen.dart';
import 'group_details_screen.dart';

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
  final String? groupNameToOpen;
  final bool shouldOpenActions;

  const FarmerGroupsProfileScreen({
    super.key,
    this.groupNameToOpen,
    this.shouldOpenActions = false,
  });

  @override
  State<FarmerGroupsProfileScreen> createState() =>
      _FarmerGroupsProfileScreenState();
}

class _FarmerGroupsProfileScreenState extends State<FarmerGroupsProfileScreen> {
  late TextEditingController _searchController;
  List<_FarmerGroup> _filteredGroups = _kFarmerGroups;
  String _selectedCommunity = 'All communities';

  // Get unique communities from groups
  static const List<String> _kCommunities = [
    'Kalba',
    'Gbaaliyiri',
    'Nahari',
    'Kolbayiri',
    'Uro Sarkoromaa',
    'Kunfusi',
    'Uro',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _kGreen,
      statusBarIconBrightness: Brightness.light,
    ));

    // Auto-navigate to group if specified
    if (widget.groupNameToOpen != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToGroup();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGroups(String query) {
    setState(() {
      List<_FarmerGroup> filtered = _kFarmerGroups;

      // Filter by community
      if (_selectedCommunity != 'All communities') {
        filtered = filtered
            .where((group) => group.community == _selectedCommunity)
            .toList();
      }

      // Filter by search query
      if (query.isNotEmpty) {
        filtered = filtered
            .where((group) =>
                group.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      _filteredGroups = filtered;
    });
  }

  void _navigateToGroup() {
    // Find the group by name
    final group = _kFarmerGroups.firstWhere(
      (g) => g.name == widget.groupNameToOpen,
      orElse: () => _kFarmerGroups.first,
    );

    // Navigate to GroupDetailsScreen and optionally open actions
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GroupDetailsScreen(
          groupName: group.name,
          farmerCount: 20,
          shouldOpenActions: widget.shouldOpenActions,
        ),
      ),
    );
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _FilterModal(
        selectedCommunity: _selectedCommunity,
        onCommunitySelected: (community) {
          setState(() => _selectedCommunity = community);
          _filterGroups(_searchController.text);
          Navigator.pop(context);
        },
      ),
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
                  GestureDetector(
                    onTap: _openFilterModal,
                    child: Padding(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupDetailsScreen(
                              groupName: group.name,
                              farmerCount: 20,
                            ),
                          ),
                        );
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

// ─── Filter Modal ────────────────────────────────────────────────────────────
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
  bool _communitiesExpanded = true;

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
              // Get unique communities from _kFarmerGroups
              ...const <String>[
                'Kalba',
                'Gbaaliyiri',
                'Nahari',
                'Kolbayiri',
                'Uro Sarkoromaa',
                'Kunfusi',
                'Uro',
              ].map(
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
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _kGreen : const Color(0xFFBDBDBD),
                  width: 2,
                ),
                color: isSelected ? _kGreen : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isSelected ? _kGreen : Colors.black,
                letterSpacing: 0.25,
                height: 20 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
