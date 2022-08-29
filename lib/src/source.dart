import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import './constants.dart';

class WebSmoothScroll extends StatefulWidget {
  /// Scroll Controller for controlling the scroll behaviour manually
  /// so we can animate to next scrolled position and avoid the jerky movement
  /// of default scroll
  final ScrollController controller;

  /// Child scrollable widget.
  final Widget child;

  /// Extra scroll offset to be added while the scroll is happened
  /// Default value is 100
  /// You can try it for a range of 10 - 300 or keep it 0
  final int scrollOffset;

  /// Duration/length for how long the animation should go
  /// after the scroll has happened
  /// Default value is 600ms
  final int animationDuration;

  /// Curve of the animation.
  final Curve curve;

  const WebSmoothScroll({
    Key? key,
    required this.controller,
    required this.child,
    this.scrollOffset = defaultScrollOffset,
    this.animationDuration = defaultAnimationDuration,
    this.curve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  State<WebSmoothScroll> createState() => _WebSmoothScrollState();
}

class _WebSmoothScrollState extends State<WebSmoothScroll> {
  // data variables
  double _scroll = 0;

  @override
  void initState() {
    super.initState();

    // Adding listener so if value of listener is changed outside our class
    // it gets updated here to avoid unwanted scrolling behavior
    widget.controller.addListener(scrollListener);
  }

  @override
  void didUpdateWidget(covariant WebSmoothScroll oldWidget) {
    // In case if window is resized the widget gets initialized again without listener
    // adding it back again to resolve unwanted issues
    widget.controller.removeListener(scrollListener);
    widget.controller.addListener(scrollListener);
    // if (widget.controller.hasListeners == false) {
    //   widget.controller.addListener(scrollListener);
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: onPointerSignal,
      child: widget.child,
    );
  }

  /// Member Functions
  ///
  ///
  void scrollListener() => _scroll = widget.controller.offset;

  void onPointerSignal(PointerSignalEvent event) {
    // Initializing default animation duration length in MS
    int millis = widget.animationDuration;

    if (event is PointerScrollEvent) {
      // Checking if scroll happened is up or down
      if (event.scrollDelta.dy > 0) {
        // Adding the extra offset to over scroll done by user
        _scroll += (event.scrollDelta.dy + widget.scrollOffset);
      } else {
        // Adding the extra offset to over scroll done by user
        // here we are subtracting the widget scroll offset because
        // [event.scrollDelta.dy] value is negative so to
        // increase overall offset we are subtracting because
        // negative - negative values get added
        _scroll += (event.scrollDelta.dy - widget.scrollOffset);
      }

      // Checking if scroll has reached to bottom of the screen
      if (_scroll > widget.controller.position.maxScrollExtent) {
        _scroll = widget.controller.position.maxScrollExtent;
        millis = widget.animationDuration ~/ 4;
      }

      // Checking if scroll has gone before the starting point
      // so resetting it back to 0
      if (_scroll < 0) {
        _scroll = 0;
        millis = widget.animationDuration ~/ 4;
      }
      
      if(event.scrollDelta.dy<90&&event.scrollDelta.dy>-90){
        //If scroll through touchpad/trackpad of a laptop.
        widget.controller.jumpTo(
          _scroll
        );
      }else{
        //If scroll through mouse wheel.
        
        // Animating to the calculated scroll position
        widget.controller.animateTo(
          _scroll,
          duration: Duration(milliseconds: millis),
          curve: widget.curve,
        );
      }
    }
  }
}
