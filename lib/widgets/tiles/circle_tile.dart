import 'package:flutter/material.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';
import 'package:ripple_color_selection/holder_classes/color_selection_border_animation_holder.dart';
import 'color_selection_tile.dart';


class CircleTile extends StatelessWidget implements ColorSelectionTile {

  CircleTile({this.color, this.onTap, this.borderAnimation, this.key, this.colorSelectionValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: color,
          elevation: colorSelectionValue.selectedColor == color ? 0.0 : 5.0,
          borderRadius: BorderRadius.circular(100.0),
          child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(100.0),
              child: AnimatedBuilder(
                  animation: borderAnimation.controller,
                  builder: (context, child) {
                    return Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            border: borderAnimation.controller
                                .value !=
                                0.0
                                ? Border.all(
                                color: Colors.white,
                                width: borderAnimation.animation
                                    .value)
                                : null));
                  })),
        ));
  }

  @override
  ColorSelectionBorderAnimationHolder borderAnimation;

  @override
  Color color;

  @override
  Function onTap;

  @override
  GlobalKey key;

  @override
  ColorSelectionValue colorSelectionValue;

}