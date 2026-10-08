import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/providers/cart_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartNotifier(),
      child: const App(),
    ),
  );
}
