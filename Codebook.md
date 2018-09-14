Code Book
---------------------------------------------------------------
The document captures the transformations performed by the run_analysis.R program to generate the tidy data in tidy.txt.

# Dataset
Location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Input Files
- Training Data:
-- x_train.txt
-- y_train.txt
-- subject_train.txt
- Test Data:
-- x_test.txt
-- `y_test.txt
-- subject_test.txt
- Labels:
-- activity_labels.txt
-- features.txt

# Transformations
- Column names have been made more descriptive. Names like 'tBody', 'Mag', 'Gyro' replaced with 'TimeBody', 'Magnitude', 'Gryoscope', etc. 
- Measurements related to Mean and Standard Deviation are retained
- The output file, tidy.txt, contains the mean for each subject & activity and is ordered based on activity & subject. 

# Output: Tidy Data
- tidy.txt is the output from this script
- It is a space-deliminated file
- The file has a header row with column names
- Columns related to Mean and Standard Deviation from the input data is retained in this file
