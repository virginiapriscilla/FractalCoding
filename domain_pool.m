% FRACTAL - A master script file to perform the 
% Fractal Image Compression & De-Compression
% --------------------------------------------------------
% Programmed by     :       D. V. Shobhana Priscilla
% Guided by         :       Dr. P. Vanaja Ranjan
% Created on        :       Oct 27, 2024
% --------------------------------------------------------
function [ domain_array ] = domain_pool(img);
 [ img_size, img_size ] =size(img);
 img = [ img img(:,img_size) ];
 img = [ img ; img(img_size,:) ];
 domain_array = [];
 for i = 1:img_size
     for j = 1:img_size
     domain_data =  ( img(i,j) + img(i+1,j) + img(i,j+1) + img(i+1,j+1) ) / 4;
     domain_array = [ domain_array domain_data ];
     end
 end
 domain_array=reshape(domain_array,img_size,img_size)';

