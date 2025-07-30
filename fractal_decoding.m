% FRACTAL_DECODING - A function to perform the Fractal De-Coding
% ---------------------------------------------------------------------
% Programmed by     :       D. V. Shobhana Priscilla
% Guided by         :       Dr. P. Vanaja Ranjan
% Initial version   :       Oct 27, 2024
% ---------------------------------------------------------------------
function [ range_array ] = fractal_decoding(mean_array, fractal_array,range_size,domain_array);
%[ domain_array ] = domain_pool(mean_array);
[ fractal_array_size, fractal_array_size ] = size(fractal_array);
[ size_mean, size_mean ] = size(mean_array);
%mean_vector = reshape(mean_array',1,size_mean*size_mean);
i = 1;
mean_index_x = 1;
mean_index_y = 1;

range_array = [];
range_block = [];
while i <= fractal_array_size
    mean_local=mean_array(mean_index_x,mean_index_y);
    if fractal_array(i) == 0
        i = i + 1;
        range_block_pre = mean_local * ones(range_size);
%        disp('Coded by mean');
    else
        domain_index_x = fractal_array(i+1);
        domain_index_y = fractal_array(i+2);
        alpha_index = fractal_array(i+3);
        isometries_index = fractal_array(i+4);
        i = i + 5;
        domain_block_local=domain_array((domain_index_x * range_size + 1):(domain_index_x * range_size + range_size ),(domain_index_y * range_size + 1):( domain_index_y * range_size + range_size ));
        domain_block_local_mean = mean(domain_block_local(:));
        range_block_local = ( alpha_index / 4 ) * ( domain_block_local - domain_block_local_mean ) + mean_local;
        range_block_pre = isometries(range_block_local,isometries_index);
%       disp('Coded by AT');
    end
%    range_block_pre
%    image_input(mean_index_x:mean_index_x+range_size-1,mean_index_y:mean_index_y+range_size-1);
    %choice=input('Do you wish to continue ? [y/n] : ');
    range_block = [ range_block range_block_pre ];
    mean_index_y = mean_index_y + 1;
    if mean_index_y > size_mean
        range_array = [ range_array ; range_block ];
        range_block = [];
        mean_index_y = 1;
        mean_index_x = mean_index_x + 1;
    end    
end

%imshow(uint8(range_array))