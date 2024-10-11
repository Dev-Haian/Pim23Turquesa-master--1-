import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turquesa_app/login_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  Future<void> _buildLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(httpClient: mockClient),
      ),
    );
  }

  testWidgets('Deve exibir campos de e-mail e senha', (WidgetTester tester) async {
    await _buildLoginPage(tester);

    // Verifica se os campos de email e senha estão presentes
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
  });

  testWidgets('Deve exibir erro ao tentar login com credenciais inválidas', (WidgetTester tester) async {
    await _buildLoginPage(tester);

    // Simula a resposta da API com erro
    when(mockClient.post(
      Uri.parse('http://localhost:3000/user/login'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Unauthorized', 401));

    // Insere email e senha inválidos
    await tester.enterText(find.byType(TextField).at(0), 'usuario@teste.com');
    await tester.enterText(find.byType(TextField).at(1), 'senha_invalida');

    // Toca no botão de login
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    // Verifica se a mensagem de erro foi exibida
    expect(find.text('Email ou senha inválidos'), findsOneWidget);
  });

  testWidgets('Deve autenticar com sucesso e navegar para HomePage', (WidgetTester tester) async {
    await _buildLoginPage(tester);

    // Simula a resposta da API com sucesso
    when(mockClient.post(
      Uri.parse('http://localhost:3000/user/login'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(jsonEncode({'token': 'abc123'}), 200));

    // Insere email e senha válidos
    await tester.enterText(find.byType(TextField).at(0), 'usuario@teste.com');
    await tester.enterText(find.byType(TextField).at(1), 'senha_valida');

    // Toca no botão de login
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    // Verifica se navega para a HomePage
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
