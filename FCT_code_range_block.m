% CODE_RANGE_BLOCK - A function which Performs the Fractal Codes
% for the Range Blocks
% ---------------------------------------------------------------------
% Programmed by     :       D. V. Shobhana Priscilla
% Guided by         :       Dr. P. Vanaja Ranjan
% Initial version   :       Oct 27, 2024
% ---------------------------------------------------------------------
function [ fractal_code_range, fractal_code_range_spl ] = code_range_block(range_block,mean_range,domain_array,domain_feature_flag);
[ size_domain size_domain ] = size(domain_array);
[ range_size range_size ] = size(range_block);
range_mse_min = 5.6013e+100;
count = 0;
    for i = 1:range_size:size_domain
        for j = 1:range_size:size_domain
            domain_local=domain_array(i:i+range_size-1,j:j+range_size-1);
            domain_local_mean=mean(domain_local(:));
            domain_local_var=var(domain_local(:));
            for k = 1:8
            alpha = k / 4;
            range_local_pre=alpha * ( domain_local - domain_local_mean ) + mean_range;
            for m = 1:8
                range_local=isometries(range_local_pre,m);
                range_local_mse=sum(sum(( range_local - range_block ) .^ 2))/ ( range_size ^ 2 );
                
                count = count + 1;
                if range_local_mse < range_mse_min
                    domain_i_index = ( i - 1 )/range_size;
                    domain_j_index = ( j - 1 )/range_size;
                    %if ( domain_feature_flag(domain_i_index+1,domain_j_index+1) == 0)
                    %    domain_feature_flag(domain_i_index+1,domain_j_index+1) = 1;
                    %    [domain_i_index+1 domain_j_index+1 domain_feature_flag(domain_i_index+1,domain_j_index+1)]

                    %fractal_code_domain = [domain_i_index+1 domain_j_index+1 domain_local_mean domain_local_var k m ];
                    %end
                    
                    coded_mean=mean(range_local(:));
                    coded_var=var(range_local(:));
                    
                    range_mse_min = range_local_mse;
                    fractal_code_range = [ domain_i_index domain_j_index k m];
                    fractal_code_range_spl = [domain_i_index domain_j_index k m coded_mean range_mse_min ];
                    %[coded_mean domain_local_mean]
                end
            end
            end
        end
    %class(range_local)
    %class(range_block)
    end
 
