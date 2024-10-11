import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Biblioteca para formatação de datas

class AgendamentoFinalScreen extends StatelessWidget {
  final dynamic servico;
  final dynamic franquia;

  AgendamentoFinalScreen({required this.servico, required this.franquia});


  @override
  Widget build(BuildContext context) {
    // Exemplo de datas e horários disponíveis
    List<DateTime> diasDisponiveis = [
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 2)),
      DateTime.now().add(Duration(days: 3)),
    ];

    List<String> horariosDisponiveis = ["09:00", "11:00", "14:00", "16:00"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar ${servico['name']}:',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 125, 177, 171),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card com informações do serviço e da franquia selecionados
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagem do serviço se houver
                    if (servico['image'] != null && servico['image'].isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          servico['image'],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            servico['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            franquia.nome,  // Nome da franquia
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 80, 79, 79),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Preço: \$${servico['price']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 69, 65, 65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Seção de seleção de datas
            Text(
              'Selecione o dia:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diasDisponiveis.length,
                itemBuilder: (context, index) {
                  final dia = diasDisponiveis[index];
                  return GestureDetector(
                    onTap: () {
                      // Navegar para a seleção de horário
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _buildHorarioSheet(context, dia, horariosDisponiveis, servico, franquia),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd/MM').format(dia),
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              DateFormat('EEEE').format(dia),
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modal para escolher o horário disponível
  Widget _buildHorarioSheet(BuildContext context, DateTime dia, List<String> horarios, dynamic servico, dynamic franquia) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Horários disponíveis para ${DateFormat('dd/MM/yyyy').format(dia)}:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: horarios.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(horarios[index]),
                onTap: () {
                  // Confirmar agendamento
                  Navigator.pop(context); // Fechar o modal
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirmar Agendamento'),
                      content: Text(
                        'Você está agendando o serviço ${servico['name']} na franquia ${franquia.nome} para o dia ${DateFormat('dd/MM/yyyy').format(dia)} às ${horarios[index]}.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Ação para concluir o agendamento
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Agendamento realizado com sucesso!')),
                            );
                          },
                          child: Text('Confirmar'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
