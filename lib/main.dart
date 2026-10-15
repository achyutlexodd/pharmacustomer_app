import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/providers/cart_notifier.dart';
import 'core/providers/profile_notifier.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartNotifier()),
        ChangeNotifierProvider(create: (_) => ProfileNotifier()),
      ],
      child: const App(),
    ),
  );
}
