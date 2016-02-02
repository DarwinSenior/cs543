function [albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs)
% imarray: h x w x Nimages array of Nimages no. of images
% light_dirs: Nimages x 3 array of light source directions
% albedo_image: h x w image
% surface_normals: h x w x 3 array of unit surface normals
    [h, w, n] = size(imarray);
    I = reshape(imarray, [h*w, n]);
    g = light_dirs\I';

    rho = sqrt(sum(g.^2, 1));
    albedo_image = reshape(rho, [h, w]);

    surface_normals = zeros(3, h*w);
    fx = g(1,:)./g(3,:);
    fy = g(2,:)./g(3,:);

    surface_normals(3,:) = 1./sqrt(fx.^2+fy.^2+1);
    surface_normals(1,:) = fx./surface_normals(3,:);
    surface_normals(2,:) = fy./surface_normals(3,:);

end

