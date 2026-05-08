#!/bin/bash 

# If Statements & Conditions
  # if [ 1 -eq 2 ]; then 
  #   echo "La condition est vraie"
  # else 
  #   echo "La condition est Fausse"
  # fi 

# Déclaration de Variables & Substitution de Commandes
  # var=3
  # echo "Notre variable est de: $var"

  # ouput=$(ls)
  # echo $ouput 

  # output_var=$(echo "Nous somme le $(date)")
  # echo $output_var

  # source ~/dev/kottiodev_elt/venv/bin/activate
  # python_ouput=$(python ./test.py )
  # python_ouput=$(python -c "print(4 + 2)")

  # echo $python_ouput


# Redirection d'Erreurs (2>&1)

source ~/dev/kottiodev_elt/venv/bin/activate
python_output=$(python -c "print(4/0)" 2>&1)
echo "Hello"
echo $python_output




# Codes de Sortie & Vérification de Statut















  # [ 1 -eq 2 ]
  # echo "Le status code est: $?"
  # echo $?

  # python_ouput=$(python -c "print(4/0)" 2>&1)
  # python_status_code=$?

  # if [ $python_status_code -eq 0 ]; then
  #   echo "Python worked, the ouput is: $python_ouput"
  # else 
  #   echo "Python did not work at $(date), the error is: $python_ouput" >> ./error.log
  # fi

# Gestion Complète d'Erreurs & Filtrage
# source ~/dev/kottiodev_elt/venv/bin/activate

# echo "Start of the script"
# ouput_python_script=$(python ./test.py 2>&1)
# python_status_code=$?

# echo "Start of the If statement"
# if [ $python_status_code -eq 0 ]; then 
#   echo "Python Worked"
#   echo $ouput_python_script
# else 
#   python_error=$(echo "$ouput_python_script" | grep "Error")
#   echo "--------------------------" >> ./error.log
#   echo "Python Script did not work at $(date), error : $python_error" >> ./error.log
#   exit 1
# fi 












# echo "$(date): The script has been executed" >> ~/dev/kottiodev_elt/cron_test/test.log
# python ~/dev/kottiodev_elt/cron_test/test.py >> ~/dev/kottiodev_elt/cron_test/test.log
# source ~/dev/kottiodev_elt/venv/bin/activate