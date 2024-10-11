import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Dados Pessoais
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Usuário",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "usuario@exemplo.com",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para editar perfil
                    },
                    child: Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Histórico de Serviços
            Text(
              "Service History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildServiceHistoryItem("Haircut", "Completed", "25 Sep 2023"),
            _buildServiceHistoryItem("Spa", "Upcoming", "30 Sep 2023"),
            _buildServiceHistoryItem("Make Up", "Completed", "10 Sep 2023"),
            SizedBox(height: 20),

            // Botão de Logout
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para logout
                },
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir os itens do histórico de serviços
  Widget _buildServiceHistoryItem(String service, String status, String date) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      leading: Icon(Icons.check_circle, color: status == "Completed" ? Colors.green : Colors.orange),
      title: Text(service),
      subtitle: Text("Status: $status"),
      trailing: Text(date),
    );
  }
}
