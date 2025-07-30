% FRACTAL_CODING - A function to perform the Fractal Image Compression
% ---------------------------------------------------------------------
% Programmed by     :       D. V. Shobhana Priscilla
% Guided by         :       Dr. P. Vanaja Ranjan
% Initial version   :       Oct 27, 2024
% ---------------------------------------------------------------------
function [fractal_array, Nm, Naf, fractal_vector, fractal_vector_spl ] = fractal_coding(image_input,mean_array,var_array,range_size,domain_array,domain_size);
% Get the input image and store it in an array. Store it as a float. 
% Find the size of the Image.
[ image_size, image_size ]=size(image_input);

%[ domain_array ] = domain_pool(mean_array);
%imshow(uint8(domain_array));
fractal_array = [];
range_vector = [];
domain_count = 0;
range_vector = [];
fractal_vector = [];
fractal_vector_spl = [];
domain_feature_flag = zeros(domain_size);
domain_vector = [];
Nm  = 0;
Naf = 0;
for i = 1:range_size:image_size
    for j = 1:range_size:image_size
    range_block=image_input(i:i+range_size-1,j:j+range_size-1); 
    range_mean=mean_array((i-1)/range_size + 1,(j-1)/range_size + 1);
    range_var=var_array((i-1)/range_size + 1,(j-1)/range_size + 1);
%    if range_var < 25
%        fractal_array = [  fractal_array 0 ];
%        Nm = Nm + 1;
%    else
        range_vector_local=[];
        [range_vector_local, fractal_code_range_spl_local]=FCT_code_range_block(range_block,range_mean,domain_array,domain_feature_flag);
        fractal_array = [  fractal_array 1 range_vector_local];
        [range_mean range_var range_vector_local(3) range_vector_local(4)];

        %fractal_vector = [fractal_vector range_mean range_var range_vector_local(3) range_vector_local(4)];
        fractal_vector = [fractal_vector range_vector_local];
        fractal_vector_spl = [fractal_vector_spl fractal_code_range_spl_local];

        %domain_i_index = domain_vector_local(1);
        %domain_j_index = domain_vector_local(2);
        %if (domain_feature_flag(domain_i_index,domain_j_index) == 0)
        %    %domain_vector = [domain_vector domain_vector_local(3:6)]; 
        %    domain_vector(domain_i_index,domain_j_index,1) = domain_vector_local(3);
        %    domain_vector(domain_i_index,domain_j_index,2) = domain_vector_local(4);
        %    domain_vector(domain_i_index,domain_j_index,3) = domain_vector_local(5);
        %    domain_vector(domain_i_index,domain_j_index,4) = domain_vector_local(6);
        %end
        %domain_feature_flag(domain_i_index,domain_j_index) =  domain_feature_flag(domain_i_index,domain_j_index) + 1;
        Naf = Naf + 1;
%    end
        Nr = Nm + Naf;
        %choice=input('Do you wish to continue ? [y/n] : ');
    end
    %fractal_vector
end

%[ mean_size mean_size ] = size(mean_array);
%fractal_code=reshape(fractal_array,mean_size,mean_size)';
%range_block=image_input(1:range_size,1:range_size)
%range_mean=mean_array(1,1)
%domain_feature_flag
domain_feature_vector = [];
for d_i=1:domain_size
    for d_j=1:domain_size
        if (domain_feature_flag(d_i,d_j) > 50)
            domain_feature_vector = [domain_feature_vector domain_vector(d_i,d_j,1) domain_vector(d_i,d_j,2) domain_vector(d_i,d_j,3) domain_vector(d_i,d_j,4)];
        end
    end
end



