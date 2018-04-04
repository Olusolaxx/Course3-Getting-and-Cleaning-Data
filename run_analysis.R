run_analysis <- function(directory = "C:/work/data_science/Course3_GetData/data/UCI_HAR_Dataset") {
    ## -- Assume the data is unzipped under the directory pathname specified in the parameter
    ## -- Also assume dplyr package is installed
    library(dplyr);
    setwd(directory);
    ##dt_test <- read.table(file = "./test/Inertial_Signals/body_acc_x_test.txt")
    
    ## -- Read common files and rename column names for convenience
    dt_act_labels <- read.table(file = "./activity_labels.txt");
    dt_act_labels <- rename(dt_act_labels, label_id = V1, label = V2);
    dt_features <- read.table(file = "./features.txt");
    dt_features <- rename(dt_features, field_id = V1, field_name = V2);
    
    ## -- Get rid of double paretheses in field names, not useful
    dt_features$field_name <- gsub("\\()", "", dt_features$field_name);
    
    ## -- Append the row # to the name.  This is needed otherwise some fields get identical names, such as:
    ## -- 382 fBodyAccJerk-bandsEnergy()-1,8
    ## -- 396 fBodyAccJerk-bandsEnergy()-1,8
    dt_features <- mutate(dt_features, field_name = paste(field_name, "_id", field_id, sep = ""));

    ## -- Read main X_test set and set column names using features data frame
    dt_X_test <- read.table(file = "./test/X_test.txt");
    colnames(dt_X_test) <- dt_features$field_name;
    
    ## -- Only select mean and std related fields
    dt_X_test <- select(dt_X_test, +contains("-mean"), +contains("-std"));

    ## -- Read main X_train set and set column names using features data frame
    dt_X_train <- read.table(file = "./train/X_train.txt");
    colnames(dt_X_train) <- dt_features$field_name;
    
    ## -- Only select mean and std related fields
    dt_X_train <- select(dt_X_train, +contains("-mean"), +contains("-std"));
    
    ## -- Get subjects and labels - for TEST set
    dt_y_test <- read.table(file = "./test/y_test.txt");
    dt_subject_test <- read.table(file = "./test/subject_test.txt");
    dt_subject_test <- rename(mutate(dt_subject_test, id = row_number()), subject_id = V1);

    ## -- Get subjects and labels - for TRAIN set
    dt_y_train <- read.table(file = "./train/y_train.txt");
    dt_subject_train <- read.table(file = "./train/subject_train.txt");
    dt_subject_train <- rename(mutate(dt_subject_train, id = row_number()), subject_id = V1);
    
    ## -- Add the id column = row#
    dt_X_test <- mutate(dt_X_test, id = row_number());
    ## -- Tag this set as TEST
    dt_y_test <- mutate(dt_y_test, set_name = "TEST");
    
    ## -- Add the id column = row#
    dt_X_train <- mutate(dt_X_train, id = row_number());
    ## -- Tag this set as TRAIN
    dt_y_train <- mutate(dt_y_train, set_name = "TRAIN");
    
    ## -- Merge TEST with subjects and labels
    dt_y_test <- merge(merge(rename(mutate(dt_y_test, id = row_number()), label_id = V1), dt_act_labels), dt_subject_test);
    dt_y_test <- select(dt_y_test, id, set_name, label, subject_id);
    dt_test <- merge(dt_y_test, dt_X_test, by.x = "id", by.y = "id", all = FALSE);

    ## -- Merge TRAIN with subjects and labels
    dt_y_train <- merge(merge(rename(mutate(dt_y_train, id = row_number()), label_id = V1), dt_act_labels), dt_subject_train);
    dt_y_train <- select(dt_y_train, id, set_name, label, subject_id);
    dt_train <- merge(dt_y_train, dt_X_train, by.x = "id", by.y = "id", all = FALSE);

    ## -- Combine TEST and TRAIN data in a single data frame
    dt_all <- rbind(dt_test, dt_train)
    len <- length(dt_all);
    
    ## -- Get rid of the id column
    dt_all <- dt_all[,2:len];
    len <- length(dt_all);
    
    ## -- Aggregate by label and subject and calculate mean of all variables
    ## -- skip 1st 4 columns 
    dt_all_agg <- aggregate(dt_all[,4:len], list(dt_all$label, dt_all$subject_id), mean);
    dt_all_agg <- rename(dt_all_agg, label = Group.1, subject_id = Group.2);
    
    ## -- Output both data frames into the text files
    write.table(dt_all, "combined_set.txt", row.names = FALSE);
    write.table(dt_all_agg, "combined_set_agg.txt", row.names = FALSE);
    
}
    