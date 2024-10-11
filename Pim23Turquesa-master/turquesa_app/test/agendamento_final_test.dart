import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turquesa_app/agendamento_final_screen.dart';
import 'package:turquesa_app/screens/agendamento_final_screen.dart';

void main() {
  // Dados fictícios de exemplo para serviço e franquia
  final mockServico = {
    'name': 'Corte de Cabelo',
    'image': 'https://example.com/corte.jpg',
    'price': 50.00,
  };
  
  final mockFranquia = {
    'nome': 'Franquia Central',
  };

  testWidgets('AgendamentoFinalScreen renders correctly', (WidgetTester tester) async {
    // Constrói a tela AgendamentoFinalScreen com dados de exemplo
    await tester.pumpWidget(MaterialApp(
      home: AgendamentoFinalScreen(servico: mockServico, franquia: mockFranquia),
    ));

    // Verifica se o nome do serviço está presente
    expect(find.text('Corte de Cabelo'), findsOneWidget);

    // Verifica se o nome da franquia está presente
    expect(find.text('Franquia Central'), findsOneWidget);

    // Verifica se o preço do serviço está presente
    expect(find.text('Preço: \$50.0'), findsOneWidget);

    // Verifica se os dias disponíveis estão sendo exibidos
    expect(find.textContaining(RegExp(r'\d{2}/\d{2}')), findsWidgets);
  });

  testWidgets('Selecting a day opens time selection sheet', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AgendamentoFinalScreen(servico: mockServico, franquia: mockFranquia),
    ));

    // Encontra um dia disponível e simula um clique
    await tester.tap(find.textContaining(RegExp(r'\d{2}/\d{2}')));
    await tester.pumpAndSettle();

    // Verifica se o modal de seleção de horários foi aberto
    expect(find.textContaining('Horários disponíveis para'), findsOneWidget);

    // Verifica se os horários disponíveis estão sendo exibidos
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('11:00'), findsOneWidget);
    expect(find.text('14:00'), findsOneWidget);
    expect(find.text('16:00'), findsOneWidget);
  });

  testWidgets('Confirming an appointment shows a confirmation dialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AgendamentoFinalScreen(servico: mockServico, franquia: mockFranquia),
    ));

    // Seleciona um dia disponível
    await tester.tap(find.textContaining(RegExp(r'\d{2}/\d{2}')));
    await tester.pumpAndSettle();

    // Seleciona um horário
    await tester.tap(find.text('09:00'));
    await tester.pumpAndSettle();

    // Verifica se o diálogo de confirmação de agendamento é exibido
    expect(find.text('Confirmar Agendamento'), findsOneWidget);

    // Verifica o conteúdo do diálogo
    expect(
      find.text('Você está agendando o serviço Corte de Cabelo na franquia Franquia Central para o dia'),
      findsOneWidget,
    );

    // Simula a confirmação do agendamento
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    // Verifica se a mensagem de sucesso foi exibida
    expect(find.text('Agendamento realizado com sucesso!'), findsOneWidget);
  });
}
