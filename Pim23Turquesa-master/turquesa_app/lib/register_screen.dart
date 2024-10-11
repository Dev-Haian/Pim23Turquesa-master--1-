import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessário para usar input formatters
import 'package:intl/intl.dart'; // Para formatar a data
import 'dart:convert'; // Para converter dados para JSON
import 'login_screen.dart';
import 'package:http/http.dart' as http; // Para fazer requisições HTTP

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;

  // Controladores para os campos de texto
  final _cpfController = TextEditingController();
  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

  // Limpeza dos controladores ao finalizar a página
  @override
  void dispose() {
    _cpfController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Formatação de data (dd/MM/yyyy)
  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Função para registrar o usuário
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Se o formulário for válido, prosseguir com o registro
      final String name = _nameController.text;
      final String cpf = _cpfController.text;
      final String birthDate = _dateController.text;
      final String phone = _phoneController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      // URL da API de registro
      const String url = 'http://localhost:3000/user/register';

      try {
        // Criação do corpo da requisição
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'name': name,
            'cpf': cpf,
            'birthDate': birthDate,
            'phone': phone,
            'email': email,
            'password': password,
          }),
        );

        // Verificação do sucesso do registro
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuário registrado com sucesso!')),
          );

          // Limpa os campos
          _nameController.clear();
          _cpfController.clear();
          _dateController.clear();
          _phoneController.clear();
          _emailController.clear();
          _passwordController.clear();

          // Navega para a tela de login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao registrar o usuário: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  // Função para verificar se a senha é forte
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha';
    }
    // Verificação de critérios de força da senha
    if (value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }
    if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }
    if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }
    if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
      return 'A senha deve conter pelo menos um número';
    }
    if (!RegExp(r'(?=.*?[#?!@$%^&*-])').hasMatch(value)) {
      return 'A senha deve conter pelo menos um caractere especial';
    }
    return null; // A senha é forte
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registrar:', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'https://turquesaesmalteria.com.br/wp-content/uploads/2020/07/Logo-Turquesa-Horizontal.png',
                height: 120,
              ),
              SizedBox(height: 20),

              // Campo de Nome
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo de CPF
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(14), // CPF formatado: 000.000.000-00
                  _CpfInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 14) {
                    return 'Por favor, insira um CPF válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo de Data de Nascimento
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.teal[700]),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua data de nascimento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo de Telefone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15), // Telefone formatado: (00) 00000-0000
                  _PhoneInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 15) {
                    return 'Por favor, insira um telefone válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo de Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo de Senha
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.teal[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              SizedBox(height: 20),

              // Botão de Registro
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Registrar', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Formata o CPF (apenas números)
class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos
    if (text.length > 11) {
      text = text.substring(0, 11); // Limita a 11 dígitos
    }
    // Formatação do CPF: 000.000.000-00
    String formattedText = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) {
        formattedText += '.';
      } else if (i == 9) {
        formattedText += '-';
      }
      formattedText += text[i];
    }
    return TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: formattedText.length));
  }
}

// Formata o telefone (apenas números)
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos
    if (text.length > 11) {
      text = text.substring(0, 11); // Limita a 11 dígitos
    }
    // Formatação do telefone: (00) 00000-0000
    String formattedText = '';
    if (text.length > 2) {
      formattedText += '(${text.substring(0, 2)}) ';
      if (text.length > 6) {
        formattedText += '${text.substring(2, 7)}-${text.substring(7, 11)}';
      } else if (text.length > 2) {
        formattedText += text.substring(2);
      }
    } else if (text.length > 0) {
      formattedText += '(${text.substring(0, 2)})';
    }
    return TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: formattedText.length));
  }
}
