import 'package:flutter/material.dart';

import '../../core/theme.dart';

class TaxInvoice extends StatelessWidget {
  const TaxInvoice({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tax Invoice'),
          Text(
            'Order #AC-INV-2024-88402',
            style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf_outlined),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppTheme.outlineBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'AuraCare',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'AuraCare Retail & Specialty Pharmacy Pvt Ltd',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text(
                'Building 4B, Bio-Tech District, MIDC Phase II, Mumbai, MH – 400070',
                style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
              ),
              const Divider(height: 26),
              const Row(
                children: [
                  Expanded(child: _Detail('GSTIN Number', '27AABCA9182L1Z9')),
                  SizedBox(width: 8),
                  Expanded(child: _Detail('FSSAI License', '11521018000492')),
                ],
              ),
              const Divider(height: 26),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Invoice Number', style: TextStyle(fontSize: 11)),
                        Text(
                          'AC-INV-2024-88402',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Date: 28 Oct 2024, 09:42 AM',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Billed To\nAditi Rao\nBengaluru, India',
                    textAlign: TextAlign.right,
                    style: TextStyle(height: 1.4),
                  ),
                ],
              ),
              const Divider(height: 26),
              const Text(
                'Prescription Items & Taxes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              const _InvoiceItem(
                'Janumet 50mg/500mg',
                'Batch JN8103F · Exp 04/2027',
                '₹485.00',
              ),
              const _InvoiceItem(
                'Rosuvas 10mg',
                'Batch RV1008 · Exp 08/2027',
                '₹1,022.00',
              ),
              const _InvoiceItem(
                'Clinical dispatch & GST',
                'GST included',
                '₹161.46',
              ),
              const Divider(height: 24),
              const _Total('Taxable subtotal', '₹1,345.54'),
              const _Total('Central GST (6%)', '₹80.73'),
              const _Total('State GST (6%)', '₹80.73'),
              const Divider(height: 24),
              const _Total('Gross amount', '₹1,507.00', bold: true),
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Invoice saved'))),
          icon: const Icon(Icons.download_outlined),
          label: const Text('Download Invoice'),
        ),
      ),
    ),
  );
}

class _Detail extends StatelessWidget {
  const _Detail(this.title, this.value);
  final String title, value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppTheme.surfaceLow,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10)),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class _InvoiceItem extends StatelessWidget {
  const _InvoiceItem(this.name, this.batch, this.price);
  final String name, batch, price;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                batch,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(price, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _Total extends StatelessWidget {
  const _Total(this.label, this.value, {this.bold = false});
  final String label, value;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: bold ? AppTheme.primaryDark : AppTheme.text,
            fontSize: bold ? 20 : 14,
          ),
        ),
      ],
    ),
  );
}
