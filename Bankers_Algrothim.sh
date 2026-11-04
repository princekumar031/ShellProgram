n=5
r=3

alloc=(
"0 0 1"
"3 0 0"
"1 0 1"
"2 3 2"
"0 0 3"
)

max=(
"7 6 3"
"3 2 2"
"8 0 2"
"2 3 2"
"5 2 3"
)

avail=(2 3 2)

echo "Initial Available Resources: ${avail[*]}"

# Calculate Need
echo
echo "Need Matrix:"

for ((i=0; i<n; i++))
do
    read -ra A <<< "${alloc[i]}"
    read -ra M <<< "${max[i]}"

    echo -n "P$i: "

    for ((j=1; j<r; j++))
    do
        need[$i,$j]=$((M[j] - A[j]))
        echo -n "${need[$i,$j]} "
    done

    echo
done

# Initialize Finish

for ((i=0; i<n; i++))
do
    finish[$i]=0
done

ind=0


echo
echo "Process Execution:"

for ((k=0; k<n; k++))
do
    for ((i=0; i<n; i++))
    do
        if [ ${finish[$i]} -eq 0 ]
        then
            flag=0

            for ((j=0; j<r; j++))
            do
                if [ ${need[$i,$j]} -gt ${avail[$j]} ]
                then
                    flag=1
                    break
                fi
            done

            if [ $flag -eq 0 ]
            then
                echo "P$i can execute"

                ans[$ind]=$i
                ((ind++))

                read -ra A <<< "${alloc[i]}"

                for ((j=0; j<r; j++))
                do
                    avail[$j]=$((avail[j] + A[j]))
                done

                finish[$i]=1
                echo "Available: ${avail[*]}"
            fi
        fi
    done
done

# Display Result
echo
if [ $ind -eq $n ]
then
    echo "-----------------------------------------"
    echo "System is in Safe State"
    echo -n "Safe Sequence: "

    for ((i=0; i<n; i++))
    do
        echo -n "P${ans[i]}"

        if [ $i -lt $((n-1)) ]
        then
            echo -n " -> "
        fi
    done
    echo "--------------------------------------------"
else
    echo "---------------------------------------------"
    echo "System is in Unsafe State"
    echo "Completed Processes: $ind out of $n"
    echo "Remaining Processes:"

    for ((i=0; i<n; i++))
    do
        if [ ${finish[$i]} -eq 0 ]
        then
            echo "P$i not completed"
        fi
    done
    echo "--------------------------------------------"
fi


