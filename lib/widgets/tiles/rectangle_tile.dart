import 'package:flutter/material.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';
import 'package:ripple_color_selection/holder_classes/color_selection_border_animation_holder.dart';
import 'color_selection_tile.dart';

class RectangleTile extends ColorSelectionTile {
  @override
  Path get path => new Path()
    ..addRect(Rect.fromCenter(
        width: size.width,
        height: size.height,
        center: Offset(size.width / 2, size.height / 2)));

  @override
  CustomClipper get customClipper => Clipper(path: path);

  @override
  double get padding => 5.0;

  RectangleTile(
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
