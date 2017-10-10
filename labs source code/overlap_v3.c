#include "mex.h"
#include "math.h"
// SYS800 - Reconnaissance de formes et inspection
// M'Hand Kedjar - December 2016
void overlap(double *output, double *database, double *labels, int nb_samples,
int nb_features)
{
int i, j, k, index_min, nb_err;
double tmp, dist, dist_min;
nb_err = 0;
index_min = 0;
for (i=0; i<nb_samples; i++)
{
dist_min = 10000000;
for (j=0; j<nb_samples; j++)
{
if (j != i)
{
dist = 0;
for (k=0; k<nb_features; k++)
{
tmp = database[i*nb_features+k]-database[j*nb_features+k];
dist += tmp*tmp;
}
if (dist < dist_min)
{
dist_min = dist;
index_min = j;
}
}
}
if (labels[index_min] != labels[i])
{
nb_err++;
}
}
output[0] = (double)nb_err/(double)nb_samples;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
double *output, *database, *labels;
int nb_samples, nb_features;
database = mxGetPr(prhs[0]);
labels = mxGetPr(prhs[1]);
nb_samples = mxGetN(prhs[0]);
nb_features = mxGetM(prhs[0]);
plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
output = mxGetPr(plhs[0]);
overlap(output, database, labels, nb_samples, nb_features);
}