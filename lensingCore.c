#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/* Basic Structure */
typedef struct {
    char lensName[64];
    double massSolar;
    double thetaE;
    int totalPixels;
} LensSystem;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    /* Parse string input */
    char *inputStr = mxArrayToString(prhs[0]);

    LensSystem systemData;
    strcpy(systemData.lensName, inputStr);
    mxFree(inputStr);

    /* Read scalar and array inputs */
    systemData.massSolar = mxGetScalar(prhs[1]);
    systemData.totalPixels = (int)mxGetNumberOfElements(prhs[2]);
    systemData.thetaE = sqrt(systemData.massSolar / 1e11) * 1.5;

    double *xIn = mxGetPr(prhs[2]);
    double *yIn = mxGetPr(prhs[3]);

    /* Dynamic memory allocation using calloc */
    double *betaXTemp = (double *)calloc(systemData.totalPixels, sizeof(double));
    double *betaYTemp = (double *)calloc(systemData.totalPixels, sizeof(double));

    /* Simple loop for light deflection calculations */
    double thetaESq = systemData.thetaE * systemData.thetaE;

    for (int i = 0; i < systemData.totalPixels; i++) {
        double xVal = xIn[i];
        double yVal = yIn[i];
        double rSq = xVal * xVal + yVal * yVal;

        if (rSq < 1e-8) {
            rSq = 1e-8; /* Avoid division by zero */
        }

        betaXTemp[i] = xVal - (thetaESq * xVal) / rSq;
        betaYTemp[i] = yVal - (thetaESq * yVal) / rSq;
    }

    /* Create MATLAB output matrices */
    plhs[0] = mxCreateDoubleMatrix(
        mxGetM(prhs[2]),
        mxGetN(prhs[2]),
        mxREAL
    );

    plhs[1] = mxCreateDoubleMatrix(
        mxGetM(prhs[2]),
        mxGetN(prhs[2]),
        mxREAL
    );

    double *betaXOut = mxGetPr(plhs[0]);
    double *betaYOut = mxGetPr(plhs[1]);

    /* Copy calculated values to output */
    for (int i = 0; i < systemData.totalPixels; i++) {
        betaXOut[i] = betaXTemp[i];
        betaYOut[i] = betaYTemp[i];
    }

    /* Create report log string */
    char reportBuffer[256];

    sprintf(
        reportBuffer,
        "[C Log] Object: %s | Mass: %.2e | ThetaE: %.3f | Pixels: %d",
        systemData.lensName,
        systemData.massSolar,
        systemData.thetaE,
        systemData.totalPixels
    );

    plhs[2] = mxCreateString(reportBuffer);

    /* Clean up allocated dynamic memory */
    free(betaXTemp);
    free(betaYTemp);
}