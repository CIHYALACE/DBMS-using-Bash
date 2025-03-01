# read -p "Enter Your Name: " name
# read -p "Enter A number: " num
# skills=("HTML" "CSS" "JavaScript")
# declare -A info

# read -p "Enter Your Name: " info["name"]
# read -p "Enter Your Age: " info["age"]


value=()
header=""
read -p "Enter 1 To Create DataBase , 2 to Exit: " userInput

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


if [ "$userInput" == "1" ];then
    CreateTable
elif [ "$userInput" == "2" ];then
    echo "Exit...."
fi