import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          NavigationDestination(
            icon: Icon(LucideIcons.house),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.usersRound),
            label: 'Kelola Karyawan',
          ),
          NavigationDestination(icon: Icon(LucideIcons.user), label: 'Profile'),
        ],
      ),

      body: IndexedStack(
        index: currentIndex,
        children: [
          DashboardPemilikUsahaPage(),
          KelolaKaryawanPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
