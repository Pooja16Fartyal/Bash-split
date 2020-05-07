# Bash-split
##### Feature: 
This module is used for splitting the large file into number of chunks.

##### Description: 

 - It includes a shell scripting file i.e. split.sh
- split.sh: It includes the code for splitting the large CSV (Comma-delimited, Comma-separated values) and TXT (Tab-delimited Text) into multiple file.

##### Run Command: 

Open Command Prompt/ Git Bash and navigate to the folder where the script file is available and run the below command

    bash split.sh -file=[file to split] –[identifier]=[number of line/ numbers of record/ size]                                                     


|          Command       | Description                                                                 |
| ---------------------- |:---------------------------------------------------------------------------:|
| bash                   | Bash is a Unix shell and command language which can run Shell Script files. |
| split.sh               | File that includes all the code for splitting the file                      |
|-file, -file=Book.csv 	 | Filename that needs to be split                                             |
|-length, -length=30		 | Split the file through length                                               |
|-size,  -size=10KB	     | Split the file through size                                                 |
|--without-header	       | Not include the header in each file                                         |
|--output-path	         | Set path fo splitting file                                                  |


- Identifier is used to identify the splitting method to be used – either it can be done through length (-length) or through size (-size) where SIZE is at most SIZE bytes of lines per output file.
- SIZE may be one of the following, or an integer optionally followed by one of following multipliers

|    suffix       | multiplier       |
| --------------- |:----------------:|
|    KB           | 1000             |
|    K 	          |    1024          |
|    MB		        |1000 x 1000       |
|    M            | 1024 x 1024      |



...and so on for G (gigabytes), T (terabytes), P (petabytes), E (exabytes), Z (zettabytes), Y (yottabytes).

Output : Format of splitting file is : 
Filename_split_year_month_dayThour_minute_second_numbering


##### Example: 

1.	Split by length: 

  Input: 
        
        bash split.sh -file=EmployeeTable.csv --output-path=/Users/poojafartyal/Documents/NodeJS\ Training/Bash-split/Out/ -length=100
            
            
Output: Each output file contains 100 records with header

E.g:  EmployeeTable_split_2020_05_07T10_03_13_00.csv, 
      EmployeeTable_split_2020_05_07T10_03_13_01.csv

2.	Split by size: 
    Input: 
      
        bash split.sh -file=EmployeeTable.csv -size=10KB –without-header
 
 Output: Size of each split files are 10 KB and without header
 E.g.:  EmployeeTable_split_2020_05_07T10_03_13_00.csv, EmployeeTable_split_2020_05_07T10_03_13_01.csv

Note: 
- *By default, the file contains the header if the identifier –without-header is not passed
- **If the file is splitting through and [Number of line/ numbers of record is missing] then the default number is 1000 for csv/txt
- *** If the file is splitting through size and size argument is missing then the default size is 10MB for csv/txt.
