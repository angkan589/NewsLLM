import 'package:flutter_test/flutter_test.dart';
import 'package:newsllm/core/navigation/main_navigation_bar.dart';

void main() {
  final controller = NavigationVisibilityController.instance;

  setUp(() {
    controller.show();
  });

  test('navigation is visible by default', () {
    expect(controller.visible, isTrue);
  });

  test('navigation can be hidden', () {
    controller.hide();

    expect(controller.visible, isFalse);
  });

  test('navigation can be shown after being hidden', () {
    controller.hide();
    controller.show();

    expect(controller.visible, isTrue);
  });
}
