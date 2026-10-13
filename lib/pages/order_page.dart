import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final String? namaMenu;
  final int? harga;
  final int? jumlah;

  const OrderPage({super.key, this.namaMenu, this.harga, this.jumlah});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _mejaController = TextEditingController();
  final _catatanController = TextEditingController();

  String _metodePembayaran = 'Tunai';
  bool _dibungkus = false;
  bool _sudahPesan = false;

  int get _jumlah => widget.jumlah ?? 1;
  int get _harga => widget.harga ?? 0;
  int get _subtotal => _harga * _jumlah;
  int get _pajak => (_subtotal * 0.1).round();
  int get _total => _subtotal + _pajak;

  @override
  void dispose() {
    _namaController.dispose();
    _mejaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _konfirmasiPesanan() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Pesanan'),
        content: Text(
          'Apakah kamu yakin ingin memesan ${widget.namaMenu ?? "pesanan"} '
          'sebanyak $_jumlah porsi?\n\nTotal: Rp $_total',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _sudahPesan = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pesanan berhasil dikirim ke dapur! 🍳'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Ya, Pesan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sudahPesan) return _buildStrukSukses();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Kartu ringkasan pesanan
              _buildRingkasan(),
              const SizedBox(height: 16),

              // 2. Form data pemesan
              _buildFormData(),
              const SizedBox(height: 16),

              // 3. Pilihan pembayaran
              _buildMetodePembayaran(),
              const SizedBox(height: 16),

              // 4. Opsi tambahan
              _buildOpsiTambahan(),
              const SizedBox(height: 16),

              // 5. Rincian harga
              _buildRincianHarga(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ============ WIDGET 1: Ringkasan Pesanan ============
  Widget _buildRingkasan() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: Colors.deepOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ringkasan Pesanan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 24),
            _barisInfo('Menu', widget.namaMenu ?? 'Belum dipilih'),
            _barisInfo('Harga Satuan', 'Rp $_harga'),
            _barisInfo('Jumlah', '$_jumlah porsi'),
          ],
        ),
      ),
    );
  }

  Widget _barisInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ============ WIDGET 2: Form Data Pemesan ============
  Widget _buildFormData() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.person, color: Colors.deepOrange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Data Pemesan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 24),
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Pemesan',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _mejaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nomor Meja',
                prefixIcon: const Icon(Icons.table_restaurant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Nomor meja tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _catatanController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Catatan (opsional)',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ WIDGET 3: Metode Pembayaran ============
  Widget _buildMetodePembayaran() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.payment, color: Colors.deepOrange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 24),
            Column(
              children: [
                _opsiPembayaran('Tunai', Icons.money),
                _opsiPembayaran('QRIS', Icons.qr_code),
                _opsiPembayaran('Transfer Bank', Icons.account_balance),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _opsiPembayaran(String label, IconData icon) {
    final selected = _metodePembayaran == label;
    return RadioListTile<String>(
      value: label,
      groupValue: _metodePembayaran,
      onChanged: (val) => setState(() => _metodePembayaran = val!),
      activeColor: Colors.deepOrange,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: selected ? Colors.deepOrange : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  // ============ WIDGET 4: Opsi Tambahan ============
  Widget _buildOpsiTambahan() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        value: _dibungkus,
        activeColor: Colors.deepOrange,
        onChanged: (val) => setState(() => _dibungkus = val),
        title: const Text('Dibungkus'),
        subtitle: const Text('Pesanan akan dibungkus untuk dibawa pulang'),
        secondary: const Icon(Icons.takeout_dining, color: Colors.deepOrange),
      ),
    );
  }

  // ============ WIDGET 5: Rincian Harga ============
  Widget _buildRincianHarga() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.calculate, color: Colors.deepOrange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Rincian Harga',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 24),
            _barisInfo('Subtotal ($_jumlah x Rp $_harga)', 'Rp $_subtotal'),
            _barisInfo('Pajak (10%)', 'Rp $_pajak'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Rp $_total',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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

  // ============ WIDGET 6: Bottom Bar Konfirmasi ============
  Widget _buildBottomBar() {
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _konfirmasiPesanan,
            icon: const Icon(Icons.check_circle),
            label: const Text('Konfirmasi Pesanan'),
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
      ),
    );
  }

  // ============ WIDGET 7: Struk Sukses ============
  Widget _buildStrukSukses() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pesanan Berhasil!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tunjukkan struk ini ke kasir Bu Sari.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Divider(height: 32),
                    _barisInfo('Menu', widget.namaMenu ?? '-'),
                    _barisInfo('Nama Pemesan', _namaController.text),
                    _barisInfo('Nomor Meja', _mejaController.text),
                    _barisInfo('Jumlah', '$_jumlah porsi'),
                    _barisInfo('Metode Bayar', _metodePembayaran),
                    _barisInfo('Dibungkus', _dibungkus ? 'Ya' : 'Tidak'),
                    if (_catatanController.text.isNotEmpty)
                      _barisInfo('Catatan', _catatanController.text),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Rp $_total',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                        icon: const Icon(Icons.home),
                        label: const Text('Kembali ke Menu'),
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
            ),
          ),
        ),
      ),
    );
  }
}
