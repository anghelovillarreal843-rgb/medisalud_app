import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_medisalud/main.dart';

void main() {
  testWidgets('La pantalla de acceso muestra la marca y el formulario', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MediSaludApp());

    expect(find.text('MediSalud'), findsWidgets);
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
    expect(find.text('Ingresar al sistema'), findsOneWidget);
    expect(find.text('Crear cuenta de paciente'), findsOneWidget);
  });

  testWidgets('El acceso con rol administrador abre el panel de control', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MediSaludApp());
    await tester.tap(find.text('Ingresar al sistema'));
    await tester.pumpAndSettle();

    expect(find.text('Panel de control'), findsWidgets);
    expect(find.text('Citas de hoy'), findsOneWidget);
  });
}
