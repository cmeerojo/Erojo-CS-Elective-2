import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/jdm_showroom_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(isOptional: true);
  final url = dotenv.env['SUPABASE_URL'];
  final key = dotenv.env['SUPABASE_ANON_KEY'];
  if (url != null && url.isNotEmpty && key != null && key.isNotEmpty) {
    await Supabase.initialize(url: url, publishableKey: key);
  }

  runApp(const ProviderScope(child: JdmApp()));
}

class JdmApp extends StatelessWidget {
  const JdmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'JDM Showroom',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.jdmTheme,
        home: const JdmShowroomScreen(),
      ),
    );
  }
}
