import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/local/app_data_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDataStore.instance.load();
  runApp(const ProviderScope(child: MilqoApp()));
}
