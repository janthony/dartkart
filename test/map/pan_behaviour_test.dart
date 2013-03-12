library map_viewport_test;

import "dart:html" hide Point;
import "dart:math" as math;
import "dart:svg" hide Point;
import "dart:async";
import "dart:collection";
import "package:unittest/unittest.dart";
import "package:unittest/mock.dart";
import "package:unittest/html_enhanced_config.dart";

import "../../lib/src/layer.dart";
import "../../lib/src/geometry.dart";
import "../../lib/src/geo.dart";
import "../../lib/src/core.dart";
import "../../lib/src/map.dart";

class MapViewportMock extends Mock implements MapViewport {
  MapViewportMock() : super() {
    when(callsTo("pan")).alwaysCall(_logPanStep);
  }

  var panned = new Point.origin();
  reset() {
    panned = new Point.origin();
  }

  _logPanStep(Point panBy) {
    panned += panBy;
  }
}

main() {
  useHtmlEnhancedConfiguration();

  group("short distance panning", () {
    var map;
    var container;

    setUp(() {
      map = new MapViewportMock();
    });

    pan(p) {
      var behaviour = new PanBehaviour(map);
      map.reset();
      behaviour.animate(p);

      new Timer(new Duration(seconds: 2), expectAsync0(() {
        expect(map.panned, p);
      }));
    }

    print("testing short distance panning ...");
    test("- pan east by 100 pixel", () => pan(new Point(100,0)));
    test("- pan west by 100 pixel", () => pan(new Point(-100,0)));
    test("- pan north by 100 pixel", () => pan(new Point(0, -100)));
    test("- pan south by 100 pixel", () => pan(new Point(0, 100)));
  });

  group("long distance panning", () {
    var map;
    var container;

    setUp(() {
      map = new MapViewportMock();
    });

    pan(p) {
      var behaviour = new PanBehaviour(map);
      map.reset();
      behaviour.animate(p);

      new Timer(new Duration(seconds: 3), expectAsync0(() {
        expect(map.panned, p);
      }));
    }

    print("testing long distance panning ...");
    test("- pan east by 500 pixel", () => pan(new Point(500,0)));
    test("- pan west by 500 pixel", () => pan(new Point(-500,0)));
    test("- pan north by 500 pixel", () => pan(new Point(0, -500)));
    test("- pan south by 500 pixel", () => pan(new Point(0, 500)));
  });
}




