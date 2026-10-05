import 'package:freezed_annotation/freezed_annotation.dart';

part 'section.freezed.dart';

/// State of one independently loaded block of a multi-section screen
/// (implementation-plan §2.7, D-05). Home holds four of these; each clears
/// its own skeleton or shows its own inline error as its request completes.
@freezed
sealed class Section<T> with _$Section<T> {
  const factory Section.loading() = SectionLoading<T>;
  const factory Section.loaded(T data) = SectionLoaded<T>;
  const factory Section.error(String message) = SectionError<T>;
}
