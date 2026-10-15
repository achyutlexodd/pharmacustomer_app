import 'package:flutter/foundation.dart';

class ProfileNotifier extends ChangeNotifier {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String address = '';
  String workAddress = 'Tower 4, Ecospace Business Park, Outer Ring Rd, Bellandur, Bengaluru 560103';
  String parentsAddress = '12th Main, Indiranagar, Bengaluru 560038';
  String? profileImagePath;

  void initialize({
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required String workAddress,
    required String parentsAddress,
    required String? profileImagePath,
  }) {
    this.name = name;
    this.phoneNumber = phoneNumber;
    this.email = email;
    this.address = address;
    this.workAddress = workAddress;
    this.parentsAddress = parentsAddress;
    this.profileImagePath = profileImagePath;
  }

  void update({
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required String workAddress,
    required String parentsAddress,
    required String? profileImagePath,
  }) {
    initialize(
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      workAddress: workAddress,
      parentsAddress: parentsAddress,
      profileImagePath: profileImagePath,
    );
    notifyListeners();
  }

  void updateAddress(String label, String value) {
    if (label == 'Home') address = value;
    if (label == 'Work / Office') workAddress = value;
    if (label == 'Parents’ Home') parentsAddress = value;
    notifyListeners();
  }
}
