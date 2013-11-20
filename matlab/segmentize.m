function segmentize(A)
imshow(A);
A = double(A);
Normalized = A./255;
fid=fopen('colors.txt');
M = fscanf(fid,'%x %x %x',[3 inf]);
fclose(fid);
MNormed = M./255;
%%Nå er hver kolonne ovenfor R|G|B Må se på findcolors.m for å finne ut
%%åssen jeg kan fortsette å bruke disse. 
epsilon = 0.16;
se = strel('disk',9);
fileID = fopen('data.txt','w');
fprintf(fileID,'%6s %6s %6s\r\n','coords:','x','y');
for i=1:size(MNormed,2)
    lower_R = MNormed(1,i)-epsilon;
    upper_R = MNormed(1,i)+epsilon;
    lower_G = MNormed(2,i)-epsilon;
    upper_G = MNormed(2,i)+epsilon;
    lower_B = MNormed(3,i)-epsilon;
    upper_B = MNormed(3,i)+epsilon;
    clear colors
    colors = double((Normalized(:,:,1)>lower_R) & (Normalized(:,:,1)<upper_R)...
                        & (Normalized(:,:,2)>lower_G) & (Normalized(:,:,2)<upper_G) ...
                        & (Normalized(:,:,3)>lower_B) & (Normalized(:,:,3)<upper_B));
    colors = imfill(colors);
    colors = imerode(colors,se);
    CCcolors = bwconncomp(colors);
    centers = regionprops(CCcolors,'Centroid');
    centroids = cat(1,centers.Centroid);
    if(length(centroids) == 0)
        continue
    end
    if(i == size(M,2))
        continue
    end
    hold on
    plot(centroids(:,1),centroids(:,2),'b*');
    hold off
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

