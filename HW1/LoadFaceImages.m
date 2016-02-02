function [ambimage,imarray,lightdirs] = LoadFaceImages(pathname, subject_name, num_images)
% [ambimage,imarray,lightdirs] = LoadFaceImages(pathname)
% Load the set of face images.
% The routine returns
% 		ambimage: image illuminated under the ambient lighting
%		imarray: a 3-D array of images, h x w x Nimages
% 		lightdirs: Nimages x 3 array of light source directions
%
% Source: Marc Pollefeys, 2006

% get ambient image
filename = [pathname subject_name '_P00_Ambient.pgm'];
ambimage = getpgmraw(filename);
[h, w] = size(ambimage);

% get list of all other image files
d = dir([pathname subject_name '_P00A*.pgm']);

% randomly select num_images number of images
filenames = {d(:).name};
total_images = numel(filenames);

if num_images <= total_images
    filenames = {d(randperm(numel(d), num_images)).name};
else
    fprintf('Total available images is less than specified.\nProceeding with %d images.\n', total_images)
end

Nimages = numel(filenames);

% arrays to store the angles of light sources
Ang = zeros(2, Nimages);

% create array of illuminated images
imarray = zeros(h, w, Nimages);

% image j will store its angle(A, E)
for j = 1 : Nimages
    m = findstr(filenames{j},'A')+1;
    Ang(1,j) = str2num(filenames{j}(m:(m+3)));
    m = findstr(filenames{j},'E')+1;
    Ang(2,j) = str2num(filenames{j}(m:(m+2)));
    imarray(:,:,j) = getpgmraw([pathname filenames{j}]);
end

[X,Y,Z]= sph2cart(pi*Ang(1,:)/180,pi*Ang(2,:)/180,1);
lightdirs = [Y;Z;X];
%lightdirs = [X;Y;Z];
lightdirs = lightdirs';
end
