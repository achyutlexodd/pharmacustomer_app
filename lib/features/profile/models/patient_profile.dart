enum PatientRelation { self, father, mother, son, daughter, other }

extension PatientRelationLabel on PatientRelation {
  String get label => switch (this) {
    PatientRelation.self => 'Self',
    PatientRelation.father => 'Father',
    PatientRelation.mother => 'Mother',
    PatientRelation.son => 'Son',
    PatientRelation.daughter => 'Daughter',
    PatientRelation.other => 'Other',
  };
}

class PatientProfile {
  const PatientProfile({
    required this.id,
    required this.name,
    required this.relation,
    this.customRelationLabel,
    this.dob,
    this.gender = '',
    this.photoUrl,
    this.phoneNumber = '',
    this.chronicConditions = const [],
    this.allergies = const [],
    this.prescriptionCount = 0,
    required this.lastUpdated,
    this.isSelf = false,
    this.isDefault = false,
  });

  final String id, name, gender;
  final PatientRelation relation;
  final String? customRelationLabel, photoUrl;
  final DateTime? dob;
  final String phoneNumber;
  final List<String> chronicConditions, allergies;
  final int prescriptionCount;
  final DateTime lastUpdated;
  final bool isSelf, isDefault;

  String get relationName =>
      relation == PatientRelation.other &&
          customRelationLabel?.isNotEmpty == true
      ? customRelationLabel!
      : relation.label;

  PatientProfile copyWith({
    String? name,
    PatientRelation? relation,
    String? customRelationLabel,
    DateTime? dob,
    String? gender,
    String? phoneNumber,
    List<String>? chronicConditions,
    List<String>? allergies,
    bool? isDefault,
  }) => PatientProfile(
    id: id,
    name: name ?? this.name,
    relation: relation ?? this.relation,
    customRelationLabel: customRelationLabel ?? this.customRelationLabel,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    photoUrl: photoUrl,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    chronicConditions: chronicConditions ?? this.chronicConditions,
    allergies: allergies ?? this.allergies,
    prescriptionCount: prescriptionCount,
    lastUpdated: DateTime.now(),
    isSelf: isSelf,
    isDefault: isDefault ?? this.isDefault,
  );
}
