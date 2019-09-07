import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color, Colors, ValueNotifier;

/// The current color State for an [RippleColorSelection]
@immutable
class ColorSelectionValue {
  /// The current color Value of the [ColorSelectionValue]
  final Color selectedColor;

  ColorSelectionValue({this.selectedColor = Colors.transparent});

  ColorSelectionValue copyWith({Color color}) {
    return ColorSelectionValue(selectedColor: color ?? selectedColor);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"color": selectedColor};
  }
}

/// A controller used for [RippleColorSelection]
/// It handles changing the color state and notifies it's listeners
class ColorSelectionController extends ValueNotifier<ColorSelectionValue> {
  /// The constructor for the [ColorSelectionController]
  ///
  /// if the initial [value] is null the color will be [Colors.transparent]
  ColorSelectionController({ColorSelectionValue value})
      : super(value == null ? ColorSelectionValue() : value);

  /// Get the current [color] State
  Color get color => value.selectedColor;

  /// Set a new [color] state
  set color(Color color) {
    value = value.copyWith(color: color);
  }
}
