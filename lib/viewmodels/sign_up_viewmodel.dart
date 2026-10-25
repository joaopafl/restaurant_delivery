class SignUpViewmodel {
  //Recebe o texto do campo e devolve uma mensagem de erro, ou null se estiver valido
  String? validateName(String? value) {
    //Remove os espaços do inicio e do fim, mas se for nulo usa uma string vazia
    final name = value?.trim() ?? '';

    //Se estiver vazio, pede o nome
    if (name.isEmpty) return 'Inofrme o seu nome, por favor';

    // Se tiver menos de três letras
    if (name.length < 3) return 'O nome deve conter minimamente três letras';

    // Se passar nas duas regras acima, o nome é valido
    return null;
  }

  // E-mail: Obrigatorio no formato nome@dominio
  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return "Informe o seu e-mail";
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(email)) return 'E-mail Invalido';
    return null;
  }

  // Celular: Obrigatorio com ddd e 9 digitos - 11 no total
  String? validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Informe o numero do celular';
    if (digits.length != 11) return 'Informe o DDD e os nove digitos do celular';
    return null;
  }

  // Senha: obrigatória, com pelo menos 6 caracteres
  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Crie uma senha';
    if (password.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }

  // Confirmação: obrigatória e igual à senha
  String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirme a sua senha';
    if (value != password) return 'As senhas não conferem';
    return null;
  }

  // Termos: precisam estar aceitos
  String? validateTerms(bool accepted) {
    if (!accepted) return 'Aceite os termos de uso para continuar';
    return null;
  }
}