import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../home/search.dart';
import 'prescription_review.dart';
import 'prescription_upload_sheet.dart';
import 'widgets/prescription_progress_step.dart';
import 'widgets/prescription_detail_sheet.dart';
import 'widgets/prescription_refill_sheet.dart';
import 'prescription_review_status.dart';
import 'prescription_clarification.dart';
import 'prescription_rejection.dart';
import 'prescription_partial_approval.dart';
import 'store_allocation_status.dart';

class PrescriptionVault extends StatefulWidget {
  final String patientName;

  const PrescriptionVault({super.key, required this.patientName});

  @override
  State<PrescriptionVault> createState() =>
      _PrescriptionVaultState();
}

class _PrescriptionVaultState extends State<PrescriptionVault> {
  int _tab = 0;
  bool _hasUnderReviewPrescription = false;
  bool _hasActivePrescription = false;
  bool _hasArchivedPrescription = true;
  bool _firstArchiveVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFD),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Prescription Vault'),
        actions: [
          IconButton(
            onPressed: _showInfo,
            icon: const Icon(Icons.info_outline, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          _tabs(),
          Expanded(
            child: _tab == 0
                ? _hasActivePrescription
                      ? _activeView()
                      : _emptyView()
                : _tab == 1
                ? _underReviewView()
                : _archivedView(),
          ),
        ],
      ),
    );
  }

  Widget _tabs() => SizedBox(
    height: 56,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      scrollDirection: Axis.horizontal,
      children: [
        _tabChip(0, 'Active Prescriptions', _hasActivePrescription ? '3' : '0'),
        _tabChip(1, 'Under Review', _hasUnderReviewPrescription ? '1' : '0'),
        _tabChip(2, 'Past & Expired', _hasArchivedPrescription ? '2' : '0'),
      ],
    ),
  );

  Widget _tabChip(int index, String label, String count) {
    final selected = _tab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: selected,
        showCheckmark: false,
        label: Text('${selected ? '✓ ' : ''}$label ($count)'),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        selectedColor: AppTheme.primary,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: selected ? AppTheme.primary : AppTheme.outlineBorder,
        ),
        onSelected: (_) => setState(() => _tab = index),
      ),
    );
  }

  Widget _activeView() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
    children: [
      _prescriptionCard(
        name: 'Dr. Rajiv Mehta',
        subtitle: 'Cardiologist • Max Hospital',
        date: 'Prescribed 12 Aug 2026',
        status: 'Verified & Active',
        medicines: const [
          ('Metformin', '500mg • Daily'),
          ('Telmisartan', '40mg • Morning'),
        ],
      ),
      const SizedBox(height: 20),
      _uploadPanel(),
    ],
  );

  Widget _emptyView() => Column(
    children: [
      const Spacer(),
      Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD1EFF6)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: .08),
              blurRadius: 14,
            ),
          ],
        ),
        child: const Icon(
          Icons.lock_outline,
          color: AppTheme.primary,
          size: 38,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'No Prescriptions Upload Yet',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppTheme.text,
        ),
      ),
      const SizedBox(height: 42),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _uploadPrescription,
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Upload New Prescription'),
          ),
        ),
      ),
      const Divider(height: 32, indent: 20, endIndent: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const Search()),
            ),
            icon: const Icon(Icons.shopping_basket_outlined),
            label: const Text('Browse OTC & Wellness Catalog'),
          ),
        ),
      ),
      const Spacer(flex: 2),
    ],
  );

  Future<void> _uploadPrescription() async {
    final file = await showPrescriptionUploadSheet(context);
    if (!mounted || file == null) return;
    final submitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PrescriptionReview(
          file: file,
          patientName: widget.patientName,
        ),
      ),
    );
    if (submitted == true && mounted) {
      setState(() {
        _hasUnderReviewPrescription = true;
        _tab = 1;
      });
    }
  }

  Widget _prescriptionCard({
    required String name,
    required String subtitle,
    required String date,
    required String status,
    required List<(String, String)> medicines,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconTile(Icons.medical_services_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '▣  $date',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _pill(status, const Color(0xFFE5F5EE), const Color(0xFF168457)),
          ],
        ),
        const Divider(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF9FD),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Linked Prescribed\nMedications (2)',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    'Dosage Refills\nAvailable',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...medicines.map(
                (item) => Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication_outlined,
                        size: 15,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _pill(
                        item.$2,
                        const Color(0xFFD9F5FA),
                        AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _showDocument,
                icon: const Icon(Icons.visibility_outlined, size: 17),
                label: const Text('View Rx'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showRefillSheet,
                icon: const Icon(Icons.shopping_bag_outlined, size: 17),
                label: const Text('Reorder All Medicines'),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _uploadPanel() => Container(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFA8D7E0), width: 1.5),
    ),
    child: Column(
      children: [
        _iconTile(Icons.cloud_upload_outlined, size: 48),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _uploadPrescription,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Upload New Prescription'),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Gallery images or PDF',
          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    ),
  );

  Widget _archivedView() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ARCHIVED DOCUMENTS',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
          Text(
            'Showing ${_firstArchiveVisible ? 2 : 1} of 3 expired records',
            style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
          ),
        ],
      ),
      const SizedBox(height: 14),
      if (_firstArchiveVisible) ...[
        _archiveCard(
          'Dr. Rajiv Mehta, MD',
          'Senior Endocrinologist • Max Healthcare',
          'Expired on 12 Nov 2024',
          'Janumet 50mg/500mg, Glimepiride 2mg',
          '3 of 3 Refills Completed • Validity lapsed (6 Months)',
          Colors.red,
          first: true,
        ),
        const SizedBox(height: 14),
      ],
      _archiveCard(
        'Dr. Sunita Rao, MBBS, DNB',
        'Cardiologist • Fortis Escorts Hospital',
        'Expired on 04 Jan 2025',
        'Rosuvas 10mg (Rosuvastatin), Telma 40mg',
        'Maintenance dosage complete • Fresh evaluation recommended',
        Colors.orange,
      ),
    ],
  );

  Widget _archiveCard(
    String name,
    String subtitle,
    String expiry,
    String medicine,
    String detail,
    Color color, {
    bool first = false,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _iconTile(
              first ? Icons.badge_outlined : Icons.monitor_heart_outlined,
              size: 42,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 22),
        Row(
          children: [
            _pill('◴  $expiry', color.withValues(alpha: .13), color),
            if (first) ...[
              const SizedBox(width: 8),
              _pill(
                '0 Refills Left',
                const Color(0xFFFFE0DE),
                Colors.red.shade700,
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF9FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MEDICATIONS PRESCRIBED',
                style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 6),
              Text(
                medicine,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ⓘ  $detail',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (first)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _uploadPrescription,
                      icon: const Icon(Icons.autorenew, size: 16),
                      label: const Text('Renew Prescription'),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showDocument,
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('View Old Document'),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => setState(() {
                  _hasActivePrescription = true;
                  _firstArchiveVisible = false;
                  _hasArchivedPrescription = true;
                  _tab = 0;
                }),
                icon: const Icon(Icons.unarchive_outlined),
                label: const Text('Restore to Active Prescriptions'),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Doctor consultation is not available yet'),
                    ),
                  ),
                  icon: const Icon(Icons.medical_services_outlined, size: 16),
                  label: const Text('1-Tap Doctor Consult'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _uploadPrescription,
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Upload Fresh Rx'),
                ),
              ),
            ],
          ),
      ],
    ),
  );

  Widget _underReviewView() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _hasUnderReviewPrescription
                  ? 'Prescription submitted • 1 page'
                  : 'No prescriptions under review',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _hasUnderReviewPrescription
                  ? 'Uploaded just now • Review usually takes 30–45 minutes'
                  : 'Upload a prescription to track its review here.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            const PrescriptionProgressStep(
              icon: Icons.check,
              title: 'Prescription Uploaded',
              done: true,
            ),
            const PrescriptionProgressStep(
              icon: Icons.medical_information_outlined,
              title: 'Under Review',
              active: true,
            ),
            const PrescriptionProgressStep(
              icon: Icons.shopping_bag_outlined,
              title: 'Medicines Added to Cart',
            ),
            const PrescriptionProgressStep(
              icon: Icons.credit_card_outlined,
              title: 'Order Ready for Payment',
            ),
            const SizedBox(height: 12),
            const Text(
              'Prescription decision screens',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _statusLink(
                  'Review Breakdown',
                  const PrescriptionReviewStatus(),
                ),
                _statusLink(
                  'Clarification Needed',
                  const PrescriptionClarification(),
                ),
                _statusLink(
                  'Rejected & Refund',
                  const PrescriptionRejection(),
                ),
                _statusLink(
                  'Partial Approval',
                  const PrescriptionPartialApproval(),
                ),
                _statusLink(
                  'Store Reallocation',
                  const StoreAllocationStatus(),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _uploadPanel(),
    ],
  );

  Widget _statusLink(String label, Widget screen) => ActionChip(
    label: Text(label),
    labelStyle: const TextStyle(
      fontSize: 12,
      color: AppTheme.primary,
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: const Color(0xFFDDF6FB),
    side: BorderSide(color: AppTheme.primary.withValues(alpha: .3)),
    onPressed: () => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen)),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xFFD9EDF2)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .025),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  Widget _iconTile(IconData icon, {double size = 44}) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFDDF6FB),
      borderRadius: BorderRadius.circular(size == 48 ? size / 2 : 12),
    ),
    child: Icon(icon, color: AppTheme.primary, size: size * .48),
  );

  Widget _pill(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );

  void _showInfo() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Your Prescription Vault'),
      content: const Text(
        'Your prescriptions are stored securely and are only used to help pharmacists verify your medicines and refills.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );

  void _showDocument() => showPrescriptionDetailSheet(
    context,
    onArchive: () => setState(() {
      _hasActivePrescription = false;
      _hasArchivedPrescription = true;
      _firstArchiveVisible = true;
      _tab = 2;
    }),
  );

  void _showRefillSheet() => showPrescriptionRefillSheet(context);
}
