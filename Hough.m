image = imread('image.jpg');
% image = imread('out_manmade_1k/sun_aabghtsyctpcjvlc.jpg');
[h, ~, ~] = size(image);
% image = imread('out_natural_1k/sun_aachaucttrrkdicr.jpg');
bw = rgb2gray(image);

figure(5);
bw = edge(bw,'canny');
imshow(bw);

[H,theta,rho] = hough(bw, 'Theta', -20:0.5:20);
peaks  = houghpeaks(H,1000,'threshold',ceil(0.4*max(H(:))));
lines = houghlines(bw, theta, rho, peaks,'FillGap',1,'MinLength',h/20);


figure, imshow(image), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end