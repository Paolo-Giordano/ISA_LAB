#include<stdio.h>
#include<stdlib.h>

#define NT 10 /// number of coeffs
#define NB 9 /// number of bits
#define N_SHIFT 4

const int b[NT+1]= {-1, -4, -7, 16, 70, 101, 70, 16, -7, -4, -1}; /// b array

/// Perform fixed point filtering assuming direct form I
///\param x is the new input sample
///\return the new output sample
int myfilter(int x)
{
    static int sx[NT]; /// x shift register
    static int sy[NT-1]; /// y shift register
    static int first_run = 0; /// for cleaning shift registers
    int i; /// index
    int y; /// output sample
    static int tmp;

    /// clean the buffers
    if (first_run == 0)
    {
        first_run = 1;
        tmp = 0;
        for (i=0; i<NT; i++)
            sx[i] = 0;
    }

    /// shift and insert new sample in x shift register
    for (i=NT-1; i>0; i--)
        sx[i] = sx[i-1];
    sx[0] = x >> N_SHIFT;         ///NOTE: reduce the dynamic of input to obtain lower multiplication

    /// make the convolution
    /// Moving average part
    y = 0;
    for (i=0; i<NT; i++)
    {
        y += (sx[i]*b[i]) >> (NB-3) ;      ///shift the mult result to work with less bit
    }

    y = y << 2;         ///bring back the fixed point at the correct position
    return y;
}

int main (int argc, char **argv)
{
    FILE *fp_in;
    FILE *fp_out;

    int x;
    int y;

    /// check the command line
    if (argc != 3)
    {
        printf("Use: %s <input_file> <output_file>\n", argv[0]);
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
    fscanf(fp_in, "%d", &x);
    do
    {
        y = myfilter(x);
        fprintf(fp_out,"%d\n", y);
        fscanf(fp_in, "%d", &x);
    }
    while (!feof(fp_in));

    fclose(fp_in);
    fclose(fp_out);

    return 0;

}
