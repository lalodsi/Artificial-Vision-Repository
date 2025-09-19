function ProcFile( strname )
Im = imread([strname '.bmp']);
Im = double(Im);
x = GetMoments(Im);
disp(round(x'));
end

