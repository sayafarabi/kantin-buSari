class Menu {
  final String id;
  final String nama;
  final int harga;
  final String deskripsi;
  final String gambarUrl;
  final String kategori;
  final double rating;

  const Menu({
    required this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambarUrl,
    required this.kategori,
    this.rating = 4.5,
  });
}
