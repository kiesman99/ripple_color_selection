import 'package:flutter/material.dart';

import 'package:ripple_color_selection/ripple_color_selection.dart';

class FullPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ColorSelectionController _controller = new ColorSelectionController();

    return Scaffold(
      body: Container(
        child: RippleColorSelection(
          controller: _controller,
        ),
      ),
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return "FullPage Selector";
  }


}
