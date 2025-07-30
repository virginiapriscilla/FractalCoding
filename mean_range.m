% FRACTAL - A master script file to perform the 
% Fractal Image Compression & De-Compression
% --------------------------------------------------------
% Programmed by     :       D. V. Shobhana Priscilla
% Guided by         :       Dr. P. Vanaja Ranjan
% Created on        :       Oct 27, 2024
% --------------------------------------------------------
function [ mean_array, var_array ] = mean_range(img,size_range);
[ img_size, img_size ] = size(img);
mean_array = [];
var_array = [];

for i = 1:size_range:img_size
   for j = 1:size_range:img_size
        subimage=img(i:i+size_range-1,j:j+size_range-1);
        mean_value=mean(subimage(:));
        mean_array = [ mean_array mean_value ];
        var_value=var(subimage(:)');
        var_array = [ var_array var_value ];
    end
end
mean_array_size=img_size/size_range;
mean_array=reshape(mean_array,mean_array_size,mean_array_size)';
var_array=reshape(var_array,mean_array_size,mean_array_size)';
