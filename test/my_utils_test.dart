import 'package:flutter_test/flutter_test.dart';
import 'package:ni_trades/util/my_utils.dart';

main() {
  group("Greeting Tests", () {
    test('Greet Morning', () {
      String greeting = AppUtils.greet(DateTime.parse("2021-05-26 06:18:04Z"));
      expect(greeting, "Morning");
    });

    test('Greet Afternoon', () {
      String greeting = AppUtils.greet(DateTime.parse("2021-05-26 13:18:04Z"));
      expect(greeting, "Afternoon");
    });

    test('Greet Evening', () {
      String greeting = AppUtils.greet(DateTime.parse("2021-05-26 20:18:04Z"));
      expect(greeting, "Evening");
    });
  });

  group("Investment Due Date", () {
    test("Investment due date in 2 months", () {
      int months = 2;
      DateTime startDate = DateTime.parse("2021-05-26 20:18:04Z");

      String dueDate = AppUtils.getInvestmentDueDate(
          startDate.millisecondsSinceEpoch, months);

      expect('Tuesday, July 27, 2021', dueDate);
    });

    test("Investment Countdown", () {
      int months = 2;
      DateTime startDate = DateTime.parse("2021-05-20 20:18:04Z");

      int dueDate = AppUtils.getFutureInvestmentCountDown(
          startDate.millisecondsSinceEpoch, months);

      expect(56, dueDate);
    });
  });
}
