function [physicsStruct, tableData] = computePhysics(massSolar, xSource, ySource, thetaE)
    % Mass conversion
    massKg = massSolar * 1.9884e30;

    % Impact parameter
    impactU = sqrt(xSource^2 + ySource^2) / thetaE;
    if impactU < 1e-4
        impactU = 1e-4; % Prevent division by zero
    end

    % Total magnification formula
    totalMagnification = (impactU^2 + 2) / (impactU * sqrt(impactU^2 + 4));

    % Root positions and individual magnifications
    thetaPlus = 0.5 * (impactU + sqrt(impactU^2 + 4)) * thetaE;
    thetaMinus = 0.5 * (impactU - sqrt(impactU^2 + 4)) * thetaE;

    magPlus = 0.5 + (impactU^2 + 2) / (2 * impactU * sqrt(impactU^2 + 4));
    magMinus = 0.5 - (impactU^2 + 2) / (2 * impactU * sqrt(impactU^2 + 4));

    % Store physics output
    physicsStruct.massKg = massKg;
    physicsStruct.thetaE = thetaE;
    physicsStruct.impactU = impactU;
    physicsStruct.totalMagnification = totalMagnification;

    % Format simple table for UITable
    imageId = {'Image A'; 'Image B'};
    angularPosition = [thetaPlus; thetaMinus];
    magnification = [magPlus; abs(magMinus)];

    tableData = table(imageId, angularPosition, magnification);
end