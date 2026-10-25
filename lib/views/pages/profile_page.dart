import 'package:flutter/material.dart';
import 'package:guia_restaurantes/models/profile_menu_item.dart';
import 'package:guia_restaurantes/views/widgets/profile_menu_tile.dart';
import 'package:guia_restaurantes/views/pages/sign_up_page.dart';
class ProfilePage extends StatelessWidget {

  static const _ifoodRed = Color(0XFFEA1D2C);

  const ProfilePage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  _buildLoginButton(context),
                  const SizedBox(height: 16),
                  _buildMenu(),
                  const SizedBox(height: 24)
                ],
              ),
            )
        )
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Expanded(
            child: Text(
              'Falta pouco para \nmatar a sua fome!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            )
        ),
        Icon(Icons.shopping_bag, size: 90, color: _ifoodRed),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: _ifoodRed,
        side: const BorderSide(color: _ifoodRed),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Entrar ou cadastrar-se',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMenu() {
    return Column(
      children: [
        for (var item in profileMenuMock)
          ProfileMenuTile(item: item),
        const Divider(height: 1),
      ],
    );
  }


}