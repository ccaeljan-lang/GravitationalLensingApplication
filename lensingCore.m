function [betaX, betaY, cLog] = lensingCore(lensName, massSolar, xIn, yIn)
    % Calculate Einstein angle
    thetaE = sqrt(massSolar / 1e11) * 1.5;

    % Calculate squared Einstein angle
    thetaESq = thetaE^2;

    % Calculate radial distance squared
    rSq = xIn.^2 + yIn.^2;

    % Prevent division by zero
    rSq(rSq < 1e-8) = 1e-8;

    % Calculate deflected source coordinates
    betaX = xIn - (thetaESq .* xIn) ./ rSq;
    betaY = yIn - (thetaESq .* yIn) ./ rSq;

    % Create report log
    totalPixels = numel(xIn);

    cLog = sprintf( ...
        '[MATLAB Lensing Core] Object: %s | Mass: %.2e | ThetaE: %.3f | Pixels: %d', ...
        lensName, ...
        massSolar, ...
        thetaE, ...
        totalPixels);
end