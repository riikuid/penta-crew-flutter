import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/api_json.dart';

void main() {
  group('unwrapData', () {
    test('returns body["data"] when present', () {
      expect(unwrapData({'message': 'ok', 'data': 1}), 1);
      expect(unwrapData({'data': null}), isNull);
    });

    test('returns the body itself otherwise', () {
      expect(unwrapData({'id': 1}), {'id': 1});
      expect(unwrapData([1, 2]), [1, 2]);
    });
  });

  group('asObject', () {
    test('enveloped and bare objects', () {
      expect(asObject({'data': {'id': 1}}), {'id': 1});
      expect(asObject({'id': 1}), {'id': 1});
    });

    test('converts Map<dynamic, dynamic> to Map<String, dynamic>', () {
      final Map<dynamic, dynamic> raw = {'id': 1};
      expect(asObject(raw), isA<Map<String, dynamic>>());
    });

    test('throws FormatException on non-object', () {
      expect(() => asObject({'data': [1]}), throwsFormatException);
      expect(() => asObject('text'), throwsFormatException);
      expect(() => asObject(null), throwsFormatException);
    });
  });

  group('asList', () {
    test('enveloped and bare lists', () {
      expect(asList({'data': [{'id': 1}, {'id': 2}]}), [{'id': 1}, {'id': 2}]);
      expect(asList([{'id': 1}]), [{'id': 1}]);
      expect(asList({'data': []}), isEmpty);
    });

    test('throws FormatException on non-list', () {
      expect(() => asList({'data': {'id': 1}}), throwsFormatException);
      expect(() => asList({'id': 1}), throwsFormatException);
    });

    test('throws when an element is not an object', () {
      expect(() => asList([1, 2]), throwsA(isA<TypeError>()));
    });
  });
}
