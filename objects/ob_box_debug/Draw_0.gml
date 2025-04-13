/// @description 
if (!drawCan()) { exit; };
    

draw_set_color(image_blend);
drawLine(bbox_left, bbox_top, bbox_right, bbox_top);
drawLine(bbox_right, bbox_top, bbox_right, bbox_bottom);
drawLine(bbox_right, bbox_bottom, bbox_left, bbox_bottom);
drawLine(bbox_left, bbox_bottom, bbox_left, bbox_top);