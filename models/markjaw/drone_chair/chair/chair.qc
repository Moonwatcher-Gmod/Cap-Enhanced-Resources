// Created by Crowbar 0.74

$modelname "MarkJaw/drone_chair/chair.mdl"

$bodygroup "Body"
{
	studio "detail.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition -1.791 0.051 28.522

$cdmaterials "MarkJaw\drone_chair\"

$texturegroup "skinfamilies"
{
	{ "chair"         }
	{ "chair_on"      }
	{ "chair_blue"    }
	{ "chair_blue_on" }
}

$cbox 0 0 0 0 0 0

$bbox -44.448 -20.631 -10.758 21.915 18.761 56.947

$definebone "Box04" "" 2.469307 14.181855 8.930363 0 0 89.999982 0 0 0 0 0 0
$definebone "Box05" "" 15.808981 -0.000001 19.701191 0 -90.000037 89.986861 0 0 0 0 0 0
$definebone "Box06" "" -8.869987 -0.000001 18.54126 0 -89.999982 89.983596 0 0 0 0 0 0
$definebone "Box02" "" 1.364616 -12.882625 18.054832 0 0 89.999982 0 0 0 0 0 0
$definebone "Box03" "" 1.59247 -16.665627 26.576977 0 0 0 0 0 0 0 0 0
$definebone "Cylinder01" "" -14.91329 -16.65464 26.658695 0 0 0 0 0 0 0 0 0
$definebone "Sphere01" "" -14.799585 -16.653887 26.214386 0 0 0 0 0 0 0 0 0
$definebone "Box01" "" 1.094761 -12.480221 13.226676 0 0 89.999982 0 0 0 0 0 0
$definebone "Box11" "" 1.364616 20.528212 18.054832 0 0 89.999982 0 0 0 0 0 0
$definebone "Box12" "" 1.59247 16.745209 26.576977 0 0 0 0 0 0 0 0 0
$definebone "Cylinder03" "" -14.91329 16.756195 26.658695 0 0 0 0 0 0 0 0 0
$definebone "Sphere02" "" -14.799585 16.75695 26.214386 0 0 0 0 0 0 0 0 0
$definebone "Box13" "" 1.094761 20.930614 13.226676 0 0 89.999982 0 0 0 0 0 0


$sequence "idleC" {
	"chair_anims\idleC.smd"
	fadein 0.2
	fadeout 0.2
	fps 15
	loop
}

$sequence "idleO" {
	"chair_anims\idleO.smd"
	fadein 0.2
	fadeout 0.2
	fps 15
	loop
}

$sequence "open" {
	"chair_anims\open.smd"
	fadein 0.2
	fadeout 0.2
	fps 15
}

$sequence "close" {
	"chair_anims\close.smd"
	fadein 0.2
	fadeout 0.2
	fps 15
}

$collisionmodel "chair_physics.smd"
{
	$mass 200
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 6

}
