function rect = getRect(size, wRect, rectIndex, ratio)

 offsety = 20; offsetx = 20; offset_inst = 100;
 height = (wRect(4)-(size(2)+1)*offsety-offset_inst)/size(2);
 width = (wRect(3)-(size(1)+1)*offsetx)/size(1);
 
 rect = [wRect(1)+(rectIndex(1)-1)*width+(rectIndex(1))*offsetx ...
        wRect(2)+(rectIndex(2)-1)*height+(rectIndex(2))*offsety ...
        wRect(1)+rectIndex(1)*width+rectIndex(1)*offsetx ...
        wRect(2)+rectIndex(2).*height+rectIndex(2)*offsety];
    
 height_tmp = width/ratio; 
 if(height_tmp>height)
     width_tmp = height*ratio;
     clip = (width - width_tmp)/2;
     rect(1) = rect(1) + clip;
     rect(3) = rect(3) - clip;
 else
     clip = (height - height_tmp)/2;
     rect(2) = rect(2) + clip;
     rect(4) = rect(4) - clip;
 end
 