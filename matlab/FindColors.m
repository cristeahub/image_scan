close all
A = imread('sweetsA01.png');
imshow(A);
grey=rgb2gray(A);
%A = double(A);
%Normalized = A./255;


cform=makecform('srgb2lab');
lab_A = applycform(A,cform);


fid=fopen('colors.txt');
M = fscanf(fid,'%x %x %x',[3 inf])
fclose(fid);

Mpic = uint8(zeros(length(M),1,3));
Mpic(:,1,:) = uint8(M')

lab_M = applycform(Mpic,cform);
color_labels = 0:length(M)-1

a = double(lab_A(:,:,2));
b = double(lab_A(:,:,3));
colorsx = double(lab_M(:,:,2))
colorsy = double(lab_M(:,:,3))
distance = zeros(size(a,1),size(a,2),nColors);
for count = 1:length(M)
    distance(:,:,count) = ((a-colorsx(count)).^2 + (b-colorsy(count)).^.2).^0.5;
end
[value,label]=min(distance,[],3);
label = color_labels(label);



% %Find edges
% Edges= edge(Normalized,'canny');
% figure();
% imshow(edges);

% % %Try derivative filtering:
%  figure();
%  imshow(grey);
%  [fx,fy]=gradient(double(grey));
%  magnitude=sqrt(fx.*fx+fy.*fy);
%  
%  
%  
%  
%  se = strel('disk',1);
%  %magnitude = imerode(magnitude,se);
% illustrate=uint8(magnitude); figure(); imshow(illustrate);
%  magnitude= imdilate(magnitude,se);
% 
%  illustrate=uint8(magnitude); figure(); imshow(illustrate);
%  
%  %magnitude(:,:)=magnitude<0.01;
%  %figure(); imshow(magnitude);
%  
% 
% % %Try thresholding
% % level = graythresh(A);
% % treshold = im2bw(A,level);
% % illustrate = uint8(treshold); figure(); imshow(illustrate);
% 
% %Try filter to "blur out" image
% %for i=1:10
% grey = medfilt2(grey,[3 3]);
% %end
% illustrate = uint8(med); figure(); imshow(illustrate);
% 
% %Matlab filters to try:
% h = fspecial('average');
% average = imfilter(grey,h);
% illustrate = uint8(average); figure(); imshow(illustrate);
% %h = fspecial('disk');
% %average = imfilter(grey,h);
%  %illustrate = uint8(average); figure(); imshow(illustrate);
% h = fspecial('gaussian');
% average = imfilter(average,h);
% 
% %%Try mask to find edges
% se = strel('disk',1);
% average = imdilate(average,se);
% cannyMasked = edge(average,'canny');
% se = strel('disk',5);
% %cannyMasked = imerode(cannyMasked,se);
% vannyMasked = imdilate(cannyMasked,se);
% cannyFilled = imfill(cannyMasked,'holes');
% 
% %cannyFilled = imerode(cannyFilled,se);
% 
% imshow(cannyFilled);


% %%%%Make Red Part%%%%%
% %%Take the red part of normalized
% Red = double((Normalized(:,:,1)>0.5) & (Normalized(:,:,2)<0.3) & (Normalized(:,:,3)<0.3));
% 
% 
% 
% %%Get rid of noise and unwanted red
% se = strel('disk',10);
% Red= imfill(Red);
% Red=imerode(Red,se);
% %%Find the connected components in the red picture
% CCRed = bwconncomp(Red);
% SenterRed = regionprops(CCRed,'Centroid');
% centroids = cat(1,SenterRed.Centroid);
% %%Mark the centroids of the red ones.
% hold on
% plot(centroids(:,1),centroids(:,2),'b*');
% hold off
% %%Find the number of red ones
% NumberOfRed = CCRed.NumObjects;
% centroidsNormalized = zeros(size(centroids));
% %Normalize
% centroidsNormalized(:,1) = centroids(:,1)./length(A);
% centroidsNormalized(:,2) = centroids(:,2)./length(A); 
% 
% 
% fileID = fopen('data.txt','w');
% fprintf(fileID,'%6s %6s\r\n','x','y');
% fprintf(fileID,'%6s %1i \r\n','size',length(centroidsNormalized));
% fprintf(fileID,'%0.5f %0.5f\r\n',centroidsNormalized');
% fclose(fileID);
% 
% figure();
% imshow(Red);
