import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';

void main() {
  test('Empty ColorSelctionValue', () {
    ColorSelectionValue value = ColorSelectionValue();
    expect(Colors.transparent, value.selectedColor);
  });

  test('ColorSelectionValue with parameter', () {
    ColorSelectionValue value =
        ColorSelectionValue(selectedColor: Colors.green);
    expect(Colors.green, value.selectedColor);
  });

  test('ColorSelectionController empty', () {
    ColorSelectionController controller = ColorSelectionController();
    expect(Colors.transparent, controller.value.selectedColor);
  });

  test('ColorSelectionController with parameter', () {
    ColorSelectionController controller = ColorSelectionController(
        value: ColorSelectionValue(selectedColor: Colors.green));
    expect(Colors.green, controller.value.selectedColor);
  });

  test('ColorSelectionController change value', () {
    ColorSelectionController controller = ColorSelectionController(
        value: ColorSelectionValue(selectedColor: Colors.green));
    expect(Colors.green, controller.value.selectedColor);

    controller.value = ColorSelectionValue(selectedColor: Colors.purple);
    expect(Colors.purple, controller.value.selectedColor);
  });

  test('ColorSelectionController listener', () {
    Color c = Colors.transparent;

    ColorSelectionController controller = ColorSelectionController(
        value: ColorSelectionValue(selectedColor: Colors.green));
    expect(Colors.green, controller.value.selectedColor);

    controller.addListener(() {
      // simple listener
      c = controller.value.selectedColor;
    });

    controller.value = ColorSelectionValue(selectedColor: Colors.purple);
    expect(Colors.purple, c);

    controller.value = ColorSelectionValue(selectedColor: Colors.redAccent);
    expect(Colors.redAccent, c);
  });
}
