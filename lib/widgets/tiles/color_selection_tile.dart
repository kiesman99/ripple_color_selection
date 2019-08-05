import 'package:flutter/material.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';
import 'package:ripple_color_selection/holder_classes/color_selection_border_animation_holder.dart';

/// You should use the [color] value to assign the color to the tile
///
/// You should use the [onTap] value to assign the onTap function provided
/// by the package
///
/// You should use the [key] value to bind a key to the generated Tile
/// this key is used to determine the offset of the rendered widget to
/// create the ripple effect
abstract class ColorSelectionTile {
  /// The color of the given tile
  Color color;

  /// This is the function called by the ColorSelector if a tile was tapped
  Function onTap;

  /// This key will be generated, but **MUST** be inserted.
  /// It is needed to calculate the Position of the tap
  GlobalKey key;

  /// This will hold the specific borderAnimation created for the tile
  ColorSelectionBorderAnimationHolder borderAnimation;

  /// This will give the Tile information on wether it should render it's
  /// border or not
  ColorSelectionValue colorSelectionValue;

  ColorSelectionTile({
    @required this.color,
    @required this.onTap,
    @required this.key,
    @required this.borderAnimation,
    @required this.colorSelectionValue
  });
}