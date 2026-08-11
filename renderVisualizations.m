function renderVisualizations(axis1, axis2, axis3, axis4, xGrid, yGrid, lensedImage, xSource, ySource, thetaE, tableData)
    % Chart 1: 2D Spatial Image Map
    imagesc(axis1, xGrid(1,:), yGrid(:,1)', lensedImage);
    colormap(axis1, 'hot');
    axis(axis1, 'image');
    hold(axis1, 'on');
    rectangle(axis1, 'Position', [-thetaE, -thetaE, 2*thetaE, 2*thetaE], ...
        'Curvature', [1 1], 'EdgeColor', 'w', 'LineStyle', '--');
    title(axis1, 'Lensed View');
    hold(axis1, 'off');

    % Chart 2: 2D Deflection Field
    rGrid = sqrt(xGrid.^2 + yGrid.^2);

    % Calculate gravitational deflection magnitude
    deflectionMap = thetaE^2 ./ max(rGrid, 1e-4);

    % Clear previous plot
    cla(axis2);

    % Plot deflection field
    imagesc(axis2, ...
        xGrid(1,:), ...
        yGrid(:,1), ...
        deflectionMap);

    axis(axis2, 'image');

    % Use a fixed color scale
    caxis(axis2, [0 25]);

    colormap(axis2, 'turbo');

    % Add colorbar
    colorbar(axis2);

    title(axis2, 'Gravitational Deflection Field');
    xlabel(axis2, 'X Position');
    ylabel(axis2, 'Y Position');

    % Chart 3: 1D Radial Line Plot
    midRow = floor(size(lensedImage, 1) / 2);
    xAxis = xGrid(midRow, :);
    intensityLine = lensedImage(midRow, :);
    plot(axis3, xAxis, intensityLine, 'r-', 'LineWidth', 1.5);
    grid(axis3, 'on');
    xlabel(axis3, 'Position');
    ylabel(axis3, 'Intensity');
    title(axis3, 'Brightness Line Profile');

    % Chart 4: 2D Scatter Plot
    scatter(axis4, xSource, ySource, 80, 'g', 'filled');
    hold(axis4, 'on');
    rPlus = tableData.angularPosition(1);
    rMinus = tableData.angularPosition(2);
    angleVal = atan2(ySource, xSource);
    scatter(axis4, rPlus * cos(angleVal), rPlus * sin(angleVal), 60, 'b', 'filled');
    scatter(axis4, rMinus * cos(angleVal), rMinus * sin(angleVal), 60, 'm', 'filled');
    scatter(axis4, 0, 0, 100, 'k', 'x');
    grid(axis4, 'on');
    axis(axis4, 'equal');
    title(axis4, 'Image Root Locations');
    hold(axis4, 'off');
end