import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'delivery_options.dart';

class Address extends StatefulWidget {
  const Address({super.key});
  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Select Delivery Address'),
      actions: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add new'),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          color: AppTheme.surfaceLow,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      child: Icon(Icons.my_location, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deliver to Current Location',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Bellandur Outer Ring Road, near Central Mall',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => selected = -1),
                    icon: const Icon(Icons.near_me_outlined),
                    label: const Text('Locate Me  ›'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'SAVED ADDRESSES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppTheme.mutedText,
            ),
          ),
        ),
        ...[
          'Home · Flat 402, Green Glen Layout, Bellandur, Bengaluru 560103',
          'Work / Office · Tower 4, Ecospace Business Park, Outer Ring Rd, Bellandur, Bengaluru 560103',
          'Parents’ Home · 12th Main, Indiranagar, Bengaluru 560038',
        ].asMap().entries.map(
          (entry) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: selected == entry.key
                    ? AppTheme.primary
                    : AppTheme.outlineBorder,
                width: selected == entry.key ? 1.8 : 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              onTap: () => setState(() => selected = entry.key),
              leading: Icon(
                selected == entry.key
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selected == entry.key
                    ? AppTheme.primary
                    : AppTheme.mutedText,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.value.split(' · ').first,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (entry.key == 0)
                    const Chip(
                      label: Text('Default'),
                      visualDensity: VisualDensity.compact,
                      labelStyle: TextStyle(fontSize: 9),
                    ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 18),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.value.split(' · ').last,
                      style: const TextStyle(height: 1.35),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          entry.key == 0 ? Icons.bolt : Icons.schedule,
                          size: 13,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          entry.key == 0
                              ? '22 Mins Express'
                              : (entry.key == 1
                                    ? 'Standard 45 Mins'
                                    : 'Next-day Morning Slot'),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Delivering to: ${selected < 0 ? 'Current Location' : ['Home', 'Work / Office', 'Parents’ Home'][selected]}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.bolt, size: 15, color: Colors.orange),
              const Text(
                ' 22 Mins',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const DeliveryOptions(),
                ),
              ),
              child: const Text('Deliver to this Address  →'),
            ),
          ),
        ],
      ),
    ),
  );
}
