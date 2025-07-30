% FRACTAL - A master script file to perform the 
% Fractal Image Compression & De-Compression
% --------------------------------------------------------
% Programmed by     :       D. V. Shobhana Priscilla
% Guided by         :       Dr. P. Vanaja Ranjan
% Created on        :       Oct 27, 2024
% --------------------------------------------------------
function fractalDisplayOutputImage(image_input,mean_array,domain_array,decoded_image,gg)
    % -----------------------------------------------------------------
    %   Displaying Input Image, Mean Image, Domain Pool, Decoded Image
    % -----------------------------------------------------------------
    figure(gg);
    
    subplot(2,2,1), subimage(uint8(image_input));
    title('Input Image');
    subplot(2,2,2), subimage(uint8(mean_array));
    title('Mean Image');
    subplot(2,2,3), subimage(uint8(domain_array));
    title('Domain Pool');
    subplot(2,2,4), subimage(uint8(decoded_image));
    title('Decoded Image');
end