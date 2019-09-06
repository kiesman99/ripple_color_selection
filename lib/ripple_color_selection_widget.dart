library ripple_color_selection;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ripple_color_selection/widgets/tiles/circle_tile.dart';
import 'package:ripple_color_selection/widgets/tiles/color_selection_tile.dart';

import 'controller/color_selection_controller.dart';
import 'holder_classes/color_selection_border_animation_holder.dart';

@immutable
class RippleColorSelection extends StatefulWidget {

  /// The [ColorSelectionController] that will be used by the actual Widget that
  /// uses [RippleColorSelection]
  final ColorSelectionController controller;

  /// The clickable [ColorSelectionTile] that will be rendered by the [RippleColorSelection] Widget
  final TileBuilder tileBuilder;

  /// The ripple [ColorSelectionTile] that will expand after an onClick of the [tileBuilder]
  final TileBuilder rippleTileBuilder;

  /// The duration the [rippleTileBuilder] Tile will need to expand fully
  final Duration rippleExpandDuration;

  /// The colors that will be selectable inside of the widget
  final List<Color> colors;

  // This is currently needed to copy the [tileBuilder] to [rippleTileBuilder]
  static TileBuilder _b = (key, color, animation, value, onTap) {
    return CircleTile(
      key: key,
      color: color,
      borderAnimation: animation,
      colorSelectionValue: value,
      onTap: onTap,
    );
  };

  /// The standard [RippleColorSelection] Widget
  /// It will render the [CircleTile] as the clickable and ripple Tile
  ///
  /// For an example see https://github.com/kiesman99/ripple_color_selection/blob/master/example/lib/full_page.dart
  RippleColorSelection({this.colors = Colors.primaries, @required this.controller, this.rippleExpandDuration = const Duration(seconds: 1)})
      : this.tileBuilder = _b,
        this.rippleTileBuilder = _b;

  /// In this [RippleColorSelection] Widget you can specify the clickable [ColorSelectionTile]
  ///
  /// The tile expanding when a Tile was clicked is the same as the one passed in [tileBuilder]
  ///
  /// For an example see https://github.com/kiesman99/ripple_color_selection/blob/master/example/lib/custom_tile_page.dart
  RippleColorSelection.customTile({
    this.colors = Colors.primaries,
    @required this.controller,
    @required this.tileBuilder,
    this.rippleExpandDuration = const Duration(seconds: 1)
  }) : this.rippleTileBuilder = tileBuilder;

  /// In this [RippleColorSelection] Widget you can specify the clickable [ColorSelectionTile] and also
  /// the expanding tile when one of the items were clicked
  ///
  /// For an example see https://github.com/kiesman99/ripple_color_selection/blob/master/example/lib/fully_custom_page.dart
  RippleColorSelection.custom(
      {this.colors = Colors.primaries,
        @required this.controller,
      @required this.tileBuilder,
      this.rippleExpandDuration = const Duration(seconds: 1),
      @required this.rippleTileBuilder});

  @override
  RippleColorSelectionState createState() => RippleColorSelectionState();
}

class RippleColorSelectionState extends State<RippleColorSelection>
    with TickerProviderStateMixin {
  /// The animation controller for the expanding circle,
  /// that will fill the page with a ripple effect
  AnimationController _backgroundRippleAnimation;

  /// This [Animation] is used to scale the ripple-circle
  /// underneath the tapped tile to expand it until it fill the whoel
  /// screen
  Animation<double> _backgroundRippleSizeAnimation;

  /// The Colors available for selection
  static List<Color> get colors => widget.colors;

  /// The actual offset where the user tapped a color,
  /// so that the ripple animation can start underneath the
  /// selected color tile
  ValueNotifier<Offset> _tapOffset = new ValueNotifier(new Offset(0, 0));

  /// The background color of the current widget
  /// it will change to the color tapped on, after the ripple animation
  /// [_backgroundRippleAnimation] has finished
  Color _backgroundColor = Colors.transparent;

  /// The position the user tapped on
  int _tappedPosition = -1;

  /// The start value of the ripple animation
  ///
  /// Because the scaling of the ripple animation
  /// needed a center pivot, I used a [Transform.scale]
  ///
  /// Duo this kind of transition the initial size
  /// of the ripple can't be 0.0, because scaling 0.0
  /// will not increase the ripple size
  ///
  /// 0.0 * 5 = 0.0
  /// 1.0 * 5 = 5.0
  /// 2.0 * 5 = 10.0
  /// ...
  ///
  /// => the initial size has to be >= 1
  static const double _initialRippleSize = 20.0;

  /// Each color tile has a separate [Animation] to control the border size
  ///
  /// If a user taps on a color-tile it'll get a border
  ///
  /// If a user taps on a new color-tile the old one's border
  /// will decrease until there is no more and the new one will just get a new border
  static List<ColorSelectionBorderAnimationHolder> _borderAnimations;

  ColorSelectionValue get _value => widget.controller.value;

  set _value(ColorSelectionValue value) {
    widget.controller.value = value;
  }

  @override
  void initState() {
    //init [_borderAnimations]
    _borderAnimations = new List.generate(colors.length, (position) {
      AnimationController controller = new AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));

      Animation animation =
          Tween<double>(begin: 0.0, end: 10.0).animate(controller);

      return ColorSelectionBorderAnimationHolder(controller, animation);
    });

    _backgroundRippleAnimation =
        new AnimationController(vsync: this, duration: widget.rippleExpandDuration);

    _backgroundRippleSizeAnimation = new Tween<double>(begin: 0.0, end: 100.0)
        .animate(_backgroundRippleAnimation);

    _backgroundRippleAnimation.addListener(() {
      if (_backgroundRippleAnimation.isCompleted) {
        _backgroundColor = widget.controller.color;
      }
    });

    super.initState();
  }

  void _didChangeColorValue(int position, Key key) {
    // if the tapped tile is the current selected => do nothing
    if (_tappedPosition == position) return;

    // update the [effectiveController.value.color] to the selected color
    _value = _value.copyWith(color: colors.elementAt(position));

    // update the offset to the position of the selected tile
    updateTapOffset(key);

    // start the ripple animation
    _backgroundRippleAnimation.forward(from: 0.0);
    // start the border expanding animation
    _borderAnimations.elementAt(position).controller.forward(from: 0.0);

    // if there was an tile previously selected reverse the border animation,
    // so that there is no more border around the old selected tile
    if (_tappedPosition != -1) {
      _borderAnimations
          .elementAt(_tappedPosition)
          .controller
          .reverse(from: 1.0);
    }

    _tappedPosition = position;
  }

  TileBuilder builder;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      color: _backgroundColor,
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          ValueListenableBuilder<Offset>(
            valueListenable: _tapOffset,
            child: AnimatedBuilder(
              animation: _backgroundRippleAnimation,
              builder: (context, child) {
                // TODO: Make expanding relative to parent size. Currently the size the ripple will expand to is given by constant values -> make dynamic
                return Transform.scale(
                  scale: _backgroundRippleSizeAnimation.value,
                  child: widget.rippleTileBuilder(
                      null,
                      _value.selectedColor,
                      null,
                      _value,
                          null)
                );
              },
            ),
            builder: (context, value, child) {
              // TODO: center the widget in relative position to the clicked tile. Previously there was a const size of the ripple tile, but now it behaves different
              return Transform.translate(
                  offset: _tapOffset.value, child: child);
            },
          ),
          _buildGridView()
        ],
      ),
    );

    return child;
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(20.0),
      itemCount: colors.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemBuilder: (context, position) {
        // generate a new key for each tile in the gridview
        GlobalKey key = new GlobalKey();

        return widget.tileBuilder(
            key,
            colors.elementAt(position),
            _borderAnimations.elementAt(position),
            _value,
            () => _didChangeColorValue(position, key));
      },
    );
  }

  // TODO: File an issue and do a push request on this bug
  /// This function will get the [Offset] of the tapped tile and
  /// update the [_tapOffset] to this value
  ///
  /// Later this set value will be used to position the ripple
  /// circle to the offset
  void updateTapOffset(GlobalKey key) {
    EdgeInsets systemPadding = MediaQuery.of(context).padding;
    // TODO: File an issue that the position returned from [localToGlobal] is pushed 24 pixels down on dy -> This is probably caused, because the navigation bar is calculated as a value too
    final RenderBox tileRenderBox = key.currentContext.findRenderObject();
    setState(() {
      _tapOffset.value = tileRenderBox.localToGlobal(
          // Maybe [systemPadding.top] needs to be changed to 24
          // TODO: Change to [Offset(tileRenderBox.size.width / 2, tileRenderBox.size.height / 2] when bug is filed and corrected
          Offset(
              (tileRenderBox.size.width / 2) - (_initialRippleSize / 2),
              (tileRenderBox.size.height / 2) -
                  (_initialRippleSize / 2) -
                  systemPadding.top));
    });
  }

  @override
  void dispose() {
    _backgroundRippleAnimation.dispose();
    for(ColorSelectionBorderAnimationHolder holder in _borderAnimations)
      holder.controller.dispose();
    super.dispose();
  }
}
