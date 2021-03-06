#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//parameters: file with VHDL results, file with C results,
//third parameter set to 0 to consider the basic version of the filter 
//without optimizations, 1 to cosider the version with unfolding
int main(int argc, char **argv)
{
    //results check

    if (argc == 4)   //check if there are the files to be compared
    {

    	FILE * fp_simresults_file = fopen(argv[1], "r"); //open file to be checked
        if ( fp_simresults_file  == NULL)
        {
            printf("Error: cannot open %s\n", argv[1]);
            exit(2);
        }

        FILE* fp_reference_file = fopen(argv[2], "r"); //open file with the c results
		if ( fp_reference_file  == NULL)
        {
            printf("Error: cannot open %s\n", argv[3]);
            exit(3);
        }
        int res_sim, res_c;
        int error = 0;
        int line = 0;

        fscanf(fp_simresults_file, "%d\n", &res_sim);    //read first data from vhdl file

		if (strcmp(argv[3],"1")==0 ){
			fscanf(fp_reference_file, "%d\n", &res_c);   
			fscanf(fp_reference_file, "%d\n", &res_c);}
		    do {
		        fscanf(fp_reference_file, "%d\n", &res_c);
		        line++;
		        if (res_sim != res_c)
		        {
		            printf("Error at line %d:\nC result:%d\nsimulation result:%d\n", line, res_c, res_sim);
		            error = 1;
		        }
		        fscanf(fp_simresults_file, "%d\n", &res_sim);
		    }
		    while (!feof(fp_simresults_file) && !feof(fp_reference_file) );

		    if (error == 1)
		        printf("Check failed!\n");
		    else
		        printf("Check successful!\n");

		    fclose(fp_reference_file);
		    fclose(fp_simresults_file);

    }
    else{
        printf("Use: %s <input_file1> <output_file2> <type_of_check>", argv[0]);
    }

    return 0;
}
