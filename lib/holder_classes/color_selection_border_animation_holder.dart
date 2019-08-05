import 'package:flutter/animation.dart' show AnimationController, Animation;

/// This is a simple holder for both the borderAnimation and the borderAnimationController
///
/// It is used to declutter the use of a Map<String, dynamic>
class ColorSelectionBorderAnimationHolder {

  AnimationController controller;
  Animation animation;

  ColorSelectionBorderAnimationHolder(this.controller, this.animation);

}