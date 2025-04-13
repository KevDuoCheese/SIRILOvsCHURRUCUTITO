/// @description 

// increase show
tShow += tShowTime * tShowMove;
if (tShow > 1) { tShow = 0; };

if (keyboard_check_pressed(ord("P"))) { tShowMove = !tShowMove; };