import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turquesa_app/home_screen.dart';
import 'package:turquesa_app/service_details_page.dart';
import 'package:turquesa_app/services_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ServicesAPI])
void main() {
  testWidgets('HomePage renders correctly and interacts with elements',
      (WidgetTester tester) async {
    // Configura o teste
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
      ),
    );

    // Verifica se a logo é exibida
    expect(find.byType(Image), findsOneWidget);

    // Verifica se os títulos dos serviços são exibidos
    expect(find.text('Serviços:'), findsOneWidget);

    // Verifica se os cards de serviços estão presentes
    expect(find.text('Cabelo'), findsOneWidget);
    expect(find.text('Body Spa'), findsOneWidget);
    expect(find.text('Maquiagem'), findsOneWidget);
    expect(find.text('Estética'), findsOneWidget);
    expect(find.text('Unhas'), findsOneWidget);
    expect(find.text('Cílios'), findsOneWidget);

    // Simula o clique em um card de serviço
    await tester.tap(find.text('Cabelo'));
    await tester.pumpAndSettle(); // Aguarda a navegação

    // Verifica se navega para a página de detalhes do serviço após clicar no card
    expect(find.byType(ServiceDetailsPage), findsOneWidget);
  });

  testWidgets('HomePage bottom navigation works', (WidgetTester tester) async {
    // Configura o teste
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
      ),
    );

    // Verifica se os itens da barra de navegação estão presentes
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // Simula um toque no ícone de "Profile"
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle(); // Aguarda a navegação

    // Verifica se a navegação foi para a tela de perfil
    expect(find.text('Profile'), findsOneWidget); // Supondo que a tela de perfil tenha o texto "Profile"
  });

  testWidgets('HomePage displays beauty tips', (WidgetTester tester) async {
    // Configura o teste
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
      ),
    );

    // Verifica se os títulos de "Dicas de Beleza" são exibidos
    expect(find.text('Dicas de Beleza:'), findsOneWidget);
    expect(find.text('Hidratação é Fundamental'), findsOneWidget);
    expect(find.text('Cuide da Sua Pele'), findsOneWidget);
  });
}
