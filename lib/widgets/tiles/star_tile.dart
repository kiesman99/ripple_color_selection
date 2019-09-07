import 'package:flutter/material.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';
import 'package:ripple_color_selection/holder_classes/color_selection_border_animation_holder.dart';
import 'color_selection_tile.dart';

class StarTile extends ColorSelectionTile {
  @override
  Path get path => new Path()
    ..moveTo(size.width / 2, 0)
    ..lineTo(size.width, 3 * size.height / 4)
    ..lineTo(0, 3 * size.height / 4)
    ..lineTo(size.width / 2, 0)
    ..moveTo(size.width / 2, size.height)
    ..lineTo(0, size.height / 4)
    ..lineTo(size.width, size.height / 4)
    ..lineTo(size.width / 2, size.height);

  @override
  CustomClipper get customClipper => Clipper(path: path);

  @override
  double get padding => 5.0;

  StarTile(
      {@required Color color,
      @required Function onTap,
      @required ColorSelectionBorderAnimationHolder borderAnimation,
      @required ColorSelectionValue colorSelectionValue,
      @required GlobalKey key,
      bool hasShadow = true})
      : super(
            color: color,
            onTap: onTap,
            key: key,
            borderAnimation: borderAnimation,
            colorSelectionValue: colorSelectionValue,
            hasShadow: hasShadow);
}
