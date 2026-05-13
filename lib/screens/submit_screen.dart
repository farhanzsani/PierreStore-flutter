import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme/sd_theme.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _priceCtrl  = TextEditingController();
  final _descCtrl   = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _api        = ApiService();
  bool _isLoading   = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _githubCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final price = int.tryParse(_priceCtrl.text.trim());
    if (price == null) {
      _snack('Harga harus berupa angka!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final success = await _api.submitTugas(
      _nameCtrl.text.trim(),
      price,
      _descCtrl.text.trim(),
      _githubCtrl.text.trim(),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (success) {
      _snack('"Thank you! I\'ll put it on the shelf right away."');
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.pop(context);
    } else {
      _snack('"Hmm, I can\'t accept this right now." - Pierre', isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: sdBody(size: 17, color: Colors.white)),
      backgroundColor: isError ? kMaroon : kGreenBtn,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGreen,
      appBar: AppBar(
        backgroundColor: kWoodDark,
        foregroundColor: kGold,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Text('◀', style: sdBody(size: 22, color: kGold)),
          ),
        ),
        title: Text("Pierre's General Store",
            style: sdTitle(size: 22, color: kGold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            _DialogueBox(
              speaker: 'Pierre',
              message:
                  '"Hello there! Got something to sell? Tell me about your item."',
            ),
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: sdBox(bg: kMaroon),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌿', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('Add Item to Inventory',
                      style: sdTitle(size: 24, color: Colors.white)),
                  const SizedBox(width: 8),
                  Text('🌿', style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: sdBox(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(icon: '🏷️', text: 'Item Name'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameCtrl,
                      style: sdBody(size: 20),
                      decoration: sdInput(hint: 'e.g. Ancient Sword...'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? '▶ Pierre needs a name!'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    _FieldLabel(icon: '💰', text: 'Selling Price (gold)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      style: sdBody(size: 20),
                      decoration: sdInput(hint: 'e.g. 50000'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return '▶ Set a price!';
                        if (int.tryParse(v.trim()) == null)
                          return '▶ Numbers only!';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _FieldLabel(icon: '📜', text: 'Item Description'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 3,
                      style: sdBody(size: 19),
                      decoration: sdInput(
                          hint: 'Describe what this item does...'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? '▶ Add a description!'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    _FieldLabel(icon: '🔗', text: 'GitHub Repository'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _githubCtrl,
                      keyboardType: TextInputType.url,
                      style: sdBody(size: 18),
                      decoration: sdInput(hint: 'https://github.com/...'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return '▶ Link required!';
                        if (!v.trim().startsWith('http'))
                          return '▶ Invalid URL!';
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                            child: Container(height: 2, color: kWoodMid)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('✦', style: sdBody(size: 22, color: kGold)),
                        ),
                        Expanded(
                            child: Container(height: 2, color: kWoodMid)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SdButton(
                      label: '✦  Sell to Pierre  ✦',
                      onTap: _submit,
                      isLoading: _isLoading,
                      fontSize: 26,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: sdBox(bg: kWoodMid.withOpacity(0.6)),
              child: Text(
                '"Open 9am–5pm. Closed Wednesdays.\nHappy to buy anything!"',
                style: sdBody(size: 16, color: kParchment),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String icon;
  final String text;
  const _FieldLabel({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$icon  ', style: const TextStyle(fontSize: 18)),
        Text('[ $text ]', style: sdBody(size: 20, color: kWoodDark)),
      ],
    );
  }
}

class _DialogueBox extends StatelessWidget {
  final String speaker;
  final String message;
  const _DialogueBox({required this.speaker, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: sdBox(bg: kParchment.withOpacity(0.95)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            color: kWoodDark,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🧑‍🌾', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(speaker,
                    style: GoogleFonts.vt323(
                        fontSize: 20,
                        color: kGold,
                        letterSpacing: 1)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(message,
                style: sdBody(size: 18, color: kWoodDark)),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 8),
              child: Text('▼',
                  style: sdBody(size: 14, color: kWoodMid)),
            ),
          ),
        ],
      ),
    );
  }
}