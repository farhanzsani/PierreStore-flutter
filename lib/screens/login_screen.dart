import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbm_tugas_praktikum/services/api_service.dart';
import 'package:pbm_tugas_praktikum/theme/sd_theme.dart';
import 'product_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nimCtrl  = TextEditingController();
  final _passCtrl = TextEditingController();
  final _api      = ApiService();
  bool _isLoading  = false;
  bool _obscure    = true;

  @override
  void dispose() {
    _nimCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    final nim = _nimCtrl.text.trim();
    if (nim.isEmpty) {
      _snack('Farmer ID tidak boleh kosong!', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final result = await _api.login(nim);
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductScreen()),
      );
    } else {
      _snack('Pierre tidak mengenali kamu. Cek Farmer ID-mu!', isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: sdBody(size: 18, color: Colors.white)),
      backgroundColor: isError ? kMaroon : kGreenBtn,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGreen,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: sdBox(bg: kMaroon),
                  child: Column(
                    children: [
                      Text('🌿 Pierre\'s', style: sdTitle(size: 22, color: kGold)),
                      Text('General Store', style: sdTitle(size: 32, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('- Pelican Town -',
                          style: sdBody(size: 18, color: kGold)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: sdBox(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '"Who goes there?"',
                          style: sdBody(size: 20, color: kWoodMid),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text('🪪  [ Farmer ID ]', style: sdBody(size: 20)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nimCtrl,
                        keyboardType: TextInputType.number,
                        style: sdBody(size: 20),
                        decoration: sdInput(hint: 'Enter your NIM...'),
                      ),

                      const SizedBox(height: 16),

                      Text('🔑  [ Password ]', style: sdBody(size: 20)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        style: sdBody(size: 20),
                        decoration: sdInput(hint: '••••••••').copyWith(
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                _obscure ? '👁️' : '🙈',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      SdButton(
                        label: '✦  Enter the Shop  ✦',
                        onTap: _login,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Open 9am - 5pm • Closed Wednesdays',
                  style: sdBody(size: 16, color: kGold.withOpacity(0.8)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
