import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await ApiService.getUserData();
    setState(() {
      _user = userData;
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Konfirmasi Logout'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoggingOut = true);

    final result = await ApiService.logout();

    if (mounted) {
      setState(() => _isLoggingOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: const Color(0xFF04325F),
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Pindah ke Login Screen dan hapus semua stack navigasi sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user dari _user jika tersedia, atau gunakan fallback visual
    final String namaLengkap = _user?['nama_lengkap'] ?? 'Pengguna';
    final String email = _user?['email'] ?? 'user@example.com';
    final String nomorRm = _user?['nomor_rm'] ?? '-';
    final String nik = _user?['nik'] ?? '-';
    final String role = _user?['role'] ?? 'Mahasiswa / Staf';
    final String nip = _user?['nip'] ?? '-';
    final String faculty = _user?['faculty'] ?? 'Fakultas Teknologi Informasi';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Color(0xFF04325F),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KARTU IDENTITAS PENGGUNA (USER INFO CARD)
            _buildUserCard(
              nama: namaLengkap,
              email: email,
              nomorRm: nomorRm,
              nik: nik,
              role: role,
              nip: nip,
              faculty: faculty,
            ),

            const SizedBox(height: 24),

            // 2. PENGATURAN AKUN
            _buildSectionHeader('Pengaturan Akun'),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profil',
                subtitle: 'Perbarui nomor telepon atau email',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Edit Profil dibuka')),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: 'Ubah Kata Sandi',
                subtitle: 'Jaga keamanan akun Anda',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Ubah Kata Sandi dibuka'),
                    ),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            // 3. AKTIVITAS & PERSONALISASI
            _buildSectionHeader('Aktivitas & Buku'),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.history_rounded,
                title: 'Riwayat Akses',
                subtitle: 'Katalog & Flipbook yang terakhir dibuka',
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              _buildMenuItem(
                icon: Icons.bookmark_border_rounded,
                title: 'Koleksi Tersimpan (Bookmark)',
                subtitle: 'Buku & katalog favorit Anda',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 24),

            // 4. PENGATURAN APLIKASI
            _buildSectionHeader('Pengaturan Aplikasi'),
            _buildMenuCard([
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF04325F).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: const Color(0xFF04325F),
                  ),
                ),
                title: const Text(
                  'Tampilan Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: Text(
                  _isDarkMode ? 'Mode Gelap Aktif' : 'Mode Terang Aktif',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: _isDarkMode,
                activeColor: const Color(0xFF04325F),
                onChanged: (val) {
                  setState(() {
                    _isDarkMode = val;
                  });
                },
              ),
              const Divider(height: 1, indent: 56),
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF04325F).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF04325F),
                  ),
                ),
                title: const Text(
                  'Notifikasi Aplikasi',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: Text(
                  _isNotificationEnabled
                      ? 'Pemberitahuan aktif'
                      : 'Pemberitahuan dinonaktifkan',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: _isNotificationEnabled,
                activeColor: const Color(0xFF04325F),
                onChanged: (val) {
                  setState(() {
                    _isNotificationEnabled = val;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            // 5. BANTUAN & INFORMASI
            _buildSectionHeader('Bantuan & Informasi'),
            _buildMenuCard([
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Pusat Bantuan (Help Center)',
                subtitle: 'FAQ dan Kontak Admin RS / Kampus',
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'Tentang Aplikasi',
                subtitle: 'Versi 1.0.0 • Syarat & Ketentuan',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Prakerin ITS App',
                    applicationVersion: '1.0.0',
                  );
                },
              ),
            ]),

            const SizedBox(height: 32),

            // 6. KELUAR (LOGOUT)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoggingOut ? null : _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFFF4D4F,
                  ), // Warna merah kontras
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoggingOut
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Keluar Akun (Logout)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF04325F),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF04325F).withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF04325F)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }

  Widget _buildUserCard({
    required String nama,
    required String email,
    required String nomorRm,
    required String nik,
    required String role,
    required String nip,
    required String faculty,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF04325F), Color(0xFF0A4F8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF04325F).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFFFD166),
                child: Text(
                  nama.isNotEmpty ? nama[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF04325F),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD166),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            role,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF04325F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCardDetail('No. RM', nomorRm),
                Container(height: 24, width: 1, color: Colors.white24),
                _buildCardDetail('NIK', nik),
                if (nip != '-') ...[
                  Container(height: 24, width: 1, color: Colors.white24),
                  _buildCardDetail('NIP', nip),
                ],
              ],
            ),
          ),
          if (faculty != '-') ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 14,
                  color: Color(0xFFFFD166),
                ),
                const SizedBox(width: 6),
                Text(
                  faculty,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
