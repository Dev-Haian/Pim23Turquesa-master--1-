import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Lista para armazenar as avaliações
  List<Map<String, dynamic>> evaluations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Notificações"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationCard(
              "Promoção", "5% de desconto após a avaliação!", Icons.local_offer),
          const SizedBox(height: 16.0), // Espaço antes da seção de avaliação
          _buildEvaluationSection(context), // Adiciona a seção de avaliação
          const SizedBox(height: 16.0), // Espaço antes dos agendamentos
          _buildAgendamentosCard(context), // Adiciona o card de agendamentos
        ],
      ),
    );
  }

  Widget _buildNotificationCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 40),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        // Removendo o ícone de seta
        trailing: null,
        onTap: null, // Remove a funcionalidade de navegação
      ),
    );
  }

  Widget _buildEvaluationSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avalie sua experiência:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildRatingRow('Franquia', 'franquia'),
            _buildRatingRow('Profissional', 'profissional'),
            _buildRatingRow('Serviço', 'serviço'),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Cor do botão
              ),
              onPressed: () {
                // Adicione a lógica para enviar a avaliação
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Avaliação enviada com sucesso!')),
                );

                // Salvar avaliação (exemplo simples)
                setState(() {
                  evaluations.add({
                    'franquia': 0, // A avaliação deve ser coletada
                    'profissional': 0, // A avaliação deve ser coletada
                    'serviço': 0, // A avaliação deve ser coletada
                  });
                });
              },
              child: const Text('Enviar Avaliação'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, String key) {
    int rating = 0; // Inicializando a avaliação
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(Icons.star, color: rating > index ? Colors.teal : Colors.grey),
              onPressed: () {
                // Adiciona a lógica para registrar a avaliação
                setState(() {
                  rating = index + 1; // Atualiza a avaliação
                  // Atualiza a avaliação na lista
                  evaluations[evaluations.length - 1][key] = rating;
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAgendamentosCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: const Text(
          "Meus Agendamentos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text("Veja seus agendamentos"),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          // Navega para a tela de agendamentos
          Navigator.pushNamed(context, '/agendamento_final_screen');
        },
      ),
    );
  }
}
