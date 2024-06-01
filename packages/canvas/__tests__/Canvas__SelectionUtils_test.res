open Jest
open Expect

module Models = Canvas__Models
module SelectionUtils = Canvas__SelectionUtils

describe("SelectionUtils", () => {
  describe("sqr", () => {
    test(
      "returns the square of a float",
      () => {
        expect(SelectionUtils.sqr(2.))->toBe(4.)
      },
    )
  })

  describe("dist2", () => {
    test(
      "returns the square of the distance between two points",
      () => {
        expect(SelectionUtils.dist2(0., 0., 3., 4.))->toBe(25.)
      },
    )
  })

  describe("distToLineSegmentSquared", () => {
    test(
      "returns the square of the distance from a point to a line segment",
      () => {
        expect(SelectionUtils.distToLineSegmentSquared(0., 0., 3., 4., 3., 4.))->toBe(25.)
      },
    )
  })

  describe("isPointNearLine", () => {
    let testLine: Models.Line.t = {
      id: "1",
      toolId: "line",
      zIndex: 0.,
      start: {x: 1., y: 1.},
      end: {x: 3., y: 4.},
      label: None,
    }
    test(
      "returns true if the point is on then line",
      () => {
        expect(SelectionUtils.isPointNearLine(3., 4., testLine, 0.))->toBe(true)
      },
    )
    test(
      "returns true if the point is within the tolerance distance from the line",
      () => {
        expect(SelectionUtils.isPointNearLine(0., 1., testLine, 1.))->toBe(true)
      },
    )
    test(
      "returns false if the point is not within the tolerance distance from the line",
      () => {
        expect(SelectionUtils.isPointNearLine(0., 1., testLine, 0.5))->toBe(false)
      },
    )
    test(
      "returns false if the point is not on the line",
      () => {
        expect(SelectionUtils.isPointNearLine(0., 0., testLine, 0.))->toBe(false)
      },
    )
  })

  describe("normalizeRect", () => {
    test(
      "returns the same rect if width and height are both positive",
      () => {
        let rect: Models.Rect.t = {
          id: "1",
          toolId: "rect",
          zIndex: 0.,
          x: 0.,
          y: 0.,
          width: 1.,
          height: 1.,
          label: None,
        }
        expect(SelectionUtils.normalizeRect(rect))->toEqual(rect)
      },
    )
    test(
      "returns a rect with positive width and height if both are negative and adjusts x and y accordingly",
      () => {
        let rect: Models.Rect.t = {
          id: "1",
          toolId: "rect",
          zIndex: 0.,
          x: 1.,
          y: 1.,
          width: -1.,
          height: -1.,
          label: None,
        }
        expect(SelectionUtils.normalizeRect(rect))->toEqual({
          id: "1",
          toolId: "rect",
          zIndex: 0.,
          x: 0.,
          y: 0.,
          width: 1.,
          height: 1.,
          label: None,
        })
      },
    )
    test(
      "returns a rect with positive width and height if width is negative",
      () => {
        let rect: Models.Rect.t = {
          id: "1",
          toolId: "rect",
          zIndex: 0.,
          x: 1.,
          y: 1.,
          width: -1.,
          height: 1.,
          label: None,
        }
        expect(SelectionUtils.normalizeRect(rect))->toEqual({
          id: "1",
          toolId: "rect",
          zIndex: 0.,
          x: 0.,
          y: 1.,
          width: 1.,
          height: 1.,
          label: None,
        })
      },
    )
    test(
      "returns a rect with positive width and height if height is negative",
      () => {
        let rect: Models.Rect.t = {
          id: "1",
          toolId: "rect",
          zIndex: 0.,
          x: 1.,
          y: 1.,
          width: 1.,
          height: -1.,
          label: None,
        }
        expect(SelectionUtils.normalizeRect(rect))->toEqual({
          id: "1",
          toolId: "rect",
          zIndex: 0.,
          x: 1.,
          y: 0.,
          width: 1.,
          height: 1.,
          label: None,
        })
      },
    )
  })

  describe("normalizeSelection", () => {
    test(
      "returns the same selection if width and height are both positive",
      () => {
        let selection: Models.Selection.t = {x: 0., y: 0., width: 1., height: 1.}
        expect(SelectionUtils.normalizeSelection(selection))->toEqual(selection)
      },
    )
    test(
      "returns a selection with positive width and height if both are negative and adjusts x and y accordingly",
      () => {
        let selection: Models.Selection.t = {x: 1., y: 1., width: -1., height: -1.}
        expect(SelectionUtils.normalizeSelection(selection))->toEqual({
          x: 0.,
          y: 0.,
          width: 1.,
          height: 1.,
        })
      },
    )
    test(
      "returns a selection with positive width and height if width is negative",
      () => {
        let selection: Models.Selection.t = {x: 1., y: 1., width: -1., height: 1.}
        expect(SelectionUtils.normalizeSelection(selection))->toEqual({
          x: 0.,
          y: 1.,
          width: 1.,
          height: 1.,
        })
      },
    )
    test(
      "returns a selection with positive width and height if height is negative",
      () => {
        let selection: Models.Selection.t = {x: 1., y: 1., width: 1., height: -1.}
        expect(SelectionUtils.normalizeSelection(selection))->toEqual({
          x: 1.,
          y: 0.,
          width: 1.,
          height: 1.,
        })
      },
    )
  })

  describe("expandSelectionBox", () => {
    test(
      "expands the selection box by the tolerance value on all sides",
      () => {
        let selection: Models.Selection.t = {x: 1., y: 1., width: 1., height: 1.}
        expect(SelectionUtils.expandSelectionBox(selection, 2.))->toEqual({
          x: -1.,
          y: -1.,
          width: 5.,
          height: 5.,
        })
      },
    )
  })

  describe("isPointInsideSelection", () => {
    test(
      "returns true if the point is inside the selection",
      () => {
        let selection: Models.Selection.t = {x: 1., y: 1., width: 1., height: 1.}
        expect(SelectionUtils.isPointInsideSelection(selection, 1.5, 1.5))->toBe(true)
      },
    )
    test(
      "returns false if the point is outside the selection",
      () => {
        let selection: Models.Selection.t = {x: 1., y: 1., width: 1., height: 1.}
        expect(SelectionUtils.isPointInsideSelection(selection, 0.5, 0.5))->toBe(false)
      },
    )
    test(
      "returns true if the point is on the edge of the selection",
      () => {
        let selection: Models.Selection.t = {x: 1., y: 1., width: 1., height: 1.}
        expect(SelectionUtils.isPointInsideSelection(selection, 1., 1.))->toBe(true)
      },
    )
  })

  describe("onSegment", () => {
    test(
      "returns true if the point is on the line segment",
      () => {
        expect(SelectionUtils.onSegment(1., 1., 2., 2., 3., 3.))->toBe(true)
      },
    )
    test(
      "returns false if the point is not on the line segment",
      () => {
        expect(SelectionUtils.onSegment(1., 1., 2., 2., 3., 4.))->toBe(false)
      },
    )
    test(
      "returns true if the point is on the edge of the line segment",
      () => {
        expect(SelectionUtils.onSegment(1., 1., 3., 3., 3., 3.))->toBe(true)
      },
    )
  })

  describe("orientation", () => {
    test(
      "returns 0 if the points are collinear",
      () => {
        expect(SelectionUtils.orientation(100., 100., 200., 200., 300., 300.))->toBe(0)
      },
    )
    test(
      "returns 1 if the points are clockwise",
      () => {
        expect(SelectionUtils.orientation(100., 300., 200., 200., 200., 300.))->toBe(1)
      },
    )
    test(
      "returns 2 if the points are counterclockwise",
      () => {
        expect(SelectionUtils.orientation(200., 200., 100., 300., 200., 300.))->toBe(2)
      },
    )
  })

  describe("doIntersect", () => {
    test(
      "returns true if the line segments intersect",
      () => {
        expect(SelectionUtils.doIntersect(1., 1., 3., 3., 3., 1., 1., 3.))->toBe(true)
      },
    )
    test(
      "returns false if the line segments do not intersect",
      () => {
        expect(SelectionUtils.doIntersect(1., 1., 2., 2., 3., 3., 4., 4.))->toBe(false)
      },
    )
    test(
      "returns true if the line segments share an endpoint",
      () => {
        expect(SelectionUtils.doIntersect(1., 1., 2., 2., 2., 2., 3., 3.))->toBe(true)
      },
    )
    test(
      "returns true if the line segments intersect in a counterclockwise direction",
      () => {
        expect(SelectionUtils.doIntersect(1., 3., 3., 3., 3., 1., 1., 3.))->toBe(true)
      },
    )
  })

  describe("lineIntersectsSelection", () => {
    let testLine: Models.Line.t = {
      id: "1",
      toolId: "line",
      zIndex: 0.,
      start: {x: 5., y: 5.},
      end: {x: 10., y: 10.},
      label: None,
    }
    test(
      "returns true if the line intersects the selection",
      () => {
        expect(
          SelectionUtils.lineIntersectsSelection(
            testLine,
            {x: 5., y: 8., width: 4., height: 4.},
            0.,
          ),
        )->toBe(true)
      },
    )
    test(
      "returns true if the line intersects the selection's edge",
      () => {
        expect(
          SelectionUtils.lineIntersectsSelection(
            testLine,
            {x: 5., y: 8., width: 2., height: 2.},
            1.,
          ),
        )->toBe(true)
      },
    )
    test(
      "returns false if the line does not intersect the selection",
      () => {
        expect(
          SelectionUtils.lineIntersectsSelection(
            testLine,
            {x: 5., y: 8., width: 2., height: 2.},
            0.,
          ),
        )->toBe(false)
      },
    )
    test(
      "returns false if the line does not intersect the selection",
      () => {
        expect(
          SelectionUtils.lineIntersectsSelection(
            testLine,
            {x: 5., y: 9., width: 1., height: 1.},
            1.,
          ),
        )->toBe(false)
      },
    )
  })

  describe("rectIntersectsSelection", () => {
    let testRect: Models.Rect.t = {
      id: "1",
      toolId: "rect",
      zIndex: 0.,
      x: 5.,
      y: 5.,
      width: 5.,
      height: 5.,
      label: None,
    }
    test(
      "returns true if the rect intersects the selection",
      () => {
        expect(
          SelectionUtils.rectIntersectsSelection(testRect, {x: 4., y: 4., width: 2., height: 2.}),
        )->toBe(true)
      },
    )
    test(
      "returns true if the rect intersects the selection's edge",
      () => {
        expect(
          SelectionUtils.rectIntersectsSelection(testRect, {x: 4., y: 4., width: 1., height: 1.}),
        )->toBe(true)
      },
    )
    test(
      "returns false if the rect does not intersect the selection",
      () => {
        expect(
          SelectionUtils.rectIntersectsSelection(testRect, {x: 3., y: 3., width: 1., height: 1.}),
        )->toBe(false)
      },
    )
    test(
      "returns false if the rect does not intersect the selection",
      () => {
        expect(
          SelectionUtils.rectIntersectsSelection(testRect, {x: 11., y: 11., width: 2., height: 2.}),
        )->toBe(false)
      },
    )
    test(
      "returns true if the rect intersects the selection with negative width and height",
      () => {
        expect(
          SelectionUtils.rectIntersectsSelection(
            testRect,
            {x: 11., y: 11., width: -2., height: -2.},
          ),
        )->toBe(true)
      },
    )
    test(
      "return false if the rect does not intersect the selection with negative width and height",
      () => {
        expect(
          SelectionUtils.rectIntersectsSelection(
            testRect,
            {x: 13., y: 13., width: -1., height: -1.},
          ),
        )->toBe(false)
      },
    )
  })

  describe("isClick", () => {
    test(
      "returns true if the selection is smaller than the tolerance",
      () => {
        expect(SelectionUtils.isClick({x: 1., y: 1., width: 1., height: 1.}, 2.))->toBe(true)
      },
    )
    test(
      "returns false if the selection is larger than the tolerance",
      () => {
        expect(SelectionUtils.isClick({x: 1., y: 1., width: 2., height: 2.}, 2.))->toBe(false)
      },
    )
  })

  describe("didMove", () => {
    test(
      "returns true if the origin and target are different",
      () => {
        expect(SelectionUtils.didMove({origin: {x: 1., y: 1.}, target: {x: 2., y: 2.}}))->toBe(true)
      },
    )
    test(
      "returns false if the origin and target are the same",
      () => {
        expect(SelectionUtils.didMove({origin: {x: 1., y: 1.}, target: {x: 1., y: 1.}}))->toBe(
          false,
        )
      },
    )
  })

  describe("isPointNearPoint", () => {
    test(
      "returns true if point is exactly on top of the other point without tolerance",
      () => {
        expect(SelectionUtils.isPointNearPoint(50., 50., 50., 50., 0.))->toBe(true)
      },
    )

    test(
      "returns true if point is exactly on top of the other point with tolerance",
      () => {
        expect(SelectionUtils.isPointNearPoint(50., 50., 50., 50., 10.))->toBe(true)
      },
    )

    test(
      "returns false if point is not on top of the other point without tolerance",
      () => {
        expect(SelectionUtils.isPointNearPoint(50., 50., 51., 51., 0.))->toBe(false)
      },
    )

    test(
      "returns true if point is not on top of the other point and is within given tolerance",
      () => {
        expect(SelectionUtils.isPointNearPoint(50., 50., 51., 51., 2.))->toBe(true)
      },
    )

    test(
      "returns true if point is not on top of the other point and is within given tolerance",
      () => {
        expect(SelectionUtils.isPointNearPoint(50., 50., 49., 49., 2.))->toBe(true)
      },
    )

    test(
      "returns false if point is not on top of the other point and is not within given tolerance",
      () => {
        expect(SelectionUtils.isPointNearPoint(50., 50., 53., 53., 2.))->toBe(false)
      },
    )

    test(
      "returns false if point is not on top of the other point and is not within given tolerance",
      () => {
        expect(SelectionUtils.isPointNearPoint(50., 50., 47., 47., 2.))->toBe(false)
      },
    )
  })
})
