//franquias_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agendamento_final_screen.dart';

class Franquia {
  final String nome;
  final String imageUrl;
  final String address;
  final String hours;

  Franquia({
    required this.nome,
    required this.imageUrl,
    required this.address,
    required this.hours,
  });
}

class FranquiaCard extends StatelessWidget {
  final Franquia franquia;

  FranquiaCard({required this.franquia});

  @override
  Widget build(BuildContext context) {
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
                franquia.imageUrl,
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
                    franquia.nome,  // Exibe o nome da franquia
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    franquia.address,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    franquia.hours,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 57, 56, 56),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FranquiasScreen extends StatefulWidget {
  final dynamic selectedService;

  FranquiasScreen({Key? key, required this.selectedService}) : super(key: key);

  @override
  _FranquiasScreenState createState() => _FranquiasScreenState();
}

class _FranquiasScreenState extends State<FranquiasScreen> {
  List<Franquia> franquias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFranquias();
  }

  Future<void> fetchFranquias() async {
    final response = await http.get(Uri.parse('http://localhost:3000/franquias'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        franquias = data.map((franquia) => Franquia(
          nome: franquia['nome'],
          imageUrl: franquia['imagemUrl'],  
          address: franquia['endereco'],      
          hours: franquia['horario'],         
        )).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load franquias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione a Unidade:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 125, 177, 171),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
               Container(
                  padding: EdgeInsets.all(16.0),
                  child: Image.network(
                    'https://turquesaesmalteria.com.br/wp-content/uploads/2020/07/Logo-Turquesa-Horizontal.png',
                    height: 100,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: franquias.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Adicione a navegação para a tela de agendamento
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AgendamentoFinalScreen(
                                  franquia: franquias[index],
                                  servico: widget.selectedService,
                                       // builder: (context) => FuncionariosScreen(franquiaId: franquias[index].id), // Passe o ID da franquia

                                ),
                              ),
                            );
                          },
                          child: FranquiaCard(franquia: franquias[index]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// Defina a classe AgendamentoScreen aqui ou importe-a se estiver em um arquivo separado.
class AgendamentoScreen extends StatelessWidget {
  final Franquia franquia;
  final dynamic servico;

  AgendamentoScreen({required this.franquia, required this.servico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Serviço'),
      ),
      body: Center(
        child: Text('Agendando ${servico} para ${franquia.nome}'),
      ),
    );
  }
}
