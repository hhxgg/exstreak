import 'package:exstreak/domain/enums.dart';
import 'package:exstreak/domain/plan/plan_templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlanTemplate', () {
    test('set targets always add up to the displayed total', () {
      for (final template in PlanTemplates.all) {
        for (var level = 1; level <= template.levelCount; level++) {
          for (var day = 1; day <= template.daysPerLevel; day++) {
            final planDay = template.dayFor(level, day);
            expect(
              planDay.total,
              template.totalFor(level, day),
              reason: '${template.id} L$level D$day must sum to its total',
            );
          }
        }
      }
    });

    test('produces the configured number of sets', () {
      for (final template in PlanTemplates.all) {
        final day = template.dayFor(1, 1);
        expect(day.setCount, template.setCount);
        expect(day.targets, hasLength(template.setCount));
      }
    });

    test('no set is below the minimum', () {
      for (final template in PlanTemplates.all) {
        for (var level = 1; level <= template.levelCount; level++) {
          final day = template.dayFor(level, 1);
          for (final target in day.targets) {
            expect(
              target,
              greaterThanOrEqualTo(template.minPerSet),
              reason: '${template.id} L$level D1 has a set below the minimum',
            );
          }
        }
      }
    });

    test('volume increases monotonically across a level', () {
      for (final template in PlanTemplates.all) {
        for (var level = 1; level <= template.levelCount; level++) {
          var previous = 0;
          for (var day = 1; day <= template.daysPerLevel; day++) {
            final total = template.totalFor(level, day);
            expect(
              total,
              greaterThanOrEqualTo(previous),
              reason: '${template.id} L$level D$day dropped in volume',
            );
            previous = total;
          }
        }
      }
    });

    test('each level starts harder than the previous one ended is not '
        'required, but starts harder than the previous level started', () {
      for (final template in PlanTemplates.all) {
        for (var level = 2; level <= template.levelCount; level++) {
          expect(
            template.totalFor(level, 1),
            greaterThan(template.totalFor(level - 1, 1)),
            reason:
                '${template.id} level $level should start above level '
                '${level - 1}',
          );
        }
      }
    });

    test('day and level indices are clamped rather than throwing', () {
      const t = PlanTemplates.pushups;
      expect(() => t.dayFor(0, 0), returnsNormally);
      expect(() => t.dayFor(99, 999), returnsNormally);
      expect(t.dayFor(1, 999).total, t.totalFor(1, t.daysPerLevel));
    });

    test('level() returns every day in order', () {
      const t = PlanTemplates.pushups;
      final days = t.level(1);
      expect(days, hasLength(t.daysPerLevel));
      expect(days.first.day, 1);
      expect(days.last.day, t.daysPerLevel);
    });

    test('summary renders as dot-separated targets', () {
      final day = PlanTemplates.pushups.dayFor(1, 1);
      expect(day.summary, day.targets.join(' · '));
    });

    test('plank plan is duration based and starts at a realistic hold', () {
      const plank = PlanTemplates.plank;
      expect(plank.trackingType, TrackingType.duration);
      final first = plank.dayFor(1, 1);
      // Every set should be a hold a beginner can actually manage.
      expect(first.targets.reduce((a, b) => a > b ? a : b), lessThan(60));
      expect(first.targets.reduce((a, b) => a < b ? a : b), greaterThan(9));
    });

    test('byId resolves known plans and rejects unknown ones', () {
      expect(PlanTemplates.byId('pushup-100'), isNotNull);
      expect(PlanTemplates.byId('does-not-exist'), isNull);
      expect(PlanTemplates.byId(PlanTemplates.defaultPlanId), isNotNull);
    });

    test('every plan references a slug that exists in the seed catalogue', () {
      // Guards against a plan silently pointing at a missing exercise.
      const seededSlugs = {
        'pushup',
        'plank',
        'pullup',
        'squat',
        'situp',
        'dip',
      };
      for (final template in PlanTemplates.all) {
        expect(
          seededSlugs,
          contains(template.exerciseSlug),
          reason: '${template.id} points at an unseeded exercise',
        );
      }
    });
  });
}
