# SimpleBox
Box with Custom Hole Patterns in OpenSCAD

This OpenSCAD script generates a rounded box with customizable hole patterns on its walls. The box can feature hexagonal, circular, or diamond-shaped holes, each with adjustable sizes and spacing.

## Parameters
- **length**: Length of the box.
- **width**: Width of the box.
- **height**: Height of the box.
- **radius**: Radius of the rounded corners.
- **thickness**: Wall thickness.
- **hole_type**: Type of hole pattern. Options are `"hex"`, `"circle"`, and `"diamond"`.
- **hole_size**: Array of parameters depending on the hole type:
  - For `"hex"`: [hexagon radius, spacing between hexagons].
  - For `"circle"`: [circle radius, spacing between circles].
  - For `"diamond"`: [diamond width, diamond height, spacing between diamonds].

## Lisence
This project is licensed under the MIT License.