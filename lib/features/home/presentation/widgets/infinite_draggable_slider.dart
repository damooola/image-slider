import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_slider/features/home/presentation/widgets/draggable_widget.dart';

class InifiniteDraggableSlider extends StatefulWidget {
  const InifiniteDraggableSlider({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.index = 0,
  });

  final Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final int index;
  @override
  State<InifiniteDraggableSlider> createState() =>
      _InifiniteDraggableSliderState();
}

class _InifiniteDraggableSliderState extends State<InifiniteDraggableSlider> {
  double default18DAngle = pi * 0.1;

  Offset getOffset(int stackIndex) {
    return {
          0: const Offset(0, 45),
          1: const Offset(-100, 30),
          2: const Offset(100, 30),
        }[stackIndex] ??
        const Offset(0, 0);
  }

  double getAngle(int stackIndex) {
    return {0: 0.0, 1: -default18DAngle, 2: default18DAngle}[stackIndex] ?? 0.0;
  }

  double getScale(int stackIndex) {
    return {0: 0.6, 1: 0.8, 2: 0.85}[stackIndex] ?? 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(4, (stackIndex) {
        return Transform.translate(
            offset: getOffset(stackIndex),
            child: Transform.scale(
              scale: getScale(stackIndex),
              child: Transform.rotate(
                  angle: getAngle(stackIndex),
                  child: DraggableWidget(
                      child: widget.itemBuilder(context, stackIndex),
                      isEnableDrag: stackIndex == 4)),
            ));
      }),
    );
  }
}
