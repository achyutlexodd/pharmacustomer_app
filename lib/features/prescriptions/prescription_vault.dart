import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../home/search.dart';
import 'prescription_review.dart';
import 'prescription_upload_sheet.dart';
import 'widgets/prescription_progress_step.dart';
import 'widgets/prescription_detail_sheet.dart';
import 'widgets/prescription_refill_sheet.dart';

class PrescriptionVault extends StatefulWidget {
  final String patientName;
  final String? patientId;
  final List<String> allergies;
  final String? profileImagePath;
  final VoidCallback? onBack;

  const PrescriptionVault({
    super.key,
    required this.patientName,
    this.patientId,
    this.allergies = const [],
    this.profileImagePath,
    this.onBack,
  });

  @override
  State<PrescriptionVault> createState() => _PrescriptionVaultState();
}

class _PrescriptionVaultState extends State<PrescriptionVault> {
  int _tab = 0;
  bool _hasUnderReviewPrescription = false;
  bool _hasActivePrescription = false;
  bool _hasArchivedPrescription = true;
  bool _firstArchiveVisible = true;

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: _handleBack,
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
    height: 64,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
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
        label: Text('$label  $count'),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.textSecondary,
          fontSize: 13,
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

  Widget _emptyView() => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight - 52),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppTheme.outlineBorder),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: .07),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppTheme.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your prescriptions, all in one place',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                height: 1.2,
                fontWeight: FontWeight.bold,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Upload a prescription to get pharmacist support and manage refills securely.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppTheme.mutedText,
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _uploadPrescription,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Upload prescription'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => const Search())),
                icon: const Icon(Icons.shopping_basket_outlined),
                label: const Text('Browse OTC & wellness'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 15, color: AppTheme.mutedText),
                SizedBox(width: 6),
                Text(
                  'Your documents are stored securely',
                  style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _uploadPrescription() async {
    final file = await showPrescriptionUploadSheet(context);
    if (!mounted || file == null) return;
    final submitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PrescriptionReview(
          file: file,
          patientName: widget.patientName,
          patientId: widget.patientId,
          allergies: widget.allergies,
          profileImagePath: widget.profileImagePath,
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
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Past prescriptions',
            style: TextStyle(
              fontSize: 17,
              color: AppTheme.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          _pill(
            '${_firstArchiveVisible ? 2 : 1} records',
            Colors.white,
            AppTheme.textSecondary,
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
    padding: const EdgeInsets.all(18),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _pill(expiry, color.withValues(alpha: .13), color),
            if (first) ...[
              _pill(
                'No refills left',
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
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.medication_outlined,
                    color: AppTheme.primary,
                    size: 17,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Prescribed medicines',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                medicine,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: AppTheme.mutedText,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      detail,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (first)
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _uploadPrescription,
                  icon: const Icon(Icons.autorenew_rounded, size: 18),
                  label: const Text('Renew prescription'),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _showDocument,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('View document'),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => setState(() {
                        _hasActivePrescription = true;
                        _firstArchiveVisible = false;
                        _hasArchivedPrescription = true;
                        _tab = 0;
                      }),
                      icon: const Icon(Icons.unarchive_outlined, size: 18),
                      label: const Text('Restore'),
                    ),
                  ),
                ],
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showDocument,
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('View document'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _uploadPrescription,
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Upload new'),
                ),
              ),
            ],
          ),
      ],
    ),
  );

  Widget _underReviewView() {
    if (!_hasUnderReviewPrescription) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.fact_check_outlined,
                    color: AppTheme.primary,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Nothing under review yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Upload a clear prescription and our pharmacy team will review it. You can follow its progress here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _uploadPrescription,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Upload prescription'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Prescription submitted',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Uploaded just now · 1 page',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _pill('IN REVIEW', AppTheme.infoBg, AppTheme.infoText),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: .65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Most reviews are completed within 30–45 minutes',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const PrescriptionProgressStep(
                icon: Icons.check_rounded,
                title: 'Prescription uploaded',
                done: true,
              ),
              const PrescriptionProgressStep(
                icon: Icons.medical_information_outlined,
                title: 'Pharmacist review',
                active: true,
              ),
              const PrescriptionProgressStep(
                icon: Icons.shopping_bag_outlined,
                title: 'Medicines added to cart',
              ),
              const PrescriptionProgressStep(
                icon: Icons.credit_card_outlined,
                title: 'Ready for payment',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _uploadPanel(),
      ],
    );
  }

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
