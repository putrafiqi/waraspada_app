import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../common/blocs/blocs.dart';
import '../../common/dialog/dialog.dart';
import '../../dashboard_karyawan/dashboard_karyawan.dart';
import '../../profile/page/page.dart';

class HomeKaryawanPage extends StatelessWidget {
  const HomeKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeKaryawanView();
  }
}

class HomeKaryawanView extends StatefulWidget {
  const HomeKaryawanView({super.key});

  @override
  State<HomeKaryawanView> createState() => _HomeKaryawanViewState();
}

class _HomeKaryawanViewState extends State<HomeKaryawanView> {
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
          children: [const DashboardKaryawanPage(), const ProfilePage()],
        ),
      ),
    );
  }
}
