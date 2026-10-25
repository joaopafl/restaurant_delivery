import 'package:flutter/material.dart';
import 'package:guia_restaurantes/viewmodels/sign_up_viewmodel.dart';
import 'package:guia_restaurantes/views/pages/sign_up_page.dart';

class SignUpPage extends StatefulWidget {

  static const _ifoodRed = Color(0xFFEA1D2C);

  //Metodo construtor:
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _viewModel = SignUpViewmodel();

   bool _obscuredPassword = true; // O campo senha começa mas carando a mesma
  bool _acceptedTerms = false;  // O checkkbox do aceite começa desmarcado

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        //Monta o titulo Cria Conta
        title: const Text('Criar conta'),
      ),

      //Monta a Safe Area
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24,),

                  _buildField(label: 'Nome completo', icon: Icons.person_outline, validator: _viewModel.validateName, controller: _nameController),
                  const SizedBox(height: 16,),

                  _buildField(label: 'E-mail', icon: Icons.mail_outline, keyboardType: TextInputType.emailAddress,validator: _viewModel.validateEmail, controller: _emailController),
                  const SizedBox(height: 16,),

                  _buildField(label: 'Celular', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: _viewModel.validatePhone, controller: _phoneController),
                  const SizedBox(height: 16,),

                  _buildField(
                      label: 'Senha',
                      icon: Icons.lock_outline,
                      obscureText: _obscuredPassword,
                      validator: _viewModel.validatePassword,
                      controller: _passwordController,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscuredPassword = !_obscuredPassword;
                            });
                          },
                          icon: Icon(
                            _obscuredPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined
                          )
                      )
                  ),
                  const SizedBox(height: 16,),

                  _buildField(label: 'Confirmar senha', icon: Icons.lock_outline, obscureText: _obscuredPassword,
                                      controller: _confirmPasswordController, validator: (value) => _viewModel.validatePasswordConfirmation(value, _passwordController.text)),

                  const SizedBox(height: 24,),
                  _buildSubmitButton(),

                  const SizedBox(height: 16,),
                  _buildTermsCheckbox(),

                  const SizedBox(height: 8,),
                  _buildLoginLink(context),
                ],
              ),
            ),
            ),
          )
      );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Falta pouco para\nmatar a sua fome!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Text(
          'Preencha os seus dados para criar a sua conta.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildField({required String label,
                      required IconData icon,
                      TextInputType keyboardType = TextInputType.text,
                      bool obscureText = false,
                      Widget? suffixIcon,
                      String? Function(String?)? validator,
                      TextEditingController? controller}) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: SignUpPage._ifoodRed, width: 2),
        ),
        floatingLabelStyle: const TextStyle(color: SignUpPage._ifoodRed)
      ),
    );
  }

  //Botão Criar conta
  Widget _buildSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          //Inserir mais tarde a ação do botão
          final formValid = _formKey.currentState!.validate();
          final termsError = _viewModel.validateTerms(_acceptedTerms);

          if (termsError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(termsError)),
            );
          }

          final isValid = formValid && termsError == null;
          print('Formulário válido? $isValid');
        },
    style: ElevatedButton.styleFrom(
      backgroundColor: SignUpPage._ifoodRed,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
      child: const Text(
        'Criar Conta',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Check Box de aceite dos termos
  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
        value: _acceptedTerms,
        onChanged: (value) {
          //Marcar e desmarcar o checkbox
          setState(() {
            _acceptedTerms = value ?? false;
          });

        },
        activeColor: SignUpPage._ifoodRed,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('Li e aceito os termos de uso e a politica de privacidade'),
        );
  }

  //Link ja tenho conta
  Widget _buildLoginLink(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(foregroundColor: SignUpPage._ifoodRed),
        child: const Text('Já tenho uma contra'),
    );


  }
}