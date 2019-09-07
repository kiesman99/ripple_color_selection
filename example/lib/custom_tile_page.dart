import 'package:flutter/material.dart';
import 'package:ripple_color_selection/ripple_color_selection.dart';

class CustomTilePage extends StatelessWidget {
  ColorSelectionController _controller = new ColorSelectionController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RippleColorSelection.customTile(
            rippleExpandDuration: const Duration(milliseconds: 1500),
            controller: _controller,
            tileBuilder: (key, color, holder, value, onTap) {
              return RectangleTile(
                color: color,
                onTap: onTap,
                borderAnimation: holder,
                colorSelectionValue: value,
                key: key,
              );
            }),
      ),
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return "Custom Tile Page";
  }
}
