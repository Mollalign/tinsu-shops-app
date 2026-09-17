import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tinsu_shops/core/utils/formatters.dart';
import 'package:tinsu_shops/features/sales/domain/sale_model.dart';
import 'package:tinsu_shops/features/sales/presentation/screens/sales_history_screen.dart';
import 'package:tinsu_shops/app/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en', null);
  });

  group('Formatters.dateGroupHeader', () {
    final fixedNow = DateTime(2026, 9, 17, 14, 30); // 17 Sep 2026

    test('returns todayLabel when date is today', () {
      final todaySale = DateTime(2026, 9, 17, 9, 15);
      final headerEn = Formatters.dateGroupHeader(
        todaySale,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        now: fixedNow,
      );
      expect(headerEn, 'Today');

      final headerAm = Formatters.dateGroupHeader(
        todaySale,
        todayLabel: 'ዛሬ',
        yesterdayLabel: 'ትናንት',
        now: fixedNow,
      );
      expect(headerAm, 'ዛሬ');
    });

    test('returns yesterdayLabel when date is yesterday', () {
      final yesterdaySale = DateTime(2026, 9, 16, 22, 45);
      final headerEn = Formatters.dateGroupHeader(
        yesterdaySale,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        now: fixedNow,
      );
      expect(headerEn, 'Yesterday');

      final headerAm = Formatters.dateGroupHeader(
        yesterdaySale,
        todayLabel: 'ዛሬ',
        yesterdayLabel: 'ትናንት',
        now: fixedNow,
      );
      expect(headerAm, 'ትናንት');
    });

    test('returns formatted date for older dates', () {
      final olderSale = DateTime(2026, 9, 10, 11, 0);
      final header = Formatters.dateGroupHeader(
        olderSale,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        locale: 'en',
        now: fixedNow,
      );
      expect(header, 'September 10, 2026');
    });
  });

  group('Sales History Chronological Grouping & Ordering', () {
    // Helper to build test SaleListItem with specific createdAt
    SaleListItem makeSale(String id, DateTime createdAt, {double amount = 100}) {
      return SaleListItem(
        id: id,
        shopId: 'shop-1',
        totalAmount: amount.toString(),
        itemsCount: 1,
        soldByName: 'Hana',
        createdAt: createdAt,
      );
    }

    // Function replicating the screen grouping logic for standalone unit testing
    List<DateGroup> groupSales(List<SaleListItem> items) {
      final map = <DateTime, List<SaleListItem>>{};
      for (final sale in items) {
        final local = sale.createdAt.toLocal();
        final dateKey = DateTime(local.year, local.month, local.day);
        map.putIfAbsent(dateKey, () => []).add(sale);
      }

      final sortedKeys = map.keys.toList()..sort((a, b) => b.compareTo(a));

      return sortedKeys.map((date) {
        final groupSales = map[date]!;
        groupSales.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return DateGroup(date: date, sales: groupSales);
      }).toList();
    }

    test('empty list returns empty groups', () {
      final groups = groupSales([]);
      expect(groups, isEmpty);
    });

    test('orders date groups from newest date to oldest date', () {
      final s1 = makeSale('s1', DateTime(2026, 9, 15, 10, 0));
      final s2 = makeSale('s2', DateTime(2026, 9, 17, 14, 0));
      final s3 = makeSale('s3', DateTime(2026, 9, 16, 12, 0));

      final groups = groupSales([s1, s2, s3]);

      expect(groups.length, 3);
      // Group 0: Sep 17
      expect(groups[0].date, DateTime(2026, 9, 17));
      expect(groups[0].sales.first.id, 's2');

      // Group 1: Sep 16
      expect(groups[1].date, DateTime(2026, 9, 16));
      expect(groups[1].sales.first.id, 's3');

      // Group 2: Sep 15
      expect(groups[2].date, DateTime(2026, 9, 15));
      expect(groups[2].sales.first.id, 's1');
    });

    test('within each date group, orders newest sale first and oldest last', () {
      // 3 sales on the same day: 09:00 AM, 02:30 PM, 08:45 PM
      final morning = makeSale('s-morning', DateTime(2026, 9, 17, 9, 0));
      final afternoon = makeSale('s-afternoon', DateTime(2026, 9, 17, 14, 30));
      final evening = makeSale('s-evening', DateTime(2026, 9, 17, 20, 45));

      // Pass them in unsorted order
      final groups = groupSales([morning, evening, afternoon]);

      expect(groups.length, 1);
      final sales = groups[0].sales;
      expect(sales.length, 3);
      expect(sales[0].id, 's-evening');   // 20:45 (newest)
      expect(sales[1].id, 's-afternoon'); // 14:30
      expect(sales[2].id, 's-morning');   // 09:00 (oldest)
    });

    test('handles multiple sales with identical timestamps gracefully', () {
      final sameTime1 = makeSale('same-1', DateTime(2026, 9, 17, 12, 0, 0));
      final sameTime2 = makeSale('same-2', DateTime(2026, 9, 17, 12, 0, 0));

      final groups = groupSales([sameTime1, sameTime2]);

      expect(groups.length, 1);
      expect(groups[0].sales.length, 2);
      final ids = groups[0].sales.map((s) => s.id).toSet();
      expect(ids, containsAll(['same-1', 'same-2']));
    });

    test('groups multi-day sales accurately by calendar date', () {
      final sales = [
        makeSale('today-1', DateTime(2026, 9, 17, 21, 29)),
        makeSale('today-2', DateTime(2026, 9, 17, 18, 36)),
        makeSale('today-3', DateTime(2026, 9, 17, 14, 39)),
        makeSale('yest-1', DateTime(2026, 9, 16, 22, 19)),
        makeSale('yest-2', DateTime(2026, 9, 16, 22, 16)),
        makeSale('older-1', DateTime(2026, 9, 10, 1, 37)),
      ];

      final groups = groupSales(sales);
      expect(groups.length, 3);

      expect(groups[0].sales.length, 3);
      expect(groups[0].sales.map((s) => s.id).toList(), ['today-1', 'today-2', 'today-3']);

      expect(groups[1].sales.length, 2);
      expect(groups[1].sales.map((s) => s.id).toList(), ['yest-1', 'yest-2']);

      expect(groups[2].sales.length, 1);
      expect(groups[2].sales.first.id, 'older-1');
    });
  });

  group('Navigation & Router Configuration', () {
    test('router config contains /owner/sales and /owner/sales/history', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final goRouter = container.read(routerProvider);

      // Verify route paths exist
      final routes = goRouter.configuration.routes;
      bool hasOwnerSales = false;
      bool hasSalesHistory = false;
      bool hasAnalyticsRedirect = false;
      bool hasMoreRedirect = false;

      void inspectRoute(RouteBase r) {
        if (r is GoRoute) {
          if (r.path == '/owner/sales') hasOwnerSales = true;
          if (r.path == '/owner/sales/history') hasSalesHistory = true;
          if (r.path == '/owner/analytics') hasAnalyticsRedirect = true;
          if (r.path == '/owner/more') hasMoreRedirect = true;
          for (final sub in r.routes) {
            inspectRoute(sub);
          }
        } else if (r is ShellRoute) {
          for (final sub in r.routes) {
            inspectRoute(sub);
          }
        }
      }

      for (final r in routes) {
        inspectRoute(r);
      }

      expect(hasOwnerSales, isTrue, reason: '/owner/sales must exist in router');
      expect(hasSalesHistory, isTrue, reason: '/owner/sales/history must exist in router');
      expect(hasAnalyticsRedirect, isTrue, reason: '/owner/analytics must exist in router');
      expect(hasMoreRedirect, isTrue, reason: '/owner/more must exist in router');
    });
  });
}
