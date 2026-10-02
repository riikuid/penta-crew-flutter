import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';
part 'branch.g.dart';

/// Operating branch a crew member belongs to (`{ id, name }`, contract §1).
/// Chosen at registration; events are filtered by it (D-10).
@freezed
abstract class Branch with _$Branch {
  const factory Branch({required int id, required String name}) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}
