import 'package:flutter/material.dart';
import '../data/dummy_menu.dart';
import '../models/menu.dart';
import 'menu_detail_page.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  String _kategoriAktif = 'Semua';
  String _keyword = '';
  final TextEditingController _searchController = TextEditingController();

  List<Menu> get _menuTampil {
    return daftarMenu.where((menu) {
      final cocokKategori =
          _kategoriAktif == 'Semua' || menu.kategori == _kategoriAktif;
      final cocokKeyword = menu.nama.toLowerCase().contains(
        _keyword.toLowerCase(),
      );
      return cocokKategori && cocokKeyword;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Kantin Bu Sari'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/pesan'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Header sambutan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.deepOrange.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Halo, Selamat Datang AbangQu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 4),
                Text('Mau makan apa hari ini?'),
              ],
            ),
          ),

          // 2. Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _keyword = val),
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 3. Chip kategori
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Semua', 'Makanan', 'Minuman', 'Snack']
                  .map(
                    (kategori) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(kategori),
                        selected: _kategoriAktif == kategori,
                        selectedColor: Colors.deepOrange.shade200,
                        onSelected: (_) =>
                            setState(() => _kategoriAktif = kategori),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),

          // 4. List menu
          Expanded(
            child: _menuTampil.isEmpty
                ? const Center(child: Text('Menu tidak ditemukan 😔'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _menuTampil.length,
                    itemBuilder: (context, index) {
                      final menu = _menuTampil[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MenuDetailPage(
                                  namaMenu: menu.nama,
                                  harga: menu.harga,
                                  deskripsi: menu.deskripsi,
                                  gambarUrl: menu.gambarUrl,
                                  kategori: menu.kategori,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    menu.gambarUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 90,
                                      height: 90,
                                      color: Colors.deepOrange.shade100,
                                      child: const Icon(
                                        Icons.restaurant,
                                        color: Colors.deepOrange,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        menu.nama,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${menu.rating}'),
                                          const SizedBox(width: 8),
                                          Text(
                                            menu.kategori,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Rp ${menu.harga}',
                                        style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
