import 'dart:math';

import 'package:flutter/material.dart';

enum SlideDirection { left, right }

class DraggableWidget extends StatefulWidget {
  const DraggableWidget({
    super.key,
    required this.child,
    this.onSlideOut,
    this.onPressed,
    required this.isEnableDrag,
  });
  final Widget child;
  final ValueChanged<SlideDirection>? onSlideOut;
  final VoidCallback? onPressed;
  final bool isEnableDrag;

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController restoreController;
  late Size screenSize;
  final _widgetKey = GlobalKey();
  Offset startOffset = Offset.zero;
  Offset panOffset = Offset.zero;
  Size size = Size.zero;
  double angle = 0;

  bool isSlideMade = false;
  double get outSizeLimit => size.width * 0.65;

  void onPanStart(DragStartDetails details) {
    if (!restoreController.isAnimating) {
      setState(() {
        startOffset = details.globalPosition;
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!restoreController.isAnimating) {
      setState(() {
        panOffset = details.globalPosition - startOffset;
        angle = currentAngle;
      });
    }
  }

  void onPanEnd(DragEndDetails details) {
    if (restoreController.isAnimating) {
      return;
    }
    final velocityX = details.velocity.pixelsPerSecond.dx;
    final positionX = currentPosition.dx;

    if (velocityX < -1000 || positionX < -outSizeLimit) {
      isSlideMade = widget.onSlideOut != null;
      widget.onSlideOut?.call(SlideDirection.left);
    }

    if (velocityX > 1000 || positionX > (screenSize.width - outSizeLimit)) {
      isSlideMade = widget.onSlideOut != null;
      widget.onSlideOut?.call(SlideDirection.right);
    }
    restoreController.forward();
  }

  void restoreAnimationListener() {
    if (restoreController.isCompleted) {
      restoreController.reset();
      panOffset = Offset.zero;
      isSlideMade = false;
      angle = 0;
      setState(() {});
    }
  }

  Offset get currentPosition {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  double get currentAngle {
    return currentPosition.dx < 0
        ? (pi * 0.2) * currentPosition.dx / size.width
        : currentPosition.dx + size.width > screenSize.width
            ? (pi * 0.2) *
                (currentPosition.dx + size.width - screenSize.width) /
                size.width
            : 0;
  }

  void getChildSize() {
    size =
        (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ??
            Size.zero;
  }

  @override
  void initState() {
    restoreController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(restoreAnimationListener);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        screenSize = MediaQuery.of(context).size;
        getChildSize();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    restoreController
      ..removeListener(restoreAnimationListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(key: _widgetKey, child: widget.child);
    if (!widget.isEnableDrag) return child;
    return GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: AnimatedBuilder(
          animation: restoreController,
          builder: (context, child) {
            final value = 1 - restoreController.value;
            return Transform.translate(
                offset: panOffset * value,
                child: Transform.rotate(
                    angle: angle * (isSlideMade ? 1 : value), child: child));
          },
          child: child,
        ));
  }
}
