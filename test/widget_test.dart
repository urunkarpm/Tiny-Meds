import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_meds/presentation/screens/main_shell.dart';
import 'package:tiny_meds/presentation/providers/inventory_provider.dart';

void main() {
  testWidgets('TinyMedsApp renders inventory screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          filteredMedicinesProvider.overrideWith((ref) => Stream.value([])),
          inventorySummaryProvider.overrideWith((ref) => Stream.value({'count': 0, 'since': null})),
          expiredMedicinesProvider.overrideWith((ref) => Stream.value([])),
          lowStockMedicinesProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(home: MainShell()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Your Cabinet'), findsOneWidget);
  });
}
