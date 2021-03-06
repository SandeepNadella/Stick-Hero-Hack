% % 
% % Matlab Code Hacking Stick Hero
% % 

% % Prequisites:
% % 1.Enable developer options in your android device
% % 2.Install adb drivers for your device
% % 3.Check if ADB device interface is the driver installed for your device
% in device manager
% % 4.To check if they are properly installed connect your device and run "adb devices" command from shell or command promt from the present working directory
% % 5.Your device adb hostname must be displayed
% % 6.Close the command prompt and tap play on your device. Run this script

% % Note:1. If the device is being shown as offline disconnect and reconnect
% your device
% % 2. To stop the game touch the screen before the the system generates the
% swipe. The script exits automatically with an error as it doesn't detect the hat of Stick
% Hero in Game Over! screen

clear all%%Clear all variables
close all%%Close all open figures
clc%%clear command window

while true  
% % capturing screenshot and saving it to sdcard of the android device
    system('adb shell screencap -p /sdcard/stickscreen/screen.png');

% %  pulling image to your working directory
    system('adb pull /sdcard/stickscreen/screen.png');
 
% % reading pulled image from working directory 
im=imread('screen.png');

% % displaying the image pulled
figure(1)
imshow(im);

% % extracting R G B components of the image
R=im(:,:,1);
G=im(:,:,2);
B=im(:,:,3);

% % storing size of screenshot captured
[M N]=size(im(:,:,1));

out0=ones(size(im(:,:,1)));
out1=ones(size(im(:,:,1)));

% % extracting hat of the Stick Hero. You can select data capture tool in
% imshow window to detemine the RGB index of the colour of his hat (255,0,0)
for i=1:M
    for j=1:N
        if R(i,j)>200
            if G(i,j)<10
                if B(i,j)<10
                out0(i,j)=0;
                end
            end
        end
    end
end


% % extracting center of building. You can select data capture tool in
% imshow window to detemine the RGB index of the colour of the red mark on building (247,27,27)

for i=1:M
    for j=1:N
        if R(i,j)>200
            if G(i,j)>20&&G(i,j)<30
                if B(i,j)>20&&B(i,j)<30
                out1(i,j)=0;
                end
            end
        end
    end
end

% % displaying the extracted hat
figure(2)
imshow(uint8(out0*255));

% % displaying the extracted buiding center red mark
figure(3)
imshow(uint8(out1*255));

% %regionproperties function calculates area of regions with black as background and white as foreground. So inversing the image. 
out0=~out0;
out1=~out1;

% % Calculating the region properties of both the images required
prop0 = regionprops(out0);
prop1 = regionprops(out1);

% % storing the number of regions captured with the given color indices
[g h]=size(prop0);
[G H]=size(prop1);

% % Calculating index(Region) with maximum Area in the image containing the
% hat of the Stick Hero
% % maxo stores the value of the index
for o=1:g
    if o~=1
        if prop0(o).Area>maxA
            if prop0(o).Area<300
            maxo=o;
            maxA=prop0(o).Area;
             end;
        end;
    else
        maxo=1;
        maxA=prop0(o).Area;
    end;
end;

% % Calculating index(Region) with maximum Area in the image containing the
% center point of the building
% % maxO stores the value of the index
for O=1:G
    if O~=1
        if prop1(O).Area>maxA
            if prop1(O).Area<300
            maxO=O;
            maxA=prop1(O).Area;
            end;
        end;
    else
        maxO=1;
        maxA=prop1(O).Area;
    end;
end;

% % calculating the distance between x coordinates of centroids of hat
% region and building center region
dist=prop1(maxO).Centroid(1)-prop0(maxo).Centroid(1);

% %  Rounding the distance and giving it as duration in ms of swipe to be
% generated
% % Tweak this statement if your having problems with generated stick
% length. You can change the -50 to some other duration(say -60) to get the stick to
% fall exactly at the center of the building
fval=round(abs(dist))-50

% % generating command to be given for swiping
cmd=['adb shell input swipe 10 10 90 90 ' num2str(fval)];
system(cmd);    

% % Removing the scrrenshot saved in sdcard to save space   
system('adb shell rm /sdcard/stickscreen/screen.png');

% % Time delay for the Stick Hero to travel on the stick from one building
% to another
pause(2.2);
end;    

 