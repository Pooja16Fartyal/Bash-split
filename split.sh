# definig the default lines per output file
DEFAULT_NUMBER_OF_RECORD=1000

# definig the default file size of each output file
DEFAULT_FILE_SIZE=10MB

# Identifier check for validating the identifier i.e. size or length
IDENTIFIER_CHECK=0

# Including the header in each splitting files by default
HEADER_FLAG=1;

# current date e.g. 2019_12_27T15_19_27
now=$(date +"%Y_%m_%dT%H_%M_%S")


# Loop through arguments and process them
for arg in "$@"
do
    
    case $arg in
        -size=*)
        FILE_SIZE="${arg#*=}"
        FLAG='-C'
        IDENTIFIER_CHECK=`expr $IDENTIFIER_CHECK + 1`
        shift # Remove -size= from processing
        ;;

        -length=*)
        NUMBER_OF_RECORD="${arg#*=}"
        FLAG='-l'
        IDENTIFIER_CHECK=`expr $IDENTIFIER_CHECK + 1`
        shift # Remove -length= from processing
        ;;

        -file=*)
        FILE="${arg#*=}"
        shift # Remove -file= from processing
        ;;

        --without-header)
        # not including header in each splitting files
        HEADER_FLAG=0;
        ;;

        --output-path=*)
        OUTPUT="${arg#*=}"
        shift # Remove  --output-path= from processing
        ;;

        -size)
        IDENTIFIER_CHECK=`expr $IDENTIFIER_CHECK + 1`
        FLAG='-C'
        shift # Remove -size= from processing
        ;;

        -length)
        FLAG='-l'
        IDENTIFIER_CHECK=`expr $IDENTIFIER_CHECK + 1`
        shift # Remove -length= from processing
        ;;
    esac
done

#checking the FILE is passed as an argument or not
if [ -z "$FILE" ]; then
  echo  "File is missing"

#checking the Valid Identifier is passed as an argument or not  
elif [ "$IDENTIFIER_CHECK" -eq 1 ]; then
            
            FILETYPE=${FILE##*.}

            # Replacing every backward slash (\) with slash (/)
            REPLACE_SLASH=${FILE//\\//}
            FILENAME=${REPLACE_SLASH##*/}

            # Replacing every backward slash (\) with slash (/) and add the slash (/) at the end of the path
            if [ -z "$OUTPUT" ]; then
               OUTPUT_PATH=""  
            else 
               OUTPUT_PATH="${OUTPUT//\\//}/"  
            fi    
           
          
            NAME=${FILENAME%%.*}  

            # Final output path for files
            FINAL_PATH="${OUTPUT_PATH}${NAME}_split_${now}_" 
          
            if [[ ("$FILETYPE" = "csv") || ( "$FILETYPE" = "txt" ) ]]; then
                    # operation for json/csv/txt files here
                    echo  "File is in ${FILETYPE} format"

                    if [[ ("$FLAG" = "-l") ]]; then
                        if [ -z "$NUMBER_OF_RECORD" ]; then
                            CHUNK=$DEFAULT_NUMBER_OF_RECORD
                        else   
                            CHUNK=$NUMBER_OF_RECORD
                        fi
                        echo  "Splitting the file through number of records and each file contain ${CHUNK} number of records "
                    else
                       
                        if [ -z "$FILE_SIZE" ]; then
                            CHUNK=$DEFAULT_FILE_SIZE
                        else   
                            CHUNK=$FILE_SIZE
                        fi
                        echo  "Splitting the file through size and each file having ${CHUNK} size"
                    fi

                    if [ "$HEADER_FLAG" -eq 1 ]; then
                      
                        # Getting header
                        HEADER=$(head -1 "$FILE")

                        # checking the OS type
                        if [[ "$OSTYPE" == "darwin"* ]]; then
                            tail -n +2 "$FILE" | gsplit -d ${FLAG} $CHUNK - "$FINAL_PATH" --additional-suffix=.$FILETYPE
                        else
                            tail -n +2 "$FILE" | split -d ${FLAG} $CHUNK - "$FINAL_PATH" --additional-suffix=.$FILETYPE
                        fi

                        for i in "$OUTPUT_PATH"${NAME}_split_${now}*; do
                           echo -e "$HEADER\n$(cat "$i")" > "$i" 
                        done       
        
                    else
                    
                        # checking the OS type
                        if [[ "$OSTYPE" == "darwin"* ]]; then
                           gsplit "$FILE" -d ${FLAG} $CHUNK "$FINAL_PATH" --additional-suffix=.$FILETYPE
                        else
                           split "$FILE" -d ${FLAG} $CHUNK "$FINAL_PATH" --additional-suffix=.$FILETYPE
                        fi
                    fi
            else
              echo "Unsupported Format"  
            fi
 
else 
  echo  "Identifier is not recognized"
fi 

