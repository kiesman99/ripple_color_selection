import 'package:flutter/material.dart';
import 'package:ripple_color_selection/ripple_color_selection.dart';

/// This page has a [CircleTile] as tapable widget
/// and a [RectangleTile] as the expanding widget, that
/// will grow underneath the clicked color
class FullyCustomPage extends StatelessWidget {
  ColorSelectionController _controller = new ColorSelectionController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RippleColorSelection.custom(
          rippleExpandDuration: const Duration(milliseconds: 1500),
          controller: _controller,
          tileBuilder: (key, color, holder, value, onTap) {
            return RectangleTile(
              color: color,
              onTap: onTap,
              borderAnimation: holder,
              colorSelectionValue: value,
              key: key,
              hasShadow: false,
            );
          },
          rippleTileBuilder: (key, color, holder, value, onTap) {
            return StarTile(
              color: color,
              onTap: onTap,
              borderAnimation: holder,
              colorSelectionValue: value,
              key: key,
            );
          },
        ),
      ),
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return "Fully Custom Page";
  }
}
