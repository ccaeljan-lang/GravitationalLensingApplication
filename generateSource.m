function sourceImage = generateSource(xGrid, yGrid, sourceType, ...
    xSource, ySource, rSource, customImg)

    if strcmp(sourceType, 'Gaussian Profile')

        % ---------------------------------------------------------
        % Gaussian Profile
        % ---------------------------------------------------------
        sourceImage = exp( ...
            -(((xGrid - xSource).^2 + ...
            (yGrid - ySource).^2) / ...
            (2 * rSource^2)));

    else

        if isempty(customImg)

            % -----------------------------------------------------
            % Fallback Gaussian if no image is loaded
            % -----------------------------------------------------
            sourceImage = exp( ...
                -(((xGrid - xSource).^2 + ...
                (yGrid - ySource).^2) / ...
                (2 * rSource^2)));

        else

            % -----------------------------------------------------
            % Convert uploaded image to grayscale
            % -----------------------------------------------------
            if size(customImg, 3) == 3
                imgGray = rgb2gray(customImg);
            else
                imgGray = customImg;
            end

            % Convert image to double [0,1]
            imgGray = double(imgGray) / 255.0;

            % -----------------------------------------------------
            % Keep the original image resolution
            % -----------------------------------------------------
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

            % -----------------------------------------------------
            % Position and size of the source
            % -----------------------------------------------------
            queryX = (xGrid - xSource) / rSource;
            queryY = (yGrid - ySource) / rSource;

            % -----------------------------------------------------
            % Map the complete original image onto the grid
            % -----------------------------------------------------
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