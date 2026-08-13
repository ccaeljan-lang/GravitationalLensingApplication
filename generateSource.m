function sourceImage = generateSource(xGrid, yGrid, sourceType, ...
    xSource, ySource, rSource, customImg)

    if strcmp(sourceType, 'Gaussian Profile')
        % Generate Gaussian light profile
        sourceImage = exp( ...
            -(((xGrid - xSource).^2 + ...
            (yGrid - ySource).^2) / ...
            (2 * rSource^2)));
    else
        if isempty(customImg)
            % Generate fallback Gaussian profile
            sourceImage = exp( ...
                -(((xGrid - xSource).^2 + ...
                (yGrid - ySource).^2) / ...
                (2 * rSource^2)));
        else
            % Convert uploaded image to grayscale
            if size(customImg, 3) == 3
                imgGray = rgb2gray(customImg);
            else
                imgGray = customImg;
            end

            % Convert image to double values from 0 to 1
            imgGray = double(imgGray) / 255.0;

            % Get original image dimensions
            [imageRows, imageCols] = size(imgGray);

            % Preserve the original image aspect ratio
            imageAspect = imageCols / imageRows;

            if imageAspect >= 1
                imageX = linspace(-imageAspect, imageAspect, imageCols);
                imageY = linspace(-1, 1, imageRows);
            else
                imageX = linspace(-1, 1, imageCols);
                imageY = linspace(-1/imageAspect, ...
                                  1/imageAspect, imageRows);
            end

            [imageXGrid, imageYGrid] = meshgrid(imageX, imageY);

            % Calculate source position and size
            queryX = (xGrid - xSource) / rSource;
            queryY = (yGrid - ySource) / rSource;

            % Map the original image onto the simulation grid
            sourceImage = interp2( ...
                imageXGrid, ...
                imageYGrid, ...
                imgGray, ...
                queryX, ...
                queryY, ...
                'linear', ...
                0);
        end
    end
end