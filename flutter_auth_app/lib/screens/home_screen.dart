import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      backgroundImage: AssetImage('assets/images/logo.webp'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RS Hasta Brata', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF04325F))),
                        Text('Halo, Selamat Pagi', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
                IconButton(icon: const Icon(Icons.notifications_none, color: Color(0xFF04325F), size: 28), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [const Color(0xFF04325F).withOpacity(0.9), Colors.transparent],
                    begin: Alignment.centerLeft, end: Alignment.centerRight,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFC107), borderRadius: BorderRadius.circular(4)),
                      child: const Text('Info Kesehatan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF04325F))),
                    ),
                    const SizedBox(height: 12),
                    const Text('Pentingnya Cek\nKesehatan Rutin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Lakukan medical check-up secara\nberkala untuk deteksi dini dan...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Layanan Cepat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF04325F))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickServiceMenu(Icons.medical_services_outlined, 'Booking\nDokter', false),
                _buildQuickServiceMenu(Icons.calendar_month_outlined, 'Cek Jadwal', false),
                _buildQuickServiceMenu(Icons.emergency_outlined, 'Layanan\nDarurat', true),
                _buildQuickServiceMenu(Icons.science_outlined, 'Hasil Lab', false),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jadwal Mendatang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF04325F))),
                TextButton(onPressed: () {}, child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF04325F)))),
              ],
            ),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(width: 6, color: const Color(0xFFFFC107)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Dr+Budi&background=e0e0e0'),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Dr. Budi Santoso, Sp.PD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF04325F))),
                                        const SizedBox(height: 4),
                                        Text('Spesialis Penyakit Dalam', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF8E1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: const Color(0xFFFFC107)),
                                    ),
                                    child: const Text('Terkonfirmasi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB78500))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(height: 1, color: Color(0xFFEEEEEE)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text('Senin, 24 Okt', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                  const SizedBox(width: 24),
                                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text('10:00 - 11:30', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickServiceMenu(IconData icon, String title, bool isEmergency) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isEmergency ? const Color(0xFFFFEBEE) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, size: 32, color: isEmergency ? const Color(0xFFD32F2F) : const Color(0xFF04325F)),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isEmergency ? const Color(0xFFD32F2F) : const Color(0xFF04325F)),
        ),
      ],
    );
  }
}