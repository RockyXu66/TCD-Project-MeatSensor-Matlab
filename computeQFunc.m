function [f10RGB,f10,t5,t5_50,t5_75] = computeQFunc(img, method, hsv_chan)
% Modified version of boundboxfunc.m
% INPUT :
% * im : sensor picture
% * chan,chan2 : dimensions used to process then dimensions extracted
% * neigh : size of the median filter neighbourhood
% * disksize : size of the structural element
% * ExtendCoor : size of the area extracted
% * method : 'HSB','Lab','XYZ' converts to the colorspace

% OUTPUT :
% * orr : reconstructed image
% * f10 : cropped colorspace converted image
% * t5 : average dimension value in the cropped image (standard output)

format short g

%% Calculating the Hue of the image
if (strcmp(method,'HSB'))
    
    out=rgb2hsv(img);
    % Taking out the Hue component
    OUT=out(:,:,hsv_chan);% Finding out the coordinates of the centroid
    f10RGB = img;
%     f10RGB=imcrop(im,rect);
    % f10=imcrop(OUT,rect);
    f10 = OUT;
    
    % Finding out the max value of the Hue inside the rectangular strip
    % t=max(OUT(:));
    t = 1;
    
    if (hsv_chan == 1)
        % Shifting of the Hue
        for k=1:length(f10)
            for j=1:length(f10)
                Q(k,j)=f10(k,j)+(t/2);
                if Q(k,j)>t
                    Q(k,j)=Q(k,j)-t;
                end
            end
        end
        % Taking out the mean after Hue shift and this is used as the Q value
        t5=mean(Q(:));
    end
    
    % t5=mean(Q(:)); 
    t5_50=prctile(Q(:),50);
    t5_75=prctile(Q(:),75);
    return
    
% elseif (strcmp(method,'Lab'))
%     
%     out=rgb2lab(orr);
%     % Taking out the Hue component
%     OUT=out(:,:,chan2);% Finding out the coordinates of the centroid
%     
%     [rect] = cropfunction(centroids(:,1),centroids(:,2),ExtendCoor);
%     
%     ORR=orr(:,:,chan);
%     f10RGB=imcrop(im,rect);
%     % f10=imcrop(OUT,rect);
%     f10 = OUT;
%     
%     t5=mean(f10(:));
%     t5_50=prctile(f10(:),50);
%     t5_75=prctile(f10(:),75);
%     return
%     
% elseif (strcmp(method,'LCh'))
%     
%     out=rgb2LCh(orr); % custom function for LCh conversion
%     % Taking out the Hue component
%     OUT=out(:,:,chan2);% Finding out the coordinates of the centroid
%     
%     [rect] = cropfunction(centroids(:,1),centroids(:,2),ExtendCoor);
%     
%     ORR=orr(:,:,chan);
%     f10RGB=imcrop(im,rect);
%     % f10=imcrop(OUT,rect);
%     f10 = OUT;
%     
%     t5=mean(f10(:));
%     t5_50=prctile(f10(:),50);
%     t5_75=prctile(f10(:),75);
%     return
%     
% elseif (strcmp(method,'XYZ'))
%     
%     out=rgb2xyz(orr);
%     % Taking out the Hue component
%     OUT=out(:,:,chan2);% Finding out the coordinates of the centroid
%     
%     [rect] = cropfunction(centroids(:,1),centroids(:,2),ExtendCoor);
%     
%     ORR=orr(:,:,chan);
%     f10RGB=imcrop(im,rect);
%     % f10=imcrop(OUT,rect);
%     f10 = OUT;
%     
%     t5=mean(f10(:));
%     t5_50=prctile(f10(:),50);
%     t5_75=prctile(f10(:),75);
%     return
    
end

end