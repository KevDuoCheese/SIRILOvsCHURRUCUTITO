/// @description 
if (!drawCan(viewId.draw)) { exit; };

eAnimDrawStart();

// Draw the object in the place
eAnimObjectDrawOrder(mainAnimationOb, x, y);

eAnimDrawEnd();