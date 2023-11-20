clear risingEdgeColPos risingEdgeRowPos fallingEdgeColPos fallingEdgeRowPos i j

load("learned.mat")

oracion = '';

image = imread("masqueamor.bmp");
% image = imread("patrones.bmp");
grayImage = rgb2gray(image);
invertedImage = double(grayImage < 127);

% Get rows
XSum = sum(invertedImage, 2);
counter1 = 1;
counter2 = 1;

for row = 2:length(XSum)-1
    if XSum(row) == 0 && XSum(row+1) > 0
        risingEdgeRowPos(counter1) = row;
        counter1 = counter1 + 1;
    end
    if XSum(row-1) > 0 && XSum(row) == 0
        fallingEdgeRowPos(counter2) = row;
        counter2 = counter2 + 1;
    end
end

% Show every row
for i = 1:length(risingEdgeRowPos)

    row = invertedImage(risingEdgeRowPos(i):fallingEdgeRowPos(i), :);
    YSum = sum(row,1);
    counter3 = 1;
    counter4 = 1;

    for col = 2:length(YSum)-1
        if YSum(col) == 0 && YSum(col+1) > 0
            risingEdgeColPos(counter3) = col;
            counter3 = counter3 + 1;
        end
        if YSum(col-1) > 0 && YSum(col) == 0
            fallingEdgeColPos(counter4) = col;
            counter4 = counter4 + 1;
        end
    end

    n=(i-1)*26 + 1;
    oracion = '';
    
    for j = 1:length(risingEdgeColPos)
        space = zeros(30);
        word = row(:,risingEdgeColPos(j):fallingEdgeColPos(j));

        [rows, cols] = size(word);
        space(1:rows,1:cols) = word;
        character = space;
        singleArrWord = reshape(character, 30*30,1);
        normalizeArrWord = singleArrWord/norm(singleArrWord);
        n = n+1;
        A = compet(W'*normalizeArrWord);
        [h,z]=max(A);
        % z
        % Alfabeto(z)
        oracion = strcat(oracion, Alfabeto(z));
        if j < length(risingEdgeColPos)
            diff(j) = risingEdgeColPos(j+1) - fallingEdgeColPos(j);
            if diff(j) > 7
                oracion = strcat(oracion, '_');
            end
        end
    end
    parrafo(i) = {oracion};
    clear risingEdgeColPos fallingEdgeColPos
    % imshow(uint8(255*row))
    % drawnow
end
% parrafo'
msgbox(parrafo)