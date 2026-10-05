import '../../../core/json/converters.dart';
import 'user.dart';

/// Profile fields shared by register (§2.2) and update profile (§2.7).
///
/// Lives in `models/` so other features (profile's E2 form) can build it
/// without importing `repositories/` (implementation plan §2.3).
class ProfileFields {
  const ProfileFields({
    required this.name,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.branchId,
    required this.address,
  });

  final String name;
  final String phone;
  final DateTime dateOfBirth;
  final Gender gender;
  final int branchId;
  final String address;

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'date_of_birth': const DateOnlyConverter().toJson(dateOfBirth),
    'gender': gender.name,
    'branch_id': branchId,
    'address': address,
  };
}
