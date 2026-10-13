import 'package:flutter/material.dart';
import 'order_page.dart'; // ← WAJIB: untuk panggil OrderPage

class MenuDetailPage extends StatefulWidget {
  final String namaMenu;
  final int harga;
  final String deskripsi;
  final String gambarUrl;
  final String kategori;

  const MenuDetailPage({
    super.key,
    required this.namaMenu,
    required this.harga,
    required this.deskripsi,
    required this.gambarUrl,
    required this.kategori,
  });

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int _jumlah = 1;
  String _catatan = 'Normal';
  bool _pedas = false;

  // Widget 1: AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Detail Menu'),
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur share segera hadir')),
            );
          },
        ),
      ],
    );
  }

  // Widget 2: Header gambar + badge kategori
  Widget _buildHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: Image.network(
            widget.gambarUrl,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              height: 240,
              color: Colors.deepOrange.shade100,
              child: const Center(
                child: Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.kategori,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget 3: Kartu info nama + harga + rating
  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.namaMenu,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                const Text(
                  '4.8',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  '(120 ulasan)',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const Spacer(),
                Text(
                  'Rp ${widget.harga}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget 4: Deskripsi
  Widget _buildDeskripsi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.deskripsi,
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }

  // Widget 5: Pengatur jumlah (counter)
  Widget _buildJumlahPengatur() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Jumlah',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              if (_jumlah > 1) setState(() => _jumlah--);
            },
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.deepOrange,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepOrange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$_jumlah',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _jumlah++),
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }

  // Widget 6: Opsi (pedas + catatan)
  Widget _buildOpsi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Tambahkan Pedas'),
            subtitle: const Text('Level pedas maksimal'),
            value: _pedas,
            activeColor: Colors.deepOrange,
            onChanged: (val) => setState(() => _pedas = val),
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Catatan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Normal', 'Tanpa Bawang', 'Extra Saus', 'Dibungkus']
                .map(
                  (label) => ChoiceChip(
                    label: Text(label),
                    selected: _catatan == label,
                    selectedColor: Colors.deepOrange.shade200,
                    onSelected: (_) => setState(() => _catatan = label),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // Widget 7: Bottom bar (total + tombol pesan)
  Widget _buildBottomBar() {
    final total = widget.harga * _jumlah;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total', style: TextStyle(color: Colors.grey)),
                Text(
                  'Rp $total',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderPage(
                        namaMenu: widget.namaMenu,
                        harga: widget.harga,
                        jumlah: _jumlah,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Pesan Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildInfoCard(),
            _buildDeskripsi(),
            const SizedBox(height: 16),
            _buildJumlahPengatur(),
            const Divider(),
            _buildOpsi(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}
