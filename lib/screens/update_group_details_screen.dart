import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
const Color _kGreen = Color(0xFF18A369);
const Color _kDivider = Color(0xFFE5E5E5);
const Color _kTextDark = Color(0xFF171717);
const Color _kTextGray = Color(0xFF737373);
const Color _kBgGray = Color(0xFFFAFAFA);
const Color _kBorder = Color(0xFFE0E0E0);

// ─── Update group details screen ──────────────────────────────────────────────
class UpdateGroupDetailsScreen extends StatefulWidget {
  final String groupName;

  const UpdateGroupDetailsScreen({required this.groupName});

  @override
  State<UpdateGroupDetailsScreen> createState() => _UpdateGroupDetailsScreenState();
}

class _UpdateGroupDetailsScreenState extends State<UpdateGroupDetailsScreen> {
  int _currentStep = 0;
  
  // Form data
  String _groupName = '';
  String _dateOfEstablishment = '';
  String _typeOfGroup = '';
  String _membershipComposition = '';
  int _estimatedMembers = 0;
  int _numberWomen = 0;
  int _numberMen = 0;
  String _bankAccount = '';
  bool _mobileMoneyAccept = false;
  
  bool _hasLeadership = false;
  String _leaderName = '';
  String _leaderPosition = '';
  String _leaderGender = '';
  String _leaderContact = '';
  
  bool _hasMembershipRecords = false;
  bool _hasFinancialRecords = false;
  bool _hasBankRecords = false;
  bool _hasMeetingMinutes = false;

  void _goToStep(int step) {
    if (step >= 0 && step <= 2) {
      setState(() => _currentStep = step);
    }
  }

  void _showSuccessScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const _SuccessScreen()),
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
          'Update group info',
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
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // Step dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ..._buildStepIndicators(),
                  ],
                ),
                const SizedBox(height: 12),
                // Step labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepLabel('General', 0),
                    _buildStepLabel('Leadership', 1),
                    _buildStepLabel('Files', 2),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: _kDivider),

          // Step content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStepContent(),
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: _kGreen, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _goToStep(_currentStep - 1),
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: _kGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_currentStep < 2) {
                        _goToStep(_currentStep + 1);
                      } else {
                        _showSuccessScreen();
                      }
                    },
                    child: Text(
                      _currentStep < 2 ? 'Next' : 'Update profile',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStepIndicators() {
    return List.generate(3, (index) {
      bool isActive = index <= _currentStep;
      bool isCompleted = index < _currentStep;
      
      return Expanded(
        child: Row(
          children: [
            // Dot
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? _kGreen : _kDivider,
              ),
            ),
            // Line
            if (index < 2)
              Expanded(
                child: Container(
                  height: 2,
                  color: isCompleted ? _kGreen : _kDivider,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildStepLabel(String label, int step) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: step == _currentStep ? _kGreen : _kTextGray,
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildGeneralStep();
      case 1:
        return _buildLeadershipStep();
      case 2:
        return _buildFilesStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildGeneralStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Name of farmer group *', _groupName, (v) => _groupName = v, 'Wechiau Agro Allies'),
        const SizedBox(height: 16),
        _buildTextField('Date of establishment *', _dateOfEstablishment, (v) => _dateOfEstablishment = v, '19-10-2004'),
        const SizedBox(height: 16),
        _buildDropdown('Type of group *', _typeOfGroup, (v) => setState(() => _typeOfGroup = v), ['VSLA group', 'Farmer Group']),
        const SizedBox(height: 16),
        _buildDropdown('Membership composition *', _membershipComposition, (v) => setState(() => _membershipComposition = v), ['Women and Men', 'Women only', 'Men only']),
        const SizedBox(height: 16),
        _buildTextField('Estimated number of members in the group *', _estimatedMembers.toString(), (v) => setState(() => _estimatedMembers = int.tryParse(v) ?? 0), '50'),
        const SizedBox(height: 16),
        _buildTextField('Number of women *', _numberWomen.toString(), (v) => setState(() => _numberWomen = int.tryParse(v) ?? 0), '25'),
        const SizedBox(height: 16),
        _buildTextField('Number of men *', _numberMen.toString(), (v) => setState(() => _numberMen = int.tryParse(v) ?? 0), '25'),
        const SizedBox(height: 16),
        _buildRadioGroup('Does this group have a Bank account or Momo number? *', _bankAccount, (v) => setState(() => _bankAccount = v), ['Yes, Bank account and MoMo number', 'Yes, Bank account only', 'Yes, Momo number only', 'No']),
        const SizedBox(height: 16),
        _buildRadioGroup('Is the group willing to accept a MoMo SIM? *', _mobileMoneyAccept ? 'Yes' : 'No', (v) => setState(() => _mobileMoneyAccept = v == 'Yes'), ['Yes', 'No']),
      ],
    );
  }

  Widget _buildLeadershipStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRadioGroup('Is there an organized leadership? *', _hasLeadership ? 'Yes' : 'No', (v) => setState(() => _hasLeadership = v == 'Yes'), ['Yes', 'No']),
        const SizedBox(height: 24),
        
        if (_hasLeadership) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD4EFE9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'First leader',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: _kGreen,
                    letterSpacing: 0.25,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField('Full name of first leader *', _leaderName, (v) => _leaderName = v, 'Kwame Ato'),
                const SizedBox(height: 12),
                _buildTextField('Position of the leader *', _leaderPosition, (v) => _leaderPosition = v, 'President'),
                const SizedBox(height: 12),
                _buildDropdown('Gender of group leader *', _leaderGender, (v) => setState(() => _leaderGender = v), ['Male', 'Female']),
                const SizedBox(height: 12),
                _buildTextField('Contact number of the leader *', _leaderContact, (v) => _leaderContact = v, '0505050505'),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Remove leader',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.red.shade700,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '+ Add leader',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _kGreen,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: _kDivider),
                const SizedBox(height: 12),
                const Text(
                  'Number of group leaders',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: _kTextDark,
                    letterSpacing: 0.25,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text(
                      'Calculated',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: _kTextGray,
                        letterSpacing: 0.25,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '1',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _kTextDark,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRadioGroup('Does the group have membership records? *', _hasMembershipRecords ? 'Yes' : 'No', (v) => setState(() => _hasMembershipRecords = v == 'Yes'), ['Yes', 'No']),
        const SizedBox(height: 12),
        if (_hasMembershipRecords) ...[
          _buildImageCapture('Capture images of membership records *'),
          const SizedBox(height: 16),
        ],
        
        _buildRadioGroup('Does the group have records of financial contributions from members? *', _hasFinancialRecords ? 'Yes' : 'No', (v) => setState(() => _hasFinancialRecords = v == 'Yes'), ['Yes', 'No']),
        const SizedBox(height: 12),
        if (_hasFinancialRecords) ...[
          _buildImageCapture('Capture images of members contributions *'),
          const SizedBox(height: 16),
        ],

        _buildRadioGroup('Do you have previous loans from other organizations?', _bankAccount.isNotEmpty ? 'Yes' : 'No', (v) {}, ['Yes', 'No']),
        const SizedBox(height: 12),
        _buildImageCapture('Capture images of the bank records'),
        const SizedBox(height: 16),

        _buildRadioGroup('Does the group have meeting minutes records?', _hasMeetingMinutes ? 'Yes' : 'No', (v) => setState(() => _hasMeetingMinutes = v == 'Yes'), ['Yes', 'No']),
        const SizedBox(height: 12),
        if (_hasMeetingMinutes)
          _buildImageCapture('Capture images of the records of meetings'),
      ],
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: _kTextDark,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFFBDBDBD),
              letterSpacing: 0.25,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: _kBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: _kBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
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
      ],
    );
  }

  Widget _buildDropdown(String label, String value, Function(String) onChanged, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: _kTextDark,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          hint: const Text('Select an option'),
          items: options
              .map((option) => DropdownMenuItem<String>(value: option, child: Text(option)))
              .toList(),
          onChanged: (newValue) => onChanged(newValue ?? ''),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: _kBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: _kBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: _kGreen, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup(String label, String value, Function(String) onChanged, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: _kTextDark,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 8),
        ...options.map((option) => GestureDetector(
          onTap: () => onChanged(option),
          child: Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: value,
                onChanged: (v) => onChanged(v ?? ''),
                activeColor: _kGreen,
              ),
              const SizedBox(width: 8),
              Text(
                option,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: _kTextDark,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildImageCapture(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: _kTextDark,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: _kBorder, width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Tap to capture images',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: _kTextGray,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.camera_alt, color: _kTextGray, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Success screen ────────────────────────────────────────────────────────────
class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kGreen,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Farmer group details updated',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: _kTextDark,
                  letterSpacing: 0.15,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'successfully',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: _kTextDark,
                  letterSpacing: 0.15,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
