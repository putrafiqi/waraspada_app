import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authencation/authentication.dart';
import '../../common/widget/widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return SingleChildScrollView(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return Column(
              spacing: 16,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.logoUrl),
                      colorFilter: const ColorFilter.mode(
                        Colors.black26,
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: CachedNetworkImageProvider(
                        user.profileUrl,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile', style: textTheme.bodyLarge),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              title: Text(
                                'Nama',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Tooltip(
                                message: user.namaLengkap,
                                child: Text(
                                  user.namaLengkap,
                                  textAlign: TextAlign.end,

                                  maxLines: 1,
                                  style: textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                'Email',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Tooltip(
                                message: user.email,
                                child: Text(
                                  user.email,
                                  textAlign: TextAlign.end,

                                  maxLines: 1,
                                  style: textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                'Jenis Kelamin',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 125,
                                child: Tooltip(
                                  message: user.jenisKelamin,
                                  child: Text(
                                    textAlign: TextAlign.end,
                                    user.jenisKelamin,
                                    maxLines: 1,
                                    style: textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                'Role',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Text(
                                user.role == 'pemilik_usaha'
                                    ? 'Pemilik Usaha'
                                    : 'Karyawan',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.role == 'pemilik_usaha'
                            ? 'Profile Usaha'
                            : 'Profile Tempat Kerja',
                        style: textTheme.bodyLarge,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              title: Text(
                                'Nama',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 150,
                                child: Tooltip(
                                  message: user.namaUsaha,
                                  child: Text(
                                    user.namaUsaha,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,

                                    style: textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                'Alamat',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 150,
                                child: Tooltip(
                                  message: user.alamatUsaha,
                                  child: Text(
                                    user.alamatUsaha,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,

                                    style: textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: Colors.red,
                    titleTextStyle: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                    title: Text('Logout', textAlign: TextAlign.center),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                        (route) => false,
                      );
                      context.read<AuthBloc>().add(AuthSignOutRequested());
                    },
                  ),
                ),
              ],
            );
          }
          return const Loader();
        },
      ),
    );
  }
}
