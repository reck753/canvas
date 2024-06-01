open Jest
open Expect

module Models = Canvas__Models
module ElementUtils = Canvas__ElementUtils

describe("ElementUtils", () => {
  describe("getElementId", () => {
    test(
      "returns the id of a line",
      () => {
        let element = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        expect(ElementUtils.getElementId(element))->toEqual("line1")
      },
    )
    test(
      "returns the id of a rect",
      () => {
        let element = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        expect(ElementUtils.getElementId(element))->toEqual("rect1")
      },
    )
  })

  describe("getElementZIndex", () => {
    test(
      "returns the zIndex of a line",
      () => {
        let element = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        expect(ElementUtils.getElementZIndex(element))->toEqual(1.)
      },
    )
    test(
      "returns the zIndex of a rect",
      () => {
        let element = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        expect(ElementUtils.getElementZIndex(element))->toEqual(1.)
      },
    )
  })

  describe("updateElementAtPosition", () => {
    test(
      "updates the element at a position",
      () => {
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let elements = [line, rect]
        let position = 0
        let updatedLine = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let updatedElements = ElementUtils.updateElementAtPosition(
          ~elements,
          ~position,
          ~element=updatedLine,
        )
        expect(updatedElements)->toEqual([updatedLine, rect])
      },
    )
  })

  describe("isSelected", () => {
    test(
      "returns true if the element is selected",
      () => {
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let selectedElementIds = [ElementUtils.getElementId(line)]
        expect(ElementUtils.isSelected("line1", selectedElementIds))->toBe(true)
      },
    )
    test(
      "returns false if the element is not selected",
      () => {
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let selectedElementIds = [ElementUtils.getElementId(line)]
        expect(ElementUtils.isSelected("rect1", selectedElementIds))->toBe(false)
      },
    )
  })

  describe("getElementAtPoint", () => {
    test(
      "returns the element at a point",
      () => {
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let elements = [line, rect]
        let element = ElementUtils.getElementAtPoint(elements, 50., 50.)
        expect(element)->toEqual(Some(line))
      },
    )
    test(
      "does not return an element if there is no element at the point",
      () => {
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let elements = [line, rect]
        let element = ElementUtils.getElementAtPoint(elements, 200., 200.)
        expect(element)->toEqual(None)
      },
    )
  })

  describe("moveSelectedElements", () => {
    test(
      "moves the selected elements",
      () => {
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let elements = [line, rect]
        let selectedElementIds = [ElementUtils.getElementId(line)]
        let move: Models.Selection.move = {
          origin: {x: 0., y: 0.},
          target: {x: 0., y: 0.},
        }
        let movedElements =
          elements->ElementUtils.moveSelectedElements(
            ~move,
            ~selectedElementIds,
            ~clientX=50.,
            ~clientY=50.,
          )
        let movedLine = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 50., y: 50.},
          end: {x: 150., y: 150.},
          label: None,
        })
        expect(movedElements)->toEqual([movedLine, rect])
      },
    )

    test(
      "moves the selected elements while preserving the label",
      () => {
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: Some("A"),
        })
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: Some("B"),
        })
        let line2 = Models.Line({
          id: "line2",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 200., y: 200.},
          label: None,
        })
        let elements = [line, line2, rect]
        let selectedElementIds = [ElementUtils.getElementId(line), ElementUtils.getElementId(line2)]
        let move: Models.Selection.move = {
          origin: {x: 0., y: 0.},
          target: {x: 0., y: 0.},
        }
        let movedElements =
          elements->ElementUtils.moveSelectedElements(
            ~move,
            ~selectedElementIds,
            ~clientX=50.,
            ~clientY=50.,
          )
        let movedLine = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 50., y: 50.},
          end: {x: 150., y: 150.},
          label: Some("B"),
        })
        let movedLine2 = Models.Line({
          id: "line2",
          toolId: "line",
          zIndex: 1.,
          start: {x: 50., y: 50.},
          end: {x: 250., y: 250.},
          label: None,
        })
        expect(movedElements)->toEqual([movedLine, movedLine2, rect])
      },
    )
  })

  describe("isElementSelected", () => {
    test(
      "returns true if the element is selected",
      () => {
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let selectedElementIds = [ElementUtils.getElementId(line)]
        expect(ElementUtils.isElementSelected(line, ~selectedElementIds))->toBe(true)
      },
    )
    test(
      "returns false if the element is not selected",
      () => {
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let selectedElementIds = [ElementUtils.getElementId(line)]
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        expect(ElementUtils.isElementSelected(rect, ~selectedElementIds))->toBe(false)
      },
    )
  })

  describe("getFirstElementId", () => {
    test(
      "returns the id of the first element",
      () => {
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 0.,
          y: 0.,
          width: 100.,
          height: 100.,
          label: None,
        })
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 0., y: 0.},
          end: {x: 100., y: 100.},
          label: None,
        })
        let elements = [line, rect]
        expect(elements->ElementUtils.getFirstElementId)->toEqual("line1")
      },
    )
  })

  describe("roundNumberBySnapGridSize", () => {
    test(
      "rounds a number by a snap grid size (10, 5)->10",
      () => {
        expect(ElementUtils.roundNumberBySnapGridSize(10., ~gridSize=5.))->toEqual(10.)
      },
    )
    test(
      "rounds a number by a snap grid size (11, 5)->10",
      () => {
        expect(ElementUtils.roundNumberBySnapGridSize(11., ~gridSize=5.))->toEqual(10.)
      },
    )
    test(
      "rounds a number by a snap grid size (12, 5)->15",
      () => {
        expect(ElementUtils.roundNumberBySnapGridSize(12., ~gridSize=5.))->toEqual(10.)
      },
    )
    test(
      "rounds a number by a snap grid size (12.5, 5)->15",
      () => {
        expect(ElementUtils.roundNumberBySnapGridSize(12.5, ~gridSize=5.))->toEqual(15.)
      },
    )
    test(
      "rounds a number by a snap grid size (13, 5)->15",
      () => {
        expect(ElementUtils.roundNumberBySnapGridSize(13., ~gridSize=5.))->toEqual(15.)
      },
    )
    test(
      "rounds a number by a snap grid size (14, 5)->15",
      () => {
        expect(ElementUtils.roundNumberBySnapGridSize(14., ~gridSize=5.))->toEqual(15.)
      },
    )
    test(
      "rounds a number by a snap grid size (15, 5)->15",
      () => {
        expect(ElementUtils.roundNumberBySnapGridSize(15., ~gridSize=5.))->toEqual(15.)
      },
    )
  })

  describe("snapElementToGrid", () => {
    test(
      "snaps a line to a grid",
      () => {
        let line = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 12., y: 14.},
          end: {x: 21., y: 29.},
          label: None,
        })
        let snappedLine = ElementUtils.snapElementToGrid(line, ~gridSize=5.)
        let expectedLine = Models.Line({
          id: "line1",
          toolId: "line",
          zIndex: 1.,
          start: {x: 10., y: 15.},
          end: {x: 20., y: 30.},
          label: None,
        })
        expect(snappedLine)->toEqual(expectedLine)
      },
    )
    test(
      "snaps a rect to a grid",
      () => {
        let rect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 12.,
          y: 14.,
          width: 21.,
          height: 29.,
          label: None,
        })
        let snappedRect = ElementUtils.snapElementToGrid(rect, ~gridSize=5.)
        let expectedRect = Models.Rect({
          id: "rect1",
          toolId: "rect",
          zIndex: 1.,
          x: 10.,
          y: 15.,
          width: 20.,
          height: 30.,
          label: None,
        })
        expect(snappedRect)->toEqual(expectedRect)
      },
    )
  })
})
