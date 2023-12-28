clc
clear all
close all

PHOTOS_QUANTITY = 15;
LEARNING_EPOCHS = 200;
PEOPLE = 3;
PHOTO_SIZE=230400;

% Getting the first webcam object
cam = webcam();
% Settings
cam.Resolution = '640x360';


norms = zeros(1, PHOTOS_QUANTITY * PEOPLE);
patterns = zeros(PHOTO_SIZE, PHOTOS_QUANTITY * PEOPLE); % 1 Because It'll be the learning on 1 face

questdlg("Welcome, let's start with the first person", 'Waiting for your response', 'continue', 'continue')
for people_index = 1:PEOPLE
    % Getting photos and convert them to arrays
    % Save each image_array, 
    for i = 1:PHOTOS_QUANTITY
        questdlg("take photo", 'Waiting for your response', 'continue', 'continue')
        image = snapshot(cam);
        imgray = rgb2gray(image);
        imarr = double(reshape(imgray, [1, PHOTO_SIZE]));
        index = PHOTOS_QUANTITY*(people_index-1) + i;
        patterns(:,index) = imarr;
        norms(index) = norm(patterns(:,index));
        patterns(:,index) = patterns(:,index)/norms(index);

        fprintf(strcat("Photo ", num2str(index), " saved!\n"))
        % imshow(imgray)
        % drawnow
    end
    if people_index < PEOPLE
        questdlg(strcat("Please, take the person number ", num2str(people_index+1)), 'Waiting for your response', 'continue', 'continue')
    end
end

% clc
fprintf("Starting Learning process...\n");

W = zeros(PHOTO_SIZE, PEOPLE);

for epoch = 1:LEARNING_EPOCHS
    for people_index = 1:PEOPLE
        for i = 1:PHOTOS_QUANTITY
            index = PHOTOS_QUANTITY*(people_index-1) + i;
            if i == 1
                W(:, people_index) = patterns(:,index);
            else
                W(:, people_index) = W(:, people_index) + 0.1 * patterns(:,index);
                W(:, people_index) = W(:, people_index) / norm(W(:, people_index));
            end
        end
    end
end

fprintf("\nLearning Finished");

for k = 1:PEOPLE
    leanedImage = uint8(reshape(norms(:,k)*W(:,k), size(imgray)));
    subplot(1,3,k)
    imshow(leanedImage)
end


save('clase.mat',"W")
