import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../common/blocs/blocs.dart';
import '../../common/dialog/dialog.dart';
import '../../dashboard_pemilik_usaha/dashboard_pemilik_usaha.dart';
import '../../kelola_karyawan/kelola_karyawan.dart';
import '../../profile/page/page.dart';

class HomePemilikUsahaPage extends StatelessWidget {
  const HomePemilikUsahaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePemilikUsahaView();
  }
}

class HomePemilikUsahaView extends StatefulWidget {
  const HomePemilikUsahaView({super.key});

  @override
  State<HomePemilikUsahaView> createState() => _HomePemilikUsahaViewState();
}

class _HomePemilikUsahaViewState extends State<HomePemilikUsahaView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(LucideIcons.house),
            label: 'Dashboard',
          ),
          const NavigationDestination(
            icon: Icon(LucideIcons.usersRound),
            label: 'Kelola Karyawan',
          ),
          const NavigationDestination(
            icon: Icon(LucideIcons.user),
            label: 'Profile',
          ),
        ],
      ),

      body: BlocListener<NetworkCheckerBloc, NetworkCheckerState>(
        listener: (context, state) {
          if (!state.isConnected) {
            ShowToast.showEror('Tidak ada koneksi internet');
          }
        },
        child: IndexedStack(
          index: currentIndex,
          children: [
            const DashboardPemilikUsahaPage(),
            const KelolaKaryawanPage(),
            const ProfilePage(),
          ],
        ),
      ),
    );
  }
}
