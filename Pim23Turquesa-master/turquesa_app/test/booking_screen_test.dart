import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turquesa_app/booking_screen.dart'; // Suponha que o arquivo se chame booking_screen.dart

void main() {
  testWidgets('BookingScreen test', (WidgetTester tester) async {
    // Carrega a tela de agendamento
    await tester.pumpWidget(MaterialApp(home: BookingScreen()));

    // Verifica se os elementos de título da seção estão presentes
    expect(find.text("Select a Service"), findsOneWidget);
    expect(find.text("Select a Specialist"), findsOneWidget);
    expect(find.text("Select a Date"), findsOneWidget);
    expect(find.text("Select a Time"), findsOneWidget);

    // Testa a seleção de um serviço
    await tester.tap(find.byType(DropdownButtonFormField).first);
    await tester.pumpAndSettle(); // Aguarda a lista aparecer
    await tester.tap(find.text("Haircut").last); // Seleciona "Haircut"
    await tester.pumpAndSettle(); // Aguarda a mudança
    expect(find.text("Haircut"), findsOneWidget); // Verifica se "Haircut" foi selecionado

    // Testa a seleção de um especialista
    await tester.tap(find.byType(DropdownButtonFormField).at(1));
    await tester.pumpAndSettle(); // Aguarda a lista aparecer
    await tester.tap(find.text("Alicia").last); // Seleciona "Alicia"
    await tester.pumpAndSettle(); // Aguarda a mudança
    expect(find.text("Alicia"), findsOneWidget); // Verifica se "Alicia" foi selecionada

    // Testa a seleção de uma data
    expect(find.byType(CalendarDatePicker), findsOneWidget); // Verifica o date picker
    await tester.tap(find.byType(CalendarDatePicker)); // Toca no calendário
    await tester.pumpAndSettle();
    // Aqui poderia simular o clique em uma data específica se necessário

    // Testa a seleção de uma hora
    await tester.tap(find.byIcon(Icons.access_time)); // Clica no botão de seleção de hora
    await tester.pumpAndSettle();
    expect(find.text("Choose a time"), findsOneWidget); // Verifica se o botão para escolher horário está visível

    // Testa o botão de confirmar agendamento sem preencher todos os dados
    await tester.tap(find.text("Confirm Booking"));
    await tester.pump(); // Aguarda a ação do botão
    expect(find.text("Please fill all the details."), findsOneWidget); // Verifica a mensagem de erro

    // Simula o preenchimento dos dados completos e tenta confirmar
    await tester.tap(find.text("Haircut").last); // Preenche serviço
    await tester.pumpAndSettle();
    await tester.tap(find.text("Alicia").last); // Preenche especialista
    await tester.pumpAndSettle();
    await tester.tap(find.text("Confirm Booking"));
    await tester.pump(); // Aguarda a ação do botão

    // Verifica se a confirmação do agendamento foi bem-sucedida
    expect(find.textContaining("Service booked with Alicia for Haircut"), findsOneWidget);
  });
}
