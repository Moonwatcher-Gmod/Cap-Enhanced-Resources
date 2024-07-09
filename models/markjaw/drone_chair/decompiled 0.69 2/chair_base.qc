// Created by Crowbar 0.71

$modelname "MarkJaw/drone_chair/chair_base.mdl"

$staticprop

$bodygroup "Body"
{
	studio "detail.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 1.24 8.041

$cdmaterials "MarkJaw\drone_chair\"

$texturegroup "skinfamilies"
{
	{ "chair_base_ac_off"   }
	{ "chair_base_ac_on"    }
	{ "chair_base_ac_red"   }
	{ "chair_base_blue_off" }
	{ "chair_base_blue_on"  }
	{ "chair_base_blue_red" }
}

$cbox 0 0 0 0 0 0

$bbox -118.464 -102.801 -0.25 116.917 102.465 16.384

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"chair_base_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 1
}

$collisionmodel "chair_base_physics.smd"
{
	$mass 200
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 18

}
