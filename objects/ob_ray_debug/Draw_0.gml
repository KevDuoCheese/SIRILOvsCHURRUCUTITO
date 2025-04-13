/// @description 
if (!drawCan()) { exit; };

draw_set_color(image_blend);
drawLine(myRay.initX, myRay.initY, myRay.endTrueX, myRay.endTrueY);