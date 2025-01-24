import 'package:ch_vote/app.dart';
import 'package:ch_vote/model/hive_voters_info.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize Hive and Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(HiveVotersInfoAdapter());

  // Open a box
  await Hive.openBox<HiveVotersInfo>('votersBox');

  runApp(const MyApp());
}
