import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turquesa_app/franquias_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'dart:convert';
import 'franquias_screen_test.mocks.dart';

// Gerar mocks para as dependências de HTTP.
@GenerateMocks([http.Client])
void main() {
  group('FranquiasScreen Widget Tests', () {
    testWidgets('Displays loading spinner while fetching data', (WidgetTester tester) async {
      // Mock da resposta HTTP.
      final client = MockClient();
      when(client.get(Uri.parse('http://localhost:3000/franquias')))
          .thenAnswer((_) async => http.Response('[]', 200));

      // Renderiza a FranquiasScreen
      await tester.pumpWidget(
        MaterialApp(
          home: FranquiasScreen(selectedService: 'Manicure'),
        ),
      );

      // Verifica se o indicador de carregamento é exibido.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays Franquia cards after data is fetched', (WidgetTester tester) async {
      // Mock da resposta HTTP.
      final client = MockClient();
      final fakeFranquias = jsonEncode([
        {
          'nome': 'Unidade Central',
          'imagemUrl': 'https://example.com/image1.jpg',
          'endereco': 'Rua Central, 123',
          'horario': '08:00 - 18:00',
        },
        {
          'nome': 'Unidade Sul',
          'imagemUrl': 'https://example.com/image2.jpg',
          'endereco': 'Avenida Sul, 456',
          'horario': '09:00 - 19:00',
        },
      ]);

      when(client.get(Uri.parse('http://localhost:3000/franquias')))
          .thenAnswer((_) async => http.Response(fakeFranquias, 200));

      // Renderiza a FranquiasScreen com dados mockados
      await tester.pumpWidget(
        MaterialApp(
          home: FranquiasScreen(selectedService: 'Manicure'),
        ),
      );

      // Espera o carregamento dos dados
      await tester.pumpAndSettle();

      // Verifica se os cards de franquia estão sendo exibidos corretamente.
      expect(find.text('Unidade Central'), findsOneWidget);
      expect(find.text('Unidade Sul'), findsOneWidget);
    });

    testWidgets('Navigates to AgendamentoFinalScreen on card tap', (WidgetTester tester) async {
      // Mock da resposta HTTP.
      final client = MockClient();
      final fakeFranquias = jsonEncode([
        {
          'nome': 'Unidade Central',
          'imagemUrl': 'https://example.com/image1.jpg',
          'endereco': 'Rua Central, 123',
          'horario': '08:00 - 18:00',
        },
      ]);

      when(client.get(Uri.parse('http://localhost:3000/franquias')))
          .thenAnswer((_) async => http.Response(fakeFranquias, 200));

      // Renderiza a FranquiasScreen
      await tester.pumpWidget(
        MaterialApp(
          home: FranquiasScreen(selectedService: 'Manicure'),
        ),
      );

      // Espera o carregamento dos dados
      await tester.pumpAndSettle();

      // Simula o toque no card da franquia
      await tester.tap(find.text('Unidade Central'));
      await tester.pumpAndSettle();

      // Verifica se foi navegado para a tela de agendamento (AgendamentoFinalScreen)
      expect(find.text('Agendando Manicure para Unidade Central'), findsOneWidget);
    });
  });
}
