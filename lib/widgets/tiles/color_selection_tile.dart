import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ripple_color_selection/controller/color_selection_controller.dart';
import 'package:ripple_color_selection/holder_classes/color_selection_border_animation_holder.dart';

// TODO: simplify the parameters that need to be passed
typedef TileBuilder<Tile extends ColorSelectionTile> = Tile Function(
    GlobalKey key,
    Color color,
    ColorSelectionBorderAnimationHolder borderAnimation,
    ColorSelectionValue colorSelectionValue,
    Function onTap
    );

/// You should use the [color] value to assign the color to the tile
///
/// You should use the [onTap] value to assign the onTap function provided
/// by the package
///
/// You should use the [key] value to bind a key to the generated Tile
/// this key is used to determine the offset of the rendered widget to
/// create the ripple effect
abstract class ColorSelectionTile extends StatelessWidget {



  // Size of a tile
  Size get size => new Size(50.0, 50.0);

  CustomClipper get customClipper;

  /// The color of the given tile
  final Color color;

  /// This is the function called by the ColorSelector if a tile was tapped
  final Function onTap;

  /// This key will be generated, but **MUST** be inserted.
  /// It is needed to calculate the Position of the tap
  final GlobalKey key;

  /// This will hold the specific borderAnimation created for the tile
  final ColorSelectionBorderAnimationHolder borderAnimation;

  double get padding;

  _ClipperBorder get border =>
      _ClipperBorder(
          borderWidth: borderAnimation.animation.value,
          elevation: colorSelectionValue.selectedColor == color ? 0.0 : 2.0,
          path: path
      );

  /// This is the path that will be rendered as the tile
  Path get path;

  ColorSelectionTile({
    @required this.color,
    @required this.key,
    @required this.borderAnimation,
    @required this.colorSelectionValue,
    @required this.onTap
  }) :
        super(key: key);

  /// This will give the Tile information on wether it should render it's
  /// border or not
  final ColorSelectionValue colorSelectionValue;

  Widget get actualTile {
    return Material(
      color: color,
      child: InkWell(
          onTap: onTap,
          child: SizedBox.fromSize(size: size,)),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(borderAnimation == null)
      return ClipPath(
          clipper: customClipper,
          child: actualTile
      );

    return Padding(
        padding: EdgeInsets.all(padding),
        child: AnimatedBuilder(
          animation: borderAnimation.controller,
          builder: (_, child){
            return CustomPaint(
              painter: border,
              size: size,
              child: child
            );
          },
          child: ClipPath(
              clipper: customClipper,
              child: actualTile
          ),
        )
    );
  }
}

class _ClipperBorder extends CustomPainter {

  final double borderWidth;
  final double elevation;
  final Path path;
  final Color borderColor;
  final PaintingStyle borderPaintingSytle;

  _ClipperBorder({
    @required this.borderWidth,
    @required this.elevation,
    @required this.path,
    this.borderColor = Colors.white,
    this.borderPaintingSytle = PaintingStyle.stroke
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint border = new Paint()
      ..strokeWidth = borderWidth
      ..color = borderColor
      ..style = borderPaintingSytle;

    Paint shadow = new Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, elevation);

    canvas.drawPath(path, shadow);

    if(borderWidth > 0)
      canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class Clipper extends CustomClipper<Path> {

  final Path path;

  Clipper({
    @required this.path
  });

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}