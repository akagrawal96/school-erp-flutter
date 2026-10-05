import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';

void main() {
  test('window size classes follow the breakpoints', () {
    expect(WindowSize.fromWidth(360), WindowSize.compact);
    expect(WindowSize.fromWidth(599.9), WindowSize.compact);
    expect(WindowSize.fromWidth(600), WindowSize.medium);
    expect(WindowSize.fromWidth(839.9), WindowSize.medium);
    expect(WindowSize.fromWidth(840), WindowSize.expanded);
    expect(WindowSize.fromWidth(1280), WindowSize.expanded);
  });
}
