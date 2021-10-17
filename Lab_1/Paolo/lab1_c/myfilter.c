#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>

#define NT 11 /// number of coeffs
#define NB 9 /// number of bits
#define N_SHIFT 0

///data out valid after that the first 10 valid sample are received
/// used also to compare the result from the vhdl and the C model
int valid_samples = 0;
const int b[NT]= {-1, -4, -7, 16, 70, 101, 70, 16, -7, -4, -1}; /// b array

/// Perform fixed point filtering assuming direct form I
///\param x is the new input sample
///\return the new output sample
int myfilter(int x, int vin, int* vout)
{
    static int sx[NT]; /// x shift register
    static int first_run = 0; /// for cleaning shift registers

    int i; /// index
    int y; /// output sample


    /// clean the buffers
    if (first_run == 0)
    {
        first_run = 1;
        for (i=0; i<NT; i++)
            sx[i] = 0;
    }

    ///check if we have already received enough samples
    ///if yes, vout = 1
    ///if vin=, then vout=0


    /// shift and insert new sample in x shift register
    for (i=NT-1; i>0; i--){
        if (vin == 1) {
            sx[i] = sx[i-1];
        }
    }
    if(vin == 1){
    valid_samples++;
    sx[0] = x >> N_SHIFT;         ///NOTE: reduce the dynamic of input to obtain lower multiplication
    }

    /// make the convolution
    /// Moving average part
    y = 0;
    for (i=0; i<NT; i++)
    {
        y += (sx[i]*b[i]) >> (NB+1) ;      ///shift the mult result to work with less bit
    }

    y = y << 2;         ///bring back the fixed point at the correct position

	//saturation

    if (y > pow(2, NB - 1) - 1) {
        y = pow(2, NB - 1) - 1;
    }
    else if (y < -pow(2, NB - 1)) {
        y = -pow(2, NB - 1);
    }

    //VOUT evaluation
    if ((valid_samples >= 11) && (vin == 1))
      *(vout) = 1;
    else
      *(vout) = 0;
    return y;
}





int main (int argc, char **argv)
{
    FILE *fp_in;
    FILE *fp_out;
    FILE *fp_c;
    FILE *fp_vhdl;
    int error_check=0;
    int x;
    int y;
    int vin,vout;   ///input data valid

    /// check the command line
    if (argc != 4)
    {
        printf("Use: %s <input_file> <output_file> <vhdl_file>\n", argv[0]);
        exit(1);
    }

    /// open files
    fp_in = fopen(argv[1], "r");
    if (fp_in == NULL)
    {
        printf("Error: cannot open %s\n", argv[1]);
        exit(2);
    }
    fp_out = fopen(argv[2], "w");

    /// get samples and apply filter
    fscanf(fp_in, "%d %d", &x, &vin);
    do
    {
        y = myfilter(x, vin, &vout);
        if(vout == 1){
           fprintf(fp_out,"%d\n", y);
        }
        fscanf(fp_in, "%d %d", &x, &vin);
    }
    while (!feof(fp_in));

    fclose(fp_in);
    fclose(fp_out);



    ///check vhdl and matlab model

    fp_c    = fopen(argv[2], "r");
    fp_vhdl = fopen(argv[3], "r");
    if (fp_vhdl == NULL)
    {
        printf("Error: cannot open %s\n", argv[3]);
        exit(3);
    }


    x = fscanf(fp_c, "%d", &x);
    y = fscanf(fp_vhdl, "%d", &y);
    do
    {
        if(x != y)
        {
            printf("Error value at line %d\n", valid_samples);
            error_check =1;

        }
        x = fscanf(fp_c, "%d", &x);
        y = fscanf(fp_vhdl, "%d", &y);
    }
    while (!feof(fp_c));

    if(error_check == 0)
    {
        printf("File check succesfully\n");
    }

    return 0;

}
