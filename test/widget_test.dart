import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/app.dart';

void main() {
  setUp(() async {
    dotenv.testLoad(fileInput: 'API_BASE_URL=https://poly-insight-layers-production.up.railway.app\n');
  });

  testWidgets('App load test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PolyTickApp()));
    expect(find.byType(PolyTickApp), findsOneWidget);
  });
}
