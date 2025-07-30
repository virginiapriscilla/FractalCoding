% FRACTAL - A master script file to perform the 
% Fractal Image Compression & De-Compression
% --------------------------------------------------------
% Programmed by     :       D. V. Shobhana Priscilla
% Guided by         :       Dr. P. Vanaja Ranjan
% Created on        :       Oct 27, 2024
% --------------------------------------------------------


%range_size=input('Enter the size of the Range Block : ');

time_coding=cputime;
BASE_IMG_FOLDER='C:\\Drive(D)\\MATLAB\\Examples\\dataset';
%BASE_IMG_FOLDER='E:\\AnnaUniversity\\dataset';
%DATASET='lfpw\\emotions';
%DATASET='MMI\\test';
DATASET='CK+48';
%DATASET='MUG';
%DATASET='FER';
FOLDER_LEVEL='1';
UNIT_IMAGE_COUNT=80;
%DATASET='JAFFE\\testset';
%FOLDER_LEVEL='1';

DATASET_SUB='test\\happy';
DATASET_SUB_REF='test\\anger';

emotionsDataFile =   [BASE_IMG_FOLDER '\\' DATASET '\\fractal_' date '_' int2str(randi(100,1)) '.csv'];

range_size=8;
ref_image_input_size =256;
emotion_detect_mode='folder_based'; %{folder_based|file_based|automatic|null}
%emotion_detect_mode='file_based'; %{folder_based|file_based|automatic|null}

IMAGE_TYPE='.png'; %{.jpg|.png|.tiff}

%ref_sample_image=input('Enter the Reference Image : ');
%ref_image_input_raw=imread(ref_sample_image);
%ref_image_input=double(ref_image_input_raw);

%sample_image=input('Enter the Sample Image : ');
%image_input_raw=imread(sample_image);
%image_input=double(image_input_raw);
%% get images and ground truth shapes

if (FOLDER_LEVEL == '1')

images_list = dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB '/*' IMAGE_TYPE ]);
ref_images_list = dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB_REF '/*' IMAGE_TYPE ]);
ref_image_details=dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB_REF '/*' ref_images_list(1).name]);

else

    emotions_list=dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB '/*']);
    images_list_local = dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB '\\' emotions_list(3).name '/*' IMAGE_TYPE ]);
    if (size(images_list_local,1) < UNIT_IMAGE_COUNT)
        UNIT_IMAGE_COUNT_MAX=size(images_list_local,1);
    else
        UNIT_IMAGE_COUNT_MAX=UNIT_IMAGE_COUNT;
    end
    index_array=randperm(size(images_list_local,1),UNIT_IMAGE_COUNT_MAX);
    images_list =[images_list_local(1)];
    for img_index=index_array(2:end)
    images_list =[images_list;images_list_local(img_index)] ;
    end
    %images_list =[images_list_local(1:UNIT_IMAGE_COUNT_MAX)] ;
    %[size(images_list)]
    for em_num=4:size(emotions_list,1)
    images_list_local = dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB '\\' emotions_list(em_num).name '/*' IMAGE_TYPE ]);
    if (size(images_list_local,1) < UNIT_IMAGE_COUNT)
        UNIT_IMAGE_COUNT_MAX=size(images_list_local,1);
    else
        UNIT_IMAGE_COUNT_MAX=UNIT_IMAGE_COUNT;
    end
    for img_index=randperm(size(images_list_local,1),UNIT_IMAGE_COUNT_MAX)
    images_list =[images_list; images_list_local(img_index)] ;
    end
    %images_list =[images_list; images_list_local(1:UNIT_IMAGE_COUNT_MAX)] ; 
    %[size(images_list) size(images_list_local)]
    end
ref_image_details=dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB_REF '/*/*' ref_images_list(1).name]);
end
image_count=size(images_list);
%ref_image_input=imread([ref_image_details.folder '\\'  ref_image_details.name]);
ref_image_input=imread([ref_image_details(1).folder '\\'  ref_image_details(1).name]);

if size(ref_image_input, 3) == 3
    ref_image_input = double(rgb2gray(ref_image_input));
else
    ref_image_input = double(ref_image_input);
end



ref_image_input_size = [ref_image_input_size ref_image_input_size];
ref_image_input=imresize(ref_image_input,ref_image_input_size);
[ ref_image_size, ref_image_size ]=size(ref_image_input);
    %imshow((image_input));
    %output_file='fractal_coded.txt';
    
    % Find the mean and variance of the Range Block

    [ ref_mean_array, ref_var_array ] = mean_range(ref_image_input,range_size);
    %imshow(uint8(mean_array));
    %disp('Coding, Please wait ...');
    [ domain_array ] = domain_pool(ref_mean_array);
    [ size_domain, size_domain ] = size(domain_array);
    domain_blocks = size_domain/range_size;
    % --------------------------------------------------------
    %   Displaying Domain Pool
    % --------------------------------------------------------
    
    figure(1);
    title('Domain Pool');
    domain_count = 0;
    %[ img_size, img_size ] = size(image_input);
    for i = 1:domain_blocks
        for j = 1:domain_blocks
            domain_count = domain_count + 1;
            domain_local=domain_array((i-1) * range_size + 1 :(i-1) * range_size + range_size,(j-1) * range_size + 1 :(j-1) * range_size + range_size);
            domain_size=ref_image_size/( range_size ^ 2 );
            subplot(domain_size,domain_size,domain_count), subimage(uint8(domain_local));
        end
    end
fractal_vector = [];
domain_feature_vector = [];
fractal_vector_spl = [];

%for gg=randperm(size(images_list,1),1200)
for gg=20:20
% gg=2:size(images_list,1)
    %image_input = imread(['../../testset/' images_list(gg).name]);
    if (FOLDER_LEVEL == '1')
    input_image_details=dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB '/*' images_list(gg).name]);
    else
    input_image_details=dir([BASE_IMG_FOLDER '\\' DATASET '\\' DATASET_SUB '/*/*' images_list(gg).name]);    
    end

    image_input=imread([input_image_details.folder '\\'  input_image_details.name]);

    if size(image_input, 3) == 3
        image_input = double(rgb2gray(image_input));
    else
        image_input = double(image_input);
    end
    fprintf('Processing Image: %s !!!\n',images_list(gg).name);
    image_input=imresize(image_input,ref_image_input_size);
    [ image_size, image_size ]=size(image_input);
    [ mean_array, var_array ] = mean_range(image_input,range_size);
    %imshow(uint8(mean_array));

    
    
    % Find the mean and variance of the Range Block

    %disp('--------------------------------------------------------------------');
    %fprintf('      Performing the Fractal Coding for the Image: %s !!!\n',images_list(gg).name)
    %disp('--------------------------------------------------------------------');
    

    fractal_vector_local = [];
    [fractal_array, Nm, Naf, fractal_vector_local, fractal_vector_spl_local ]=FCT_fractal_coding(image_input,ref_mean_array,var_array,range_size,domain_array,domain_size);
    time_coding=cputime - time_coding;
    %disp('--------------------------------------------------------------------');
    %fprintf('      Performing the Fractal De-Coding for the Image: %s !!!\n',images_list(gg).name)
    %disp('--------------------------------------------------------------------');
    %disp('De-Coding, Please wait ...');
    time_decoding=cputime;
    [ decoded_image ] = fractal_decoding(mean_array, fractal_array,range_size,domain_array);
    time_decoding=cputime - time_decoding;
    
    % -----------------------------------------------------------------
    %   Displaying Input Image, Mean Image, Domain Pool, Decoded Image
    % -----------------------------------------------------------------
    %fractalDisplayOutputImage(image_input,mean_array,domain_array,decoded_image)
 
    %disp('--------------------------------------------------------------------');
    %fprintf('      Performing Fractal Analysis for the Image: %s !!!\n',images_list(gg).name)
    %disp('--------------------------------------------------------------------');
    %disp('Performing Fractal Analysis, Please wait ...');
    %[ BR, CR, PSNR ]=fractal_analysis(image_input,range_size,decoded_image,Nm,Naf);
    %fractalAnalysisDisplay(images_list(gg).name,ref_image_size,range_size,BR,CR,PSNR,time_coding,time_decoding)    
image_emotion='null';
if (emotion_detect_mode == "folder_based")
    %input_image_dir = dir(['./dataset/' dataset_name '/emotions/*/' input_image_name]);
    input_image_dir = input_image_details.folder;
    if (~isempty(input_image_dir))
    input_image_dir_parts=regexp(input_image_dir,'\','split');
    image_emotion = string(input_image_dir_parts(end));
    else
    image_emotion = "others";
    end
elseif (emotion_detect_mode == "file_based")
    tokens=split(images_list(gg).name,'.');
    emotion_id=char(strip(tokens(2)));
    if startsWith(emotion_id,'AN')
        image_emotion="angry";
    elseif startsWith(emotion_id,'DI')
        image_emotion="disgust";
    elseif startsWith(emotion_id,'FE')
        image_emotion="fear";
    elseif startsWith(emotion_id,'HA')
        image_emotion="happy";                                   
    elseif startsWith(emotion_id,'NE')
        image_emotion="neutral";    
    elseif startsWith(emotion_id,'SA')
        image_emotion="sad";
    elseif startsWith(emotion_id,'SU')
        image_emotion="surprise";  
    else
        image_emotion="unknown";
    end
    %[emotion images_list(gg).name]
else
    cmd=["python ..\..\emotionDetection.py " + input_image_details.folder + '\' +  input_image_details.name ]; 
    [null em_raw_data]=system(cmd);
    %pause(5)
    em_array=split(em_raw_data,"emotion:");
    if(size(em_array,1) == 4)
    image_emotion=string(strip(em_array(4)));
    else
    image_emotion='null';
    end
end    
    fractal_vector_local = [images_list(gg).name image_emotion fractal_vector_local];
    %if (size(fractal_vector,2) == 0 || size(fractal_vector,2) == size(fractal_vector_local,2))
    %    fractal_vector = [fractal_vector;fractal_vector_local];
    %else
    %    fprintf('---Skipping Image in Fractal Vector: %s !!!\n',images_list(gg).name);
    %end
    
    fractal_vector_spl_local = [images_list(gg).name image_emotion fractal_vector_spl_local];
    %fractal_vector_spl_local_new = [repmat([images_list(gg).name image_emotion],size(fractal_vector_spl_local,1), 1) fractal_vector_spl_local];
    if (size(fractal_vector_spl,2) == 0 || size(fractal_vector_spl,2) == size(fractal_vector_spl_local,2))
        fractal_vector_spl = [fractal_vector_spl;fractal_vector_spl_local];
    else
        fprintf('---Skipping Image in Fractal Vector: %s !!!\n',images_list(gg).name);
    end
    
    %domain_feature_vector_local = [images_list(gg).name emotions domain_feature_vector_local];
    %fractal_vector_local1(1:10)
    %if (size(fractal_vector,2) == 0 || size(fractal_vector,2) == size(fractal_vector_local,2))
    %    fractal_vector = [fractal_vector;fractal_vector_local];
    %    domain_feature_vector = [domain_feature_vector;domain_feature_vector_local zeros(1,((2 + domain_size ^ 2 * 4) - (size(domain_feature_vector_local,2)) ))];
    %else
    %    fprintf('---Skipping Image in Fractal Vector: %s !!!\n',images_list(gg).name);
    %    [size(fractal_vector,2)  size(fractal_vector_local,2)]
    %end
    %if (size(domain_feature_vector,2) == 0 || size(domain_feature_vector,2) == size(domain_feature_vector_local,2))
    %    domain_feature_vector = [domain_feature_vector;domain_feature_vector_local];
    %else
    %    fprintf('---Skipping Image in Domain Vector: %s !!!\n',images_list(gg).name);
    %    [size(domain_feature_vector,2)  size(domain_feature_vector_local,2)]
    %end    
end
%writematrix(fractal_vector,emotionsDataFile);
%writematrix(domain_feature_vector,emotionsDataFile);
%%%writematrix(fractal_vector_spl,emotionsDataFile);
%fractal_vector_spl
%print(fractal_vector_spl);
%domain_feature_vector

%disp('--------------------------------------------------------------------');
%fprintf('      Performing Fractal Analysis for the Image: %s !!!\n',images_list(gg).name)
%disp('--------------------------------------------------------------------');
%disp('Performing Fractal Analysis, Please wait ...');
%[ BR, CR, PSNR ]=fractal_analysis(image_input,range_size,decoded_image,Nm,Naf);
%fractalAnalysisDisplay(images_list(gg).name,ref_image_size,range_size,BR,CR,PSNR,time_coding,time_decoding)    

% -----------------------------------------------------------------
%   Displaying Input Image, Mean Image, Domain Pool, Decoded Image
% ----------------------------------------------------------------
fractalDisplayOutputImage(image_input,mean_array,domain_array,decoded_image,gg)
