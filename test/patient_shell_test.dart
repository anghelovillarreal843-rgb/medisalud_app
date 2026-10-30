import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_medisalud/screens/mobile/patient_shell.dart';
import 'package:app_medisalud/theme/app_theme.dart';

void main() {
  testWidgets('La app del paciente navega por sus cinco secciones', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: PatientShell(onLogout: () {}),
      ),
    );

    expect(find.text('Hola, María'), findsOneWidget);

    final tabs = [
      Icons.calendar_month_outlined,
      Icons.folder_shared_outlined,
      Icons.medication_outlined,
      Icons.person_outline_rounded,
    ];

    for (final icon in tabs) {
      await tester.tap(find.byIcon(icon).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Pestaña $icon');
    }
  });
}
