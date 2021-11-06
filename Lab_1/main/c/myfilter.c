#include<stdio.h>
#include<stdlib.h>
#include <math.h>
#include <string.h>

#define NT 11 /// number of coeffs
#define NB 9 /// number of bits
#define N_product_shift 6 /// number of shifts after multiplication
#define N_input_shift 4 ///number of shifts of the data in

//valid samples is used to count if in the shift registers all the positions
//are occupied by valid samples or not, at the beginning is not true
//valid means samples read together with vin='1'
int valid_samples = 0;
const int b[NT]={-1, -4, -7, 16, 70, 101, 70, 16, -7, -4, -1}; /// b array

/// Perform fixed point filtering assuming direct form I
///\param x is the new input sample
///\return the new output sample
int myfilter(int x, int VIN, int* VOUT_fp)
{
    static int sx[NT]; /// x shift register
    static int first_run = 0; /// for cleaning shift registers
    int i; /// index
    int y; /// output sample
    int tmp; ///intermediate result


    /// clean the buffers
    if (first_run == 0)
    {
        first_run = 1;
        for (i = 0; i < NT; i++)
            sx[i] = 0;
    }


    /// shift and insert new sample x in the shift register
    ///the input sample is loaded into the shift register inly if vin=1
    for (i = NT - 1; i > 0; i--)
        if (VIN == 1) {
            sx[i] = sx[i - 1];
        }
    if (VIN == 1) {
        sx[0] = (x >> N_input_shift); //shift on th input to work internally with less bits
        valid_samples++;
    }

    /// make the convolution
    /// Moving average part
    y = 0;
    for (i = 0; i < NT; i++) {
        y += (sx[i] * b[i]) >> N_product_shift; 
		//get rid of the N_product_shift least significant bits of the product
    }

    /// extension to have the result again on NB bits
    y = y << N_product_shift+N_input_shift+1-NB;

    //saturation
    if (y > pow(2, NB - 1) - 1) {
        y = pow(2, NB - 1) - 1;
    }
    else if (y < -pow(2, NB - 1)) {
        y = -pow(2, NB - 1);
    }

	//VOUT evaluation
	if ((valid_samples >= 11) && (VIN == 1))
	  *(VOUT_fp) = 1;
	else
	  *(VOUT_fp) = 0;

  return y;
}


//auguments: file with input samples, name of the file to save the results
int main (int argc, char **argv)
{
  FILE *fp_in;
  FILE *fp_out;

  int x;
  int y;
  int vin, vout;

  /// check the command line
  if (argc != 3)
  {
    printf("Use: %s <input_file> <output_file>", argv[0]);
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
  do{
    y = myfilter(x, vin, &vout);
    if (vout==1)
        fprintf(fp_out,"%d\n", y);
    fscanf(fp_in, "%d %d", &x, &vin);
  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);



  return 0;

}
