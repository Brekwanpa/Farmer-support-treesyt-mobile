import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'update_group_details_screen.dart';

// ─── Colours ──────────────────────────────────────────────────────────────────
const Color _kGreen = Color(0xFF18A369);
const Color _kDivider = Color(0xFFE5E5E5);
const Color _kTextDark = Color(0xFF171717);
const Color _kTextGray = Color(0xFF737373);
const Color _kBgGray = Color(0xFFFAFAFA);

// ─── Farmer model ─────────────────────────────────────────────────────────────
class _Farmer {
  final String name;
  final String id;
  final String imagePath; // Would be network image in real app

  const _Farmer({
    required this.name,
    required this.id,
    required this.imagePath,
  });
}

// ─── Sample farmer data ───────────────────────────────────────────────────────
const List<_Farmer> _kFarmers = [
  _Farmer(name: 'Akansele Ayebase', id: 'ID: 03-13-066-TT-41', imagePath: ''),
  _Farmer(name: 'Akunpule Ajuah', id: 'ID: 03-13-066-TB-43', imagePath: ''),
  _Farmer(name: 'Akanji Cynthia', id: 'ID: 03-13-066-TB-43', imagePath: ''),
  _Farmer(name: 'Amantoge Akassalingo', id: 'ID: 03-13-066-TB-43', imagePath: ''),
  _Farmer(name: 'Akansube Achiibuke', id: 'ID: 03-13-066-YB-51', imagePath: ''),
  _Farmer(name: 'Aganbogiba Anchor', id: 'ID: 03-13-066-YB-51', imagePath: ''),
  _Farmer(name: 'Beatrice Tampuli', id: 'ID: 03-13-066-YB-51', imagePath: ''),
  _Farmer(name: 'Musah Abu', id: 'ID: 03-13-066-YB-51', imagePath: ''),
  _Farmer(name: 'Serwaa Ampofo', id: 'ID: 03-13-066-YB-51', imagePath: ''),
  _Farmer(name: 'Mustafi Caleb', id: 'ID: 03-13-066-YB-51', imagePath: ''),
];

// ─── Group details screen ─────────────────────────────────────────────────────
class GroupDetailsScreen extends StatefulWidget {
  final String groupName;
  final int farmerCount;

  const GroupDetailsScreen({
    required this.groupName,
    required this.farmerCount,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  late TextEditingController _searchController;
  List<_Farmer> _filteredFarmers = _kFarmers;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFarmers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFarmers = _kFarmers;
      } else {
        _filteredFarmers = _kFarmers
            .where((farmer) =>
                farmer.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showActionsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _ActionsBottomSheet(
        groupName: widget.groupName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _kGreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: const Text(
          'Group details',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 0.15,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          // Group info section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.groupName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: _kTextDark,
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.farmerCount} farmers added',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: _kTextGray,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: _kDivider),

          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFarmers,
              decoration: InputDecoration(
                hintText: 'Search farmer',
                hintStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFFBDBDBD),
                  letterSpacing: 0.25,
                ),
                prefixIcon: const Icon(Icons.search, color: _kTextGray, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _kDivider, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _kDivider, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _kGreen, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

          // Farmers list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFarmers.length,
              itemBuilder: (context, index) {
                final farmer = _filteredFarmers[index];
                return _FarmerListTile(farmer: farmer);
              },
            ),
          ),
        ],
      ),

      // Actions floating button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showActionsModal,
        backgroundColor: _kGreen,
        label: const Text(
          'Actions',
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

// ─── Farmer list tile ──────────────────────────────────────────────────────────
class _FarmerListTile extends StatelessWidget {
  final _Farmer farmer;

  const _FarmerListTile({required this.farmer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _kDivider, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kBgGray,
              border: Border.all(color: _kDivider, width: 1),
            ),
            child: const Center(
              child: Icon(Icons.person, color: _kTextGray, size: 20),
            ),
          ),
          const SizedBox(width: 12),

          // Farmer info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farmer.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: _kTextDark,
                    letterSpacing: 0.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  farmer.id,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: _kTextGray,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Actions bottom sheet ──────────────────────────────────────────────────────
class _ActionsBottomSheet extends StatelessWidget {
  final String groupName;

  const _ActionsBottomSheet({required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _kDivider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'Select group action to proceed',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: _kTextDark,
              letterSpacing: 0.15,
            ),
          ),
          const SizedBox(height: 24),

          // Update members button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: _kGreen, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to update membership
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_note, color: _kGreen, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Update members',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _kGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Update group details button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: _kGreen, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateGroupDetailsScreen(
                      groupName: widget.groupName,
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: _kGreen, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Update group details',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _kGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
