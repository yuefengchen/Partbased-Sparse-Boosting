#ifndef UPDATE_MATLAB_HEADER
#define UPDATE_MATLAB_HEADER
/* ==========================================================================
 * classifier.h
 * parameter0  pathces
 * parameter1  alpha
 * parameter2  selectors
 * parameter3  haarfeature
 * parameter4  sumimagedata
 * 
 * 
 * 
 * 
 * This is a MEX-file for MATLAB.
 * 
 *==========================================================================*/
/* $Revision: 1.6.6.2 $ */
#include "stdafx.h"
#include "cppmatrix.h"
#include "stdlib.h"
#include "math.h"
#define _DEBUG_
void getweakclassifiervalue(
                            double         *sumimagedata,          
                            matrix2d       *haarfeaturePtr,
                            double        **weightsumArray,
                            int             x_offset,
                            int             y_offset,
                            int             numofselectors,
                            int             featureNumInEachSelector,
                            int             sumimgheight,
                            int             sumimgwidth
                            )
{
    double weightsum;
    int areanum;
    int x0, y0, x1, y1, width, height;
    int topleft, topright, botleft, botright; // the for corn of the region
    int locationIndex;
    int locationM;
    int tmp = 0;
    for(int iselector = 0; iselector < numofselectors; ++ iselector){
        locationM = (*haarfeaturePtr)[iselector][LOCATION].M;
        for( int jweak = 0; jweak < featureNumInEachSelector; ++jweak) {
            weightsum = 0;
            areanum = (int)(*haarfeaturePtr)[iselector][AREA].data[jweak];
            // minus 1 important
            locationIndex = (int)(*haarfeaturePtr)[iselector][INDEX].data[jweak] - 1;
            for(int karea = 0; karea < areanum; ++ karea ) {
                tmp = 0;
                x0 = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];
                tmp += locationM;
                y0 = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];
                tmp += locationM;
                width = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];
                tmp += locationM;
                height = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];
                
                
                x1 = x0 + width;
                y1 = y0 + height;
                x0 += x_offset;
                x1 += x_offset;
                y0 += y_offset;
                y1 += y_offset;
                topleft   = (x0 * sumimgheight + y0);
                botright  = (x1 * sumimgheight + y1);
                topright =  (x1 * sumimgheight + y0);
                botleft   = (x0 * sumimgheight + y1);
              
                weightsum += (*haarfeaturePtr)[iselector][WEIGHT].data[locationIndex + karea] * \
                        ( sumimagedata[topleft] + sumimagedata[botright] - \
                        sumimagedata[topright] - sumimagedata[botleft]);
            }//end of karea
            weightsumArray[iselector][jweak] = weightsum;
        }// end of jweak
    }// end of iseelctor
}
void updatebysample(
                    double        * weightArray,
                    double        * gaussian_mean,
                    int           featureNumInEachSelector,
                    int           step  // gaussiditribution length
                    )
{
     double * gaussian_sigma;
     double * gaussian_P_mean;
     double * gaussian_R_mean;
     double * gaussian_P_sigma;
     double * gaussian_R_sigma;
    
     
     gaussian_sigma  = gaussian_mean + step;
     gaussian_P_mean = gaussian_sigma + step;
     gaussian_R_mean = gaussian_P_mean + step;
     gaussian_P_sigma = gaussian_R_mean + step;
     gaussian_R_sigma = gaussian_P_sigma + step;
     double K;
     
     for(int iweak = 0; iweak < featureNumInEachSelector; ++iweak) {
        // update the gaussian_mean and update the gaussian_P_mean
         
        /*
        #ifdef _DEBUG_
            mexPrintf("gaussian_mean = %lf weightvalue = %lf gaussian_P_mean = %lf gaussian_R_mean = %lf weightvalue = %lf new_mean = %lf\n", \
                gaussian_mean[iweak], weightArray[iweak],gaussian_P_mean[iweak],gaussian_R_mean[iweak] );
        #endif
         */
        
        K = gaussian_P_mean[iweak] / (gaussian_P_mean[iweak] + gaussian_R_mean[iweak]);
        K = (K < 0.001) ? 0.001:K;
        gaussian_mean[iweak] = K *  weightArray[iweak]  + (1 - K) * gaussian_mean[iweak];
        gaussian_P_mean[iweak] = (gaussian_P_mean[iweak] * gaussian_R_mean[iweak]) /  \
                                 (gaussian_P_mean[iweak] + gaussian_R_mean[iweak]);
        
        
        // update the gaussian_sigma and update the gaussian_P_sigma
        K = gaussian_P_sigma[iweak] / (gaussian_P_sigma[iweak] + gaussian_R_sigma[iweak]);
        K = (K < 0.001) ? 0.001:K;
        gaussian_sigma[iweak] = sqrt( K * (weightArray[iweak] - gaussian_mean[iweak]) * (weightArray[iweak] - gaussian_mean[iweak]) + \
                (1 - K) * gaussian_sigma[iweak] * gaussian_sigma[iweak]);
        if(gaussian_sigma[iweak] < 1) gaussian_sigma[iweak] = 1;
        gaussian_P_sigma[iweak] = (gaussian_P_sigma[iweak] * gaussian_R_sigma[iweak]) / \
                                  (gaussian_P_sigma[iweak] + gaussian_R_sigma[iweak]);
       
     }
}
void updatewrongandcorrect(
                        double        * weightArray,
                        double        * pos_mean,
                        double        * neg_mean,
                        double        * correct,
                        double        * wrong,
                        double        * error,
                        int           * labelsample,
                        int           label,
                        float         importance,
                        int           featureNumInEachSelector
                        )
{
    double mean;
    for(int iweak = 0; iweak < featureNumInEachSelector; ++iweak) {
        mean =( pos_mean[iweak] + neg_mean[iweak] ) / 2;
        if( (weightArray[iweak] <= mean && pos_mean[iweak] <= neg_mean[iweak]) || \
            (weightArray[iweak] >= mean && pos_mean[iweak] >= neg_mean[iweak]) ) {
            labelsample[iweak] = 1;
        }else {
            labelsample[iweak] = -1;
        }
        if(labelsample[iweak] == label)
            correct[iweak] += importance;
        else wrong[iweak] += importance;
    }// end for
    for(int iweak = 0; iweak < featureNumInEachSelector; ++iweak) {
        error[iweak] = float(wrong[iweak])/(correct[iweak] + wrong[iweak]);
    }
}
void update(
                matrix<double> *patchPtr,
                matrix<double> *alphaPtr,
                matrix<double> *selectorPtr,
                matrix2d       *haarfeaturePtr,
                matrix<double> *sumimagedataPtr,
                double         *parameter,
                int            label,
                double         importance
                )
{
    matrix2d haarfeature = *haarfeaturePtr;
    
    double * selector = (*selectorPtr).data;
    double * alpha = (*alphaPtr).data;
    double * sumimagedata = (*sumimagedataPtr).data;
    int    numofselectors;                     // selectors' number
    int    sumimgwidth, sumimgheight;       // sumimage width and height
  
    double mean;
    int    featureNumInEachSelector;
   // featureNumInEachSelector = haarfeature[0][AREA].M;
    sumimgwidth = (*sumimagedataPtr).N;
    sumimgheight = (*sumimagedataPtr).M;
    
  
    int x_offset = (int)(*patchPtr).data[0] - 1;
    int y_offset = (int)(*patchPtr).data[1] - 1;
    //matrix<double> confidencemap =
    featureNumInEachSelector = (int)parameter[NUMWEAKCLASSIFIER];
    numofselectors = (int)parameter[NUMSELECTORS];
    
    double ** weightArray = new double *[numofselectors];
    for(int iselect = 0; iselect < numofselectors; ++ iselect)
        weightArray[iselect] = new double[featureNumInEachSelector];
    // get weight
    getweakclassifiervalue(sumimagedata,  haarfeaturePtr,   weightArray,  \
            x_offset,y_offset,numofselectors,featureNumInEachSelector, sumimgheight, sumimgwidth);
    
    double min_error;
    int    min_index;
    double * pos_mean ;
    double * neg_mean ; 
    double * wrong;
    double * correct;
    double * error;
    int    * labelsample;
    //alloc memory
    error = new double[featureNumInEachSelector];
    labelsample = new int[featureNumInEachSelector];
    
    int step = (*haarfeaturePtr)[0][POSGAUSSIAN].M;   
    
    for(int iselect = 0; iselect < numofselectors; ++iselect) {
        // possion samples
        pos_mean = (*haarfeaturePtr)[iselect][POSGAUSSIAN].data;
        neg_mean = (*haarfeaturePtr)[iselect][NEGGAUSSIAN].data;
        correct = (*haarfeaturePtr)[iselect][CORRECT].data;
        wrong = (*haarfeaturePtr)[iselect][WRONG].data;
        
       
        int K = 0;
        for( int jsample = 0; jsample <= K; ++jsample) {
            if( label == 1 )
                updatebysample(weightArray[iselect],pos_mean,featureNumInEachSelector,step);
            else
                updatebysample(weightArray[iselect],neg_mean,featureNumInEachSelector,step);
            //end if(label ==1)
        }//end jsamples
        
        // classify this sample and update the wrong and right
        
        
        updatewrongandcorrect(weightArray[iselect], pos_mean, neg_mean, \
                correct, wrong, error, labelsample, label, importance, featureNumInEachSelector);
        
        // select the most least error weakclassifier
        min_error = error[0];
        min_index = 0;
        for( int iweak = 1; iweak < featureNumInEachSelector; ++iweak ) {
            if(error[iweak] < min_error) {
                min_error = error[iweak];
                min_index = iweak;
            }
        }
        selector[iselect] = min_index + 1;
        if( min_error >= 0.5 )
            alpha[iselect] = 0.0;
        else
            alpha[iselect] = log((1 - min_error)/min_error);
        if( labelsample[min_index] == label)
            importance *= sqrt( min_error/(1 - min_error) );
        else
            importance *= sqrt( (1 - min_error)/ min_error);
        
    }//end iselect
    
    
    for(int iselect = 0; iselect < numofselectors; ++ iselect)
       delete [] weightArray[iselect];
    delete [] weightArray;
    delete [] error;
    delete [] labelsample;
}





#endif