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

            if [ "$userInput" == "1" ]; then
                read -p "Enter Header Name: " var
                value+=("$var")
                header="$header - ${var}"
                echo "Header Updated: $header"
            elif [ "$userInput" == "2" ]; then
                echo "$header" >> $tableName.txt
                echo "Table Created Succesfully"
                echo "Exit....."
                break
            else
                read -p "Ivalid Input , Enter 1 to create Databas, 2 to Exit: " userInput
            fi

            read -p "Enter 1 to add Another one , 2 to Exit: " userInput
        done
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