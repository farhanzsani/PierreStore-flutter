import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../theme/sd_theme.dart';
import 'submit_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _api = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _api.getProduct();
    if (!mounted) return;
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void _showAddDialog() {
    final nameCtrl  = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl  = TextEditingController();
    final formKey   = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: sdBox(),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('✦ Add New Item ✦',
                      style: sdTitle(size: 24, color: kWoodDark)),
                ),
                const SizedBox(height: 16),

                Text('🏷️  Item Name', style: sdBody()),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nameCtrl,
                  style: sdBody(size: 18),
                  decoration: sdInput(hint: 'Product name...'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name required!' : null,
                ),
                const SizedBox(height: 12),

                Text('💰  Price (gold)', style: sdBody()),
                const SizedBox(height: 6),
                TextFormField(
                  controller: priceCtrl,
                  style: sdBody(size: 18),
                  keyboardType: TextInputType.number,
                  decoration: sdInput(hint: 'e.g. 5000'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Price required!';
                    if (int.tryParse(v.trim()) == null) return 'Numbers only!';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                Text('📜  Description', style: sdBody()),
                const SizedBox(height: 6),
                TextFormField(
                  controller: descCtrl,
                  style: sdBody(size: 18),
                  maxLines: 2,
                  decoration: sdInput(hint: 'Describe the item...'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description required!' : null,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: sdBox(bg: kStoneGray),
                          alignment: Alignment.center,
                          child: Text('Cancel', style: sdBody(size: 20, color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (!formKey.currentState!.validate()) return;
                          final ok = await _api.createProduct(
                            nameCtrl.text.trim(),
                            int.parse(priceCtrl.text.trim()),
                            descCtrl.text.trim(),
                          );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          if (ok) _loadProducts();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              ok ? 'Item added to stock!' : 'Pierre refused...',
                              style: sdBody(size: 18, color: Colors.white),
                            ),
                            backgroundColor: ok ? kGreenBtn : kMaroon,
                            behavior: SnackBarBehavior.floating,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: sdBox(bg: kGreenBtn),
                          alignment: Alignment.center,
                          child: Text('Sell ✦', style: sdBody(size: 20, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatGold(double price) {
    final n = price.toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '$n g';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGreen,
      appBar: AppBar(
        backgroundColor: kWoodDark,
        foregroundColor: kGold,
        elevation: 0,
        title: Text("Pierre's General Store",
            style: sdTitle(size: 22, color: kGold)),
        actions: [
          IconButton(
            icon: const Text('📬', style: TextStyle(fontSize: 20)),
            tooltip: 'Submit Tugas',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubmitScreen()),
            ),
          ),
          IconButton(
            icon: const Text('🔄', style: TextStyle(fontSize: 20)),
            tooltip: 'Refresh',
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: kGold),
                  const SizedBox(height: 12),
                  Text('Pierre is checking inventory...',
                      style: sdBody(size: 18, color: kGold)),
                ],
              ),
            )
          : _products.isEmpty
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: sdBox(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🪴', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('"The shelves are bare today..."',
                            style: sdBody(size: 20, color: kWoodMid),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _showAddDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            decoration: sdBox(bg: kGreenBtn),
                            child: Text('✦ Stock an Item',
                                style: sdBody(size: 20, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadProducts,
                  color: kGold,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: sdBox(bg: kMaroon),
                        child: Row(
                          children: [
                            Text('🛒', style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text("Today's Stock  (${_products.length} items)",
                                style: sdBody(size: 18, color: kGold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._products.map((p) => _ProductCard(
                            product: p,
                            formatGold: _formatGold,
                          )),
                    ],
                  ),
                ),
      floatingActionButton: GestureDetector(
        onTap: _showAddDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: sdBox(bg: kGreenBtn),
          child: Text('✦  Stock Item', style: sdBody(size: 20, color: Colors.white)),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final String Function(double) formatGold;

  const _ProductCard({required this.product, required this.formatGold});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: sdBox(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kWoodMid,
              border: Border.all(color: kWoodDark, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              product.name.isNotEmpty ? product.name[0].toUpperCase() : '?',
              style: GoogleFonts.vt323(
                  fontSize: 28, color: kParchment, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: sdBody(size: 20),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                if (product.description.isNotEmpty)
                  Text(product.description,
                      style: sdBody(size: 16, color: kWoodMid),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kGold,
              border: Border.all(color: kWoodDark, width: 2),
            ),
            child: Text(
              '💰 ${formatGold(product.price)}',
              style: sdBody(size: 16, color: kWoodDark),
            ),
          ),
        ],
      ),
    );
  }
}