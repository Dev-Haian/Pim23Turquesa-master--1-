import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  
  // Função para enviar solicitação de redefinição de senha
  Future<void> _sendPasswordResetEmail() async {
    final String email = _emailController.text;
    const String url = 'http://localhost:3000/user/forgot-password'; // URL da sua API de redefinição de senha

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email de redefinição de senha enviado!')),
        );
        Navigator.pop(context); // Volta para a tela de login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar email de redefinição')),
        );
      }
    } catch (e) {
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
      appBar: AppBar(
        title: Text('Redefinir Senha'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Digite seu email para redefinir a senha:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Campo de e-mail
              Container(
                width: screenWidth * 0.9,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Botão para enviar email de redefinição de senha
              Container(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(155, 141, 222, 213),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02),
                  ),
                  onPressed: _sendPasswordResetEmail, // Função para enviar a solicitação
                  child: Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
