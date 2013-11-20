function segmentImp(A)
close all
imshow(A);
cform=makecform('srgb2lab');
lab_A = applycform(A,cform);

A = double(A);
Normalized = A./255;
fid=fopen('colors.txt');
M = fscanf(fid,'%x %x %x',[3 inf])
fclose(fid);

se = strel('disk',2);

%Find colors
Mpic = uint8(zeros(length(M),1,3));
Mpic(:,1,:) = uint8(M')

lab_M = applycform(Mpic,cform);
color_labels = 0:length(M)-1

a = double(lab_A(:,:,2));
b = double(lab_A(:,:,3));
colorsx = double(lab_M(:,:,2))
colorsy = double(lab_M(:,:,3))
distance = zeros(size(a,1),size(a,2),length(M));
for count = 1:length(M)
    distance(:,:,count) = ((a-colorsx(count)).^2 + (b-colorsy(count)).^.2).^0.5;
end
[value,label]=min(distance,[],3);
label = color_labels(label);

rgb_label = repmat(label,[1 1 3]);
segmented_images = repmat(uint8(0),[size(A), length(M)]);

for count = 1:length(M)
  color = A;
  color(rgb_label ~= color_labels(count)) = 0;
  segmented_images(:,:,:,count) = color;
end

fileID = fopen('data.txt','w');
fprintf(fileID,'%6s %6s %6s\r\n','coords:','x','y');
for i=1:size(M,2)
    clear colors
    colors = segmented_images(:,:,:,i);
    grey = rgb2gray(colors);
    %Contrast enhance
    grey = imadjust(grey);
    %Mask this med noe
    %h = fspecial('disk',1);
    %grey = imfilter(grey,h,'replicate');
    grey = filter2(fspecial('average',3),grey);
    %grey = medfilt2(grey,[3 3]);
    figure();
    grey = imfill(grey);
    %Imerode
    grey = imerode(grey,se);
    imshow(grey);
    %Må gjøre om til binary image først
    binaryIm = im2bw(grey,0.9);
   % imshow(binaryIm);
    CCim = bwconncomp(binaryIm);
    centers = regionprops(CCim,'Centroid');
    centroids = cat(1,centers.Centroid);
    if(length(centroids) == 0)
        continue
    end
    hold on
    plot(centroids(:,1),centroids(:,2),'b*');
    hold off
    if(i == size(M,2))
        continue
    end
    clear centroidsNormalized
    centroidsNormalized(:,1) = centroids(:,1)./length(A);
    centroidsNormalized(:,2) = centroids(:,2)./length(A); 
    
    if(size(A,2) == length(A))
        centroidsNormalized(:,2) = centroidsNormalized(:,2)+(1-size(A,1)/length(A))/2;
    else
        centroidsNormalized(:,1) = centroidsNormalized(:,1) + (1-size(A,2)/length(A))/2;
    end
    
    fprintf(fileID,'%6s %6s %1i \r\n','Cluster','size',length(centroidsNormalized));
    fprintf(fileID,'%0.5f %0.5f\r\n',centroidsNormalized');
    
end

fclose(fileID);

end

