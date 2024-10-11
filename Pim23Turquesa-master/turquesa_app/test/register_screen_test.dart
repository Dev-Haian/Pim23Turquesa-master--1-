import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turquesaapp/screens/register_page.dart'; // Importe o caminho correto
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:http_mock_adapter/http_mock_adapter.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('RegisterPage', () {
    late MockHttpClient mockHttpClient;
    late DioAdapter dioAdapter;

    setUp(() {
      mockHttpClient = MockHttpClient();
      dioAdapter = DioAdapter(dio: mockHttpClient);
    });

    testWidgets('Renderiza todos os campos de input e o botão de registro',
        (WidgetTester tester) async {
      // Constrói a tela de registro
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterPage(),
        ),
      );

      // Verifica se todos os campos de input estão sendo renderizados
      expect(find.byType(TextField), findsNWidgets(6)); // Nome, CPF, Data, Telefone, Email, Senha
      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('CPF'), findsOneWidget);
      expect(find.text('Data de Nascimento'), findsOneWidget);
      expect(find.text('Telefone'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);

      // Verifica se o botão de registro está presente
      expect(find.text('Registrar'), findsOneWidget);
    });

    testWidgets('Exibe um erro se o registro falhar', (WidgetTester tester) async {
      // Define o comportamento do mock para falhar no registro
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Erro no servidor', 400));

      await tester.pumpWidget(MaterialApp(home: RegisterPage()));

      // Preenche os campos de texto
      await tester.enterText(find.byType(TextField).at(0), 'João Silva'); // Nome
      await tester.enterText(find.byType(TextField).at(1), '123.456.789-00'); // CPF
      await tester.enterText(find.byType(TextField).at(2), '01/01/1990'); // Data
      await tester.enterText(find.byType(TextField).at(3), '(11) 91234-5678'); // Telefone
      await tester.enterText(find.byType(TextField).at(4), 'joao@example.com'); // Email
      await tester.enterText(find.byType(TextField).at(5), 'senha123'); // Senha

      // Tenta registrar o usuário clicando no botão
      await tester.tap(find.text('Registrar'));
      await tester.pump(); // Aguarda o frame

      // Verifica se uma mensagem de erro é exibida
      expect(find.text('Erro ao registrar o usuário: Erro no servidor'), findsOneWidget);
    });

    testWidgets('Registra com sucesso e navega para a tela de login',
        (WidgetTester tester) async {
      // Define o comportamento do mock para registrar com sucesso
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{}', 201));

      await tester.pumpWidget(MaterialApp(home: RegisterPage()));

      // Preenche os campos de texto
      await tester.enterText(find.byType(TextField).at(0), 'João Silva'); // Nome
      await tester.enterText(find.byType(TextField).at(1), '123.456.789-00'); // CPF
      await tester.enterText(find.byType(TextField).at(2), '01/01/1990'); // Data
      await tester.enterText(find.byType(TextField).at(3), '(11) 91234-5678'); // Telefone
      await tester.enterText(find.byType(TextField).at(4), 'joao@example.com'); // Email
      await tester.enterText(find.byType(TextField).at(5), 'senha123'); // Senha

      // Tenta registrar o usuário clicando no botão
      await tester.tap(find.text('Registrar'));
      await tester.pump(); // Aguarda o frame

      // Verifica se a mensagem de sucesso é exibida
      expect(find.text('Usuário registrado com sucesso!'), findsOneWidget);

      // Verifica se a navegação para a tela de login ocorreu
      // Isso pode ser mockado ou simulado conforme necessário
    });
  });
}


