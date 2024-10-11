import 'package:flutter/material.dart';
import 'package:turquesa_app/ForgotPasswordPage.dart';
import 'package:turquesa_app/home_screen.dart'; // Importe sua Home Page antiga
import 'register_screen.dart'; // Importa a tela de Registro
import 'dart:convert'; // Para converter dados para JSON
import 'package:http/http.dart' as http; // Para fazer requisições HTTP

class LoginPage extends StatefulWidget {
  final String? franquiaId; // Parâmetro opcional
  final http.Client? httpClient;

  LoginPage({this.franquiaId, this.httpClient}); // Construtor atualizado

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  // Controladores para os campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Função para autenticar o usuário
  Future<void> _authenticateUser() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    const String url = 'http://localhost:3000/user/login'; // URL da sua API de login

    if (!mounted) return;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Se a autenticação for bem-sucedida
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso!')),
        );

        // Redireciona para a Home Page antiga após o login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Se as credenciais estiverem erradas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou senha inválidos')),
        );
      }
    } catch (e) {
      // Tratamento de erros
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05), // Ajuste de padding responsivo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo acima do nome do salão
              Image.network(
                'https://turquesaesmalteria.com.br/wp-content/uploads/2020/07/Logo-Turquesa-Horizontal.png',
                height: screenHeight * 0.15, // Altura da logo responsiva
              ),
              SizedBox(height: screenHeight * 0.03), // Espaçamento responsivo

              // Campo de e-mail
              Container(
                width: screenWidth * 0.9, // Largura responsiva
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 1)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // Espaçamento responsivo

              // Campo de senha com ícone de "olhinho"
              Container(
                width: screenWidth * 0.9, // Largura responsiva
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
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
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // Espaçamento responsivo

              // Botão de Entrar
              Container(
                width: screenWidth * 0.5, // Largura responsiva
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(155, 141, 222, 213),
                    foregroundColor: const Color.fromARGB(169, 0, 0, 0), // Cor do texto do botão
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), // Padding responsivo
                  ),
                  onPressed: () {
                    _authenticateUser(); // Chama a função de autenticação
                  },
                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Espaçamento responsivo

              // Botão de Registrar-se
              Container(
                width: screenWidth * 0.5, // Largura responsiva
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(155, 141, 222, 213),
                    foregroundColor: const Color.fromARGB(169, 0, 0, 0), // Cor do texto do botão
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), // Padding responsivo
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    'Registrar-se',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Espaçamento responsivo

              // Botão "Esqueci minha senha"
              TextButton(
                onPressed: () {
                  // Navega para a tela de Redefinir Senha
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    color: Colors.teal[700], // Cor do botão
                    fontSize: 14,
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
