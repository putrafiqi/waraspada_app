import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import 'authencation/bloc/auth_bloc.dart';
import 'common/blocs/blocs.dart';
import 'data/data.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final supabase = await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );
  final supabaseClient = supabase.client;

  Bloc.observer = TalkerBlocObserver();

  runApp(App(supabaseClient: supabaseClient));
}

class App extends StatelessWidget {
  const App({super.key, required this.supabaseClient});

  final SupabaseClient supabaseClient;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SurveiKaryawanRepository>(
          create:
              (context) => SurveiKaryawanRepositoryImpl(
                SurveiKaryawanApiImpl(supabaseClient),
              ),
        ),
        RepositoryProvider<DataVisualisasiRepository>(
          create:
              (context) => DataVisualisasiRepositoryImpl(
                dataVisualisasiApi: DataVisualisasiApiImpl(
                  supabaseClient: supabaseClient,
                ),
              ),
        ),
        RepositoryProvider<KelolaKaryawanRepository>(
          create:
              (context) => KelolaKaryawanRepositoryImpl(
                kelolaKaryawan: KelolaKaryawanApiImpl(supabaseClient),
              ),
        ),
        RepositoryProvider<AuthenticationRepository>(
          dispose: (repository) => repository.dispose(),
          create:
              (context) => AuthenticationRepositoryImpl(
                authenticationApi: AuthenticationApiImpl(
                  supabaseClient: supabaseClient,
                ),
              ),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(context.read<AuthenticationRepository>())
                    ..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create:
              (context) =>
                  NetworkCheckerBloc()
                    ..add(NetworkCheckerSubscriptionRequested()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Waraspada',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
