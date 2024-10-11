import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FuncionariosScreen extends StatefulWidget {
  final String franquiaId;
  final dynamic servico;
  final dynamic franquia;

  FuncionariosScreen({required this.franquiaId, required this.servico, required this.franquia});

  @override
  _FuncionariosScreenState createState() => _FuncionariosScreenState();
}

class _FuncionariosScreenState extends State<FuncionariosScreen> {
  List<Funcionario> funcionarios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFuncionarios();
  }

  Future<void> fetchFuncionarios() async {
    final response = await http.get(Uri.parse('http://localhost:3000/funcionarios/franquia/${widget.franquiaId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        funcionarios = data.map((funcionario) => Funcionario.fromJson(funcionario)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load funcionários');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Funcionários da Franquia'),
        backgroundColor: const Color.fromARGB(255, 125, 177, 171),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: funcionarios.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            funcionarios[index].imagemUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                funcionarios[index].nome,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text(funcionarios[index].cargo),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Funcionario {
  final String nome;
  final String cargo;
  final String imagemUrl;

  Funcionario({
    required this.nome,
    required this.cargo,
    required this.imagemUrl,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      nome: json['nome'],
      cargo: json['cargo'],
      imagemUrl: json['imagemUrl'],
    );
  }
}
