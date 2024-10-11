import 'package:flutter/material.dart';
import 'service_details_page.dart';
import 'package:turquesa_app/services_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false; // Para verificar se a animação está em execução

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Iniciar a animação ao carregar a tela
    _animateNotificationIcon();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateNotificationIcon() {
    if (!_isAnimating) {
      _isAnimating = true; // Impede que a animação seja acionada novamente
      _controller.forward().then((_) {
        _controller.reverse();
        _isAnimating = false; // Permite que a animação possa ser acionada novamente
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 125, 177, 171),
        elevation: 0,
        title: Text(
          "Hello, Usuário.",
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
        ),
        actions: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    // Chama a animação quando o ícone é pressionado
                    _animateNotificationIcon();
                    
                    // Navegar para a tela de notificações
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Espaço para logo
            SizedBox(height: 20),
            Center(
              child: Image.network(
                "https://turquesaesmalteria.com.br/wp-content/uploads/2020/07/Logo-Turquesa-Horizontal.png", // Substitua pela URL da logo
                height: 100,
              ),
            ),
            SizedBox(height: 16), // Espaçamento após a logo

            // Cards de serviços (grid)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho da seção
                  Text(
                    'Serviços:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0), // Espaçamento entre o título e os cards

                  // Grid de cards de serviços
                  GridView.count(
                    crossAxisCount: 3, // 3 cards por linha
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Impede rolagem
                    childAspectRatio: 0.85, // Proporção da altura para a largura
                    children: [
                      _buildCategoryCard(
                        "https://kproserragaucha.com.br/wp-content/uploads/2022/10/Untitled-1-1.jpg",
                        "Cabelo",
                        context,
                      ),
                      _buildCategoryCard(
                        "https://img.freepik.com/free-photo/beauty-spa_144627-46202.jpg",
                        "Body Spa",
                        context,
                      ),
                      _buildCategoryCard(
                        "https://i0.wp.com/priflor.com/wp-content/uploads/2023/12/maquiagem_pele_negra_02.webp?fit=828%2C828&ssl=1",
                        "Maquiagem",
                        context,
                      ),
                      _buildCategoryCard(
                        "https://media.istockphoto.com/id/1389918141/photo/studio-shot-of-an-attractive-young-woman-applying-makeup-against-a-brown-background.jpg?s=612x612&w=0&k=20&c=Y9G_TTMSfXbJMGYNDd0dycryGWVUXlWDe4LHO_9w85I=",
                        "Estética",
                        context,
                      ),
                      _buildCategoryCard(
                        "https://boaforma.abril.com.br/wp-content/uploads/sites/2/2023/12/cuidados-na-hora-de-fazer-as-unhas.jpg?crop=1&resize=1212,909",
                        "Unhas",
                        context,
                      ),
                      _buildCategoryCard(
                        "https://media.istockphoto.com/id/845708412/pt/foto/eyelash-extension-procedure-woman-eye-with-long-eyelashes-lashes-close-up-macro-selective-focus.jpg?s=612x612&w=0&k=20&c=AtbS1bVvcfgKooF-Dd0wkDSpAc5zPzvgiHUHc94gwWU=",
                        "Cílios",
                        context,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Dicas de Beleza
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Aumentar espaço acima
              child: Text(
                "Dicas de Beleza:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                _buildTipCard(Icons.local_drink, "Hidratação é Fundamental", "Beba bastante água todos os dias."),
                _buildTipCard(Icons.wb_sunny, "Cuide da Sua Pele", "Use protetor solar diariamente."),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          // Verifica qual item foi clicado e navega para a respectiva tela
          switch (index) {
            case 0:
              // Navegar para a tela Home
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              // Navegar para a tela Profile
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Método para construir o card de categoria
  Widget _buildCategoryCard(String imageUrl, String categoryName, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          // Chama a função de requisição para buscar subcategorias da categoria selecionada
          var subcategories = await ServicesAPI.getSubcategories(categoryName);

          // Navega para a tela de detalhes com as subcategorias recebidas
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailsPage(
                categoryName: categoryName,
                subcategories: subcategories,
              ),
            ),
          );
        } catch (e) {
          // Se ocorrer algum erro, mostra uma mensagem no console
          print('Erro ao carregar subcategorias: $e');
        }
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                categoryName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir o card de dica
  Widget _buildTipCard(IconData icon, String title, String description) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Color.fromARGB(255, 125, 177, 171)), // Aqui você coloca o ícone
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(description),
      ),
    );
  }
}