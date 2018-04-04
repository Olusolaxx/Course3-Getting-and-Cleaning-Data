# Getting and Cleaning Data - Course Project

The R script run_analysis.R contains the run_analysis() function.
It is assumed the dataset for the project is downloaded and unzipped into the folder passed as a parameter
By default, the following directory is assumed: C:/work/data_science/Course3_GetData/data/UCI_HAR_Dataset

The following describes the functionality of the R function:

1. The R function reads all files into local data frame variables
2. Renames the columns of the measurement fields, using features.txt lookup file provided
3. Merges the data horizontally within each set - test and training using dplyr package
4. Only selects mean atd std measurements for the 1st tidy dataset
4. Renames and creates additional columns as necessary using dplyr package
5. Combines both sets using rbind - this becomes the 1st tidy dataset
6. Averages measurements using mean() function by activity label and subject id - this becomes the 2nd tidy dataset
7. Outputs both datasets into the text files combined_set.txt and combined_set_agg.txt
