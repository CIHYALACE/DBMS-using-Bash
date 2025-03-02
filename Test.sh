CreateDB(){
    read -p "Enter DataBase Name: " DBName
    mkdir DataBases/$DBName
    echo "DataBase Named $DBName Created Successfully! "
}

ListDB(){
    DB_PATH="/f/Bash Script/DataBases"
    find "$DB_PATH" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

ConnectToDataBase(){
    DB_PATH="/f/Bash Script/DataBases"

    read -p "Enter the database name to enter: " dbName
    TARGET_DB="$DB_PATH/$dbName"

    if [ -d "$TARGET_DB" ]; then
        cd "$TARGET_DB"
        echo "You are now inside '$TARGET_DB'"
        while true; do
            read -p "Enter Number:
            1-Create Table.
            2-List Tabels.
            3-Drop Table.
            4-Insert Into Tabels.
            5-SelectFromTables.
            6-Delete From Tables.
            7-Update Table.
            8-Exit.
            : " userInput

        if [ "$userInput" = "1" ]; then
            CreateTable
        elif [ "$userInput" = "2" ]; then
            ListTabels
        elif [ "$userInput" = "3" ]; then
            DropTable
        elif [ "$userInput" = "4" ]; then
            InsertIntoTabels
        elif [ "$userInput" = "5" ]; then
            SelectFromTables
        elif [ "$userInput" = "6" ]; then
            DeleteFromTables
        elif [ "$userInput" = "7" ]; then
            UpdateTable
        elif [ "$userInput" = "8" ]; then
            echo "Exit...."
            break  
        else
            echo "Invalid input! Please enter a number between 1-8."
        fi
        done
    else
        echo "Error: Database '$dbName' not found!"
    fi
}

DropDataBase(){
    DB_PATH="/f/Bash Script/DataBases"

    read -p "Enter the database name to Drop: " dbName
    TARGET_DB="$DB_PATH/$dbName"

    if [ -d "$TARGET_DB" ]; then
        read -p "Are You Sure You Gonna Lose All Data In $TARGET_DB (Yes , No): " confirmation
        if [ "${confirmation,,}" = "yes" ];then
            rm -r "$TARGET_DB"
            echo "'${TARGET_DB##*/}' Deleted Successfully"
        fi        
    else
        echo "Error: Database '$dbName' not found!"
    fi
}

CreateTable(){
    read -p "Enter tbale Name: " tableName

    if [[ -f "$tableName.txt" ]]; then
        echo "Table exists!"
    else
        while true; do
            read -p "Enter 1 to add a header, 2 to finish: " userInput
            if [ "$userInput" == "1" ]; then
            read -p "Enter Header Name: " var
            while true; do
                read -p "Enter Data Type for $var (int/str): " dataType
                if [[ "$dataType" == "int" || "$dataType" == "str" ]]; then
                    break
                else
                    echo "Invalid data type! Please enter 'int' or 'str'."
                fi
            done
            header="$header- ${var}($dataType)"
            echo "Header Updated: $header"
            elif [ "$userInput" == "2" ]; then
                echo "$header" >> $tableName.txt
                echo "Table Created Succesfully"
                echo "Exit....."
                break
            else
                read -p "Ivalid Input , Enter 1 to create Databas, 2 to Exit: " userInput
            fi
        done
    fi
}

ListTabels(){
    DB_PATH="/f/Bash Script/DataBases"
    TARGET_DB="$DB_PATH/$dbName"

    if [ -d "$TARGET_DB" ]; then
        if [ -z "$(ls -A "$TARGET_DB")" ]; then
            echo "There are no tables in the database."
        else
            echo "Tables in the database '$dbName':"
            ls "$TARGET_DB" | grep -v '^records'
        fi
    else
        echo "Error: Database '$dbName' not found!"
    fi
}

DropTable(){
    read -p "Enter the table name to drop: " tableName

    if [[ -f "$tableName.txt" ]]; then
        rm "$tableName.txt"
        echo "Table '$tableName' dropped successfully."
    else
        echo "Error: Table '$tableName' not found!"
    fi
}

InsertIntoTabels(){
    read -p "Enter the table name to insert into: " tableName

    if [[ -f "$tableName.txt" ]]; then
        headers=$(head -n 1 "$tableName.txt")
        IFS=' - ' read -r -a headerArray <<< "$headers"
        declare -a values

        for header in "${headerArray[@]}"; do
            if [[ -n "$header" ]]; then
                read -p "Enter value for $header: " value
                values+=(" - $value")
            fi
        done

        row=$(IFS=' - '; echo "${values[*]}")
        echo -e "\n$row" >> "$tableName.txt"
        echo "Data inserted successfully into '$tableName'."
    else
        echo "Error: Table '$tableName' not found!"
    fi
}

SelectFromTables(){
    read -p "Enter the table name to select from: " tableName

    if [[ -f "$tableName.txt" ]]; then
        headers=$(head -n 1 "$tableName.txt")
        IFS=' - ' read -r -a headerArray <<< "$headers"

        echo "Available columns: ${headerArray[*]}"
        read -p "Do you want to view specific rows? (yes/no): " viewSpecific

        if [[ "$viewSpecific" == "yes" ]]; then
            read -p "Enter the column name to filter by: " columnName

            # Find the index of the column to filter by
            columnIndex=-1
            for i in "${!headerArray[@]}"; do
                if [[ "${headerArray[$i]}" == "$columnName" ]]; then
                    columnIndex=$i
                    break
                fi
            done

            if [[ $columnIndex -eq -1 ]]; then
                echo "Error: Column '$columnName' not found!"
                return
            fi

            read -p "Enter the value to filter by: " value

            # Display the headers
            printf "%-15s" "${headerArray[@]}"
            echo

            # Read and display the rows that match the value in the specified column
            while IFS= read -r line; do
                IFS=' - ' read -r -a rowArray <<< "$line"
                if [[ "${rowArray[$columnIndex]}" == "$value" ]]; then
                    printf "%-15s" "${rowArray[@]}"
                    echo
                fi
            done < "$tableName.txt"
        else
            # Display the entire content of the table
            printf "%-15s" "${headerArray[@]}"
            echo
            tail -n +2 "$tableName.txt" | while IFS= read -r line; do
                IFS=' - ' read -r -a rowArray <<< "$line"
                printf "%-15s" "${rowArray[@]}"
                echo
            done
        fi
    else
        echo "Error: Table '$tableName' not found!"
    fi
}

DeleteFromTables(){
    read -p "Enter the table name to delete from: " tableName

    if [[ -f "$tableName.txt" ]]; then
        headers=$(head -n 1 "$tableName.txt")
        IFS=' - ' read -r -a headerArray <<< "$headers"

        echo "Available columns: ${headerArray[*]}"
        read -p "Enter the column name to use for deletion: " columnName

        columnIndex=-1
        for i in "${!headerArray[@]}"; do
            if [[ "${headerArray[$i]}" == "$columnName" ]]; then
                columnIndex=$i
                break
            fi
        done

        if [[ $columnIndex -eq -1 ]]; then
            echo "Error: Column '$columnName' not found!"
            return
        fi

        read -p "Enter the value to delete rows by: " value

        tempFile=$(mktemp)

        while IFS= read -r line; do
            IFS=' - ' read -r -a rowArray <<< "$line"
            if [[ "${rowArray[$columnIndex]}" != "$value" ]]; then
                echo "$line" >> "$tempFile"
            fi
        done < "$tableName.txt"

        mv "$tempFile" "$tableName.txt"
        echo "Rows with $columnName = $value deleted successfully from '$tableName'."
    else
        echo "Error: Table '$tableName' not found!"
    fi
}

UpdateTable(){
    read -p "Enter the table name to update: " tableName

    if [[ -f "$tableName.txt" ]]; then
        headers=$(head -n 1 "$tableName.txt")
        IFS=' - ' read -r -a headerArray <<< "$headers"

        echo "Current headers: ${headerArray[*]}"
        read -p "Do you want to update an existing header or add a new one? (update/add): " action

        if [[ "$action" == "update" ]]; then
            read -p "Enter the header name to update: " oldHeader

            headerIndex=-1
            for i in "${!headerArray[@]}"; do
                if [[ "${headerArray[$i]}" == "$oldHeader" ]]; then
                    headerIndex=$i
                    break
                fi
            done

            if [[ $headerIndex -eq -1 ]]; then
                echo "Error: Header '$oldHeader' not found!"
                return
            fi

            read -p "Enter the new header name: " newHeader
            while true; do
                read -p "Enter Data Type for $newHeader (int/str): " dataType
                if [[ "$dataType" == "int" || "$dataType" == "str" ]]; then
                    break
                else
                    echo "Invalid data type! Please enter 'int' or 'str'."
                fi
            done

            headerArray[$headerIndex]="$newHeader($dataType)"
        elif [[ "$action" == "add" ]]; then
            read -p "Enter the new header name: " newHeader
            while true; do
                read -p "Enter Data Type for $newHeader (int/str): " dataType
                if [[ "$dataType" == "int" || "$dataType" == "str" ]]; then
                    break
                else
                    echo "Invalid data type! Please enter 'int' or 'str'."
                fi
            done

            headerArray+=("$newHeader($dataType)")
        else
            echo "Invalid action! Please enter 'update' or 'add'."
            return
        fi

        newHeaders=$(IFS=' - '; echo "${headerArray[*]}")

        sed -i "1s/.*/$newHeaders/" "$tableName.txt"
        echo "Header updated successfully in '$tableName'."
    else
        echo "Error: Table '$tableName' not found!"
    fi
}

value=()
header=""
echo "Welcome To UwU DBMS! "

while true; do
    read -p "Enter Number:
        1-Create DataBase.
        2-List DataBases.
        3-Connect To DataBase.
        4-Drop DataBase.
        5-Exit.
        : " userInput

    if [ "$userInput" = "1" ]; then
        CreateDB
    elif [ "$userInput" = "2" ]; then
        ListDB
    elif [ "$userInput" = "3" ]; then
        ConnectToDataBase
    elif [ "$userInput" = "4" ]; then
        DropDataBase
    elif [ "$userInput" = "5" ]; then
        echo "Exit...."
        break  
    else
        echo "Invalid input! Please enter a number between 1-5."
    fi
done