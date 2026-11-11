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
  bool _isLoading = false; // Começa sem o carregamento

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
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: SignUpPage._ifoodRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
        ),

        child: _isLoading
            ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : const Text(
                  'Criar conta',
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

  Future<void> _submit() async {
    // Valida os campos do formulario
    final isValid = _formKey.currentState!.validate();
    if (!isValid)
      return;

    //Confere os termos
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aceite os termos de uso para continuar"))
      );
      return;
    }

    //Se toda a validação passar, startamos o carregamento

    setState(() {
      _isLoading = true;
    });

    //Pede o cadastro a viewmodel e aguarda a resposta
    final error = await _viewModel.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text
    );

    //Para o metodo se a tela for fechada durante a espera
    if (!mounted)
      return;

    //Desliga o carregamento
    setState(() {
      _isLoading = false;
    });

    //Se retornar mensagem de erro, exiba-a e e pare o metodo
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error))
      );
      return;
    }

    //Se der bom: avisa e volta para a tela do perfil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Conta criada! Boas-vindas, ${_nameController.text.trim()}.'))
    );
    Navigator.pop(context);

  }
}

