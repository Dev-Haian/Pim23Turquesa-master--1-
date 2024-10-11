import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Importando a biblioteca de indicadores
import 'login_screen.dart'; // Importando a tela de login

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final PageController _pageController = PageController(); // Controlador para o PageView

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Image.network(
                "https://turquesaesmalteria.com.br/wp-content/uploads/2020/07/Logo-Turquesa-Horizontal.png", // Substitua pela URL da logo
                height: 100,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: screenHeight * 0.4, // Defina a altura do card
              child: PageView(
                controller: _pageController, // Definindo o controlador
                children: [
                  _buildCard(
                    'A Turquesa Esmalteria e Beleza é uma rede de franquias dedicada a oferecer excelência em cuidados de beleza. Fundada com a missão de proporcionar uma experiência única e personalizada a cada cliente. Nossa marca é sinônimo de inovação, qualidade e bem-estar, sempre buscando a satisfação dos clientes.',
                  ),
                  _buildCard(
                    'Nossos serviços variam desde tratamentos de unhas, cabelo, maquiagem e estética, todos realizados por especialistas altamente qualificados e comprometidos com o melhor atendimento.',
                  ),
                  _buildCard(
                    'Com diversas unidades espalhadas pelo país, estamos sempre prontos para atender com excelência e dedicação. Na Turquesa Esmalteria e Beleza, sua beleza é o nosso compromisso!',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Indicador de página
            SmoothPageIndicator(
              controller: _pageController,  // Conectado ao PageController
              count: 3,  // Quantidade de cards
              effect: WormEffect(  // Efeito de transição do indicador
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.blue, // Cor do ponto ativo
                dotColor: Colors.grey, // Cor dos pontos inativos
              ),
            ),
            
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Ir para Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
