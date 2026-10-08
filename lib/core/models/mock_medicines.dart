import 'medicine_model.dart';

const janumet = Medicine(
  name: 'Janumet 50mg/500mg Tablet',
  description: 'Sitagliptin (50mg) + Metformin HCl (500mg)',
  price: '485.00',
  mrp: '550.00',
  discount: '12% OFF',
  badge: 'Prescription Required',
  requiresPrescription: true,
  tag: 'Strip of 15 tablets',
);

const mockMedicines = <Medicine>[
  janumet,
  Medicine(name: 'Glycomet 500mg SR Tablet', description: 'Metformin HCl (500mg)', price: '24.50', mrp: '28.00', discount: '12% OFF', badge: 'Prescription Required', requiresPrescription: true, tag: '10 Tablets'),
  Medicine(name: 'Januvia 100mg Tablet', description: 'Sitagliptin phosphate', price: '310.00', mrp: '345.00', discount: '10% OFF', badge: 'Prescription Required', requiresPrescription: true, tag: '7 Tablets'),
  Medicine(name: 'Accu-Chek Active Test Strips', description: 'Blood glucose monitoring strips', price: '925.00', mrp: '1050.00', discount: '12% OFF', badge: 'OTC', requiresPrescription: false, tag: '50 Strips'),
  Medicine(name: 'Glucerna Diabetes Care', description: 'Vanilla nutritional drink', price: '680.00', mrp: '750.00', discount: '9% OFF', badge: 'OTC', requiresPrescription: false, tag: '400g'),
];
