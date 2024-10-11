import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:turquesa_app/apresentacao_screen.dart';
import 'package:turquesa_app/login_screen.dart';
import 'package:turquesa_app/screens/about_us_screen.dart';
import 'package:turquesa_app/screens/login_screen.dart';

void main() {
  testWidgets('AboutUsScreen renders correctly and navigates to LoginPage', (WidgetTester tester) async {
    // Build the AboutUsScreen widget
    await tester.pumpWidget(MaterialApp(home: AboutUsScreen()));

    // Verifica se o logo está presente
    expect(find.byType(Image), findsOneWidget);
    
    // Verifica se os três cards com textos estão presentes
    expect(find.textContaining('A Turquesa Esmalteria e Beleza'), findsOneWidget);
    expect(find.textContaining('Nossos serviços variam'), findsOneWidget);
    expect(find.textContaining('Com diversas unidades espalhadas'), findsOneWidget);

    // Verifica se o indicador de página está presente
    expect(find.byType(SmoothPageIndicator), findsOneWidget);

    // Verifica o botão de navegação para a tela de login
    expect(find.text('Ir para Login'), findsOneWidget);

    // Simula a navegação para a tela de Login
    await tester.tap(find.text('Ir para Login'));
    await tester.pumpAndSettle();

    // Verifica se a navegação para a LoginPage foi realizada
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('PageView interaction works and displays correct pages', (WidgetTester tester) async {
    // Build the AboutUsScreen widget
    await tester.pumpWidget(MaterialApp(home: AboutUsScreen()));

    // Verifica se o PageView exibe o primeiro card inicialmente
    expect(find.textContaining('A Turquesa Esmalteria e Beleza'), findsOneWidget);

    // Arrasta para a esquerda para o próximo card
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    // Verifica se o segundo card é exibido
    expect(find.textContaining('Nossos serviços variam'), findsOneWidget);

    // Arrasta novamente para a esquerda para o terceiro card
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    // Verifica se o terceiro card é exibido
    expect(find.textContaining('Com diversas unidades espalhadas'), findsOneWidget);
  });
}
