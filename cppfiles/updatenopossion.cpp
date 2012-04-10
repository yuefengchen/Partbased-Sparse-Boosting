/* ==========================================================================
 * update.cpp
 * example for illustrating how to manipulate structure and cell array
 *
 * takes a (MxN) structure matrix and returns a new structure (1x1)
 * containing corresponding fields: for string input, it will be (MxN)
 * cell array; and for numeric (noncomplex, scalar) input, it will be (MxN)
 * vector of numbers with the same classID as input, such as int, double
 * etc..
 *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2006 The MathWorks, Inc.
 *==========================================================================*/
/* $Revision: 1.6.6.2 $ */

#include "stdafx.h"
#include "cppmatrix.h"
#include "update_nopossion.h"
#define MAX_NUMBER_PARAMETER 100
void readHaarfeature(
                     matrix2d  haarfeature, 
                     const mxArray * haar_ptr, 
                     int NStructElems, 
                     int nfields 
                     )
{
     
    for(int ifield = 0; ifield < nfields; ifield ++) {
       for(int jstruct = 0; jstruct < NStructElems; jstruct ++) {
            // get the haarfeature(jstruct).field(ifield)
            haarfeature[jstruct][ifield] = matrix<double>(mxGetFieldByNumber(haar_ptr, jstruct, ifield));
            //haarfeature[jstruct][ifield] = tmp;
        }
    }
}
void readParameter(
                     double * parameter,
                     const mxArray * parameter_ptr
                     )
{
    mxArray * tmp;
    int nfields = mxGetNumberOfFields(parameter_ptr);
    for(int ifield = 0, ip = 0; ifield < nfields; ifield ++) {
            // get the haarfeature(jstruct).field(ifield)
        tmp = mxGetFieldByNumber(parameter_ptr, 0, ifield);

        //haarfeature[jstruct][ifield] = tmp;
        if(mxIsDouble(tmp) && mxGetM(tmp) == 1 && mxGetN(tmp) == 1){
            parameter[ip++] = mxGetPr(tmp)[0];
        }
    }
 }
//
        
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
    
    const mxArray * haar_ptr;
    const mxArray * parameter_ptr;
    const mxArray * selector_ptr;
    const mxArray * alpha_ptr;
    
    
    int nfields, NStructElems, ifield, jstruct;
    matrix2d  haarfeature;
    mxArray * tmp;
    
    if(nrhs != 4) {
        mexErrMsgTxt("tow input argument required.");
    }
    // read the prhs[0]  sumimagedata
    // read the prhs[1]  the patches [x , y, w , h]
    // 
    matrix<double> sumimagedata = matrix<double>(A_IN);
    matrix<double> patches      = matrix<double>(B_IN);
    matrix<double> label        = matrix<double>(C_IN);
    matrix<double> importance   = matrix<double>(D_IN);
    // global values
    haar_ptr      = mexGetVariablePtr("caller", "haarfeature");
    selector_ptr  = mexGetVariablePtr("caller", "selectors");
    alpha_ptr     = mexGetVariablePtr("caller", "alpha");
    parameter_ptr = mexGetVariablePtr("caller", "parameter");
            
    matrix<double> selector = matrix<double>(selector_ptr);
    matrix<double> alpha = matrix<double>(alpha_ptr);
    
    // read haar_ptr
    nfields = mxGetNumberOfFields(haar_ptr);
    NStructElems = mxGetNumberOfElements(haar_ptr);
    haarfeature = new matrix<double> * [NStructElems];
    for(jstruct  = 0; jstruct < NStructElems; jstruct ++)
        haarfeature[jstruct] = new matrix<double>[nfields];
    
    // haarfeature is the mxArray point the struct
    // haarfeature[jstruct][ifield] means the i(th) field in j(th) struct
    
    readHaarfeature(haarfeature, haar_ptr, NStructElems, nfields);

    double * parameter = new double[MAX_NUMBER_PARAMETER];
    readParameter(parameter, parameter_ptr);
    
    int labelvalue = (int)label.data[0];
    double importancevalue = importance.data[0];
   
    update(&patches, &alpha, &selector, &haarfeature,&sumimagedata, 
            parameter, labelvalue, importancevalue);
    
     
    
    for(jstruct  = 0; jstruct < NStructElems; jstruct ++)
        delete [] haarfeature[jstruct];
    delete [] haarfeature;
    delete [] parameter;
    
}