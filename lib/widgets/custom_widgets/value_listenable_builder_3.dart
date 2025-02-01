import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget Function(BuildContext context, A firstValue, B secondValue,
      C thirdValue, Widget? child) builder;
  final Widget? child;

  const ValueListenableBuilder3({
    Key? key,
    required this.first,
    required this.second,
    required this.third,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, firstValue, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, secondValue, _) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (context, thirdValue, _) {
                return builder(
                  context,
                  firstValue,
                  secondValue,
                  thirdValue,
                  child,
                );
              },
            );
          },
        );
      },
    );
  }
}
