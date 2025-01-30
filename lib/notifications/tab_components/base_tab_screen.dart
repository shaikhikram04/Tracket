// Base class for tab screens with shared functionality
import 'package:flutter/material.dart';

abstract class BaseTabScreen extends StatefulWidget {
  const BaseTabScreen({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;
}
