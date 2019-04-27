# Instant River
Instant RIver is a Unity package for creating dynamical rivers.
It comes with an asset for the river and an adjoining editor to edit the river.
The river creation is built upon a spline solution using cubic Bezier Curves to generate its path.
Also comes with a CG water shader as its default material. Can be replaced.

## Getting started
First you need a cope of the software. It can be downloaded from the following sources.
* <https://github.com/bonahona/instantriver>

## Example
Create a new River system in your scene by clicking GameObject->3D Object/River System.
A new river system will be placed in the middle of your current view.
In order to create the river, some collider (like a box, quad, plane or terrain) must be underneath it.
When creating a river, the "Edit path" button in the inspector window of the River System must be pressed.
When it's pressed all control points will be shown and can be edited. By holding down control you can place
new control points. If the new point is somewhere outside the current rivera new point will be added at the end of the river.
If its somewhere on the river, a new point will be inserted in the river. By holding down shift you can remove points at will.
Press space to stop editing the river path.

## License
This project is released as Open Source under a [MIT license](../blob/master/LICENSE.txt).