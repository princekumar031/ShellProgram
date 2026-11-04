

#!/bin/bash

# ==========================================
#       BANKER'S ALGORITHM
#       Deadlock Avoidance System
# ==========================================

n=5
r=3

# Allocation Matrix
alloc=(
    "0 0 1"
    "3 0 0"
    "1 0 1"
    "2 3 2"
    "0 0 3"
)

# Maximum Resource Matrix
max=(
    "7 6 3"
    "3 2 2"
    "8 0 2"
    "2 3 2"
    "5 2 3"
)

# Available Resources
avail=(2 3 2)

# Associative array for Need Matrix
declare -A need

# Process completion status
finish=()
ans=()

echo "=========================================="
echo "          BANKER'S ALGORITHM"
echo "=========================================="

echo
echo "Initial Available Resources: ${avail[*]}"

# ------------------------------------------
# Step 1: Calculate Need Matrix
# Need = Maximum - Allocation
# ------------------------------------------

echo
echo "----------- NEED MATRIX ----------------"

for ((i=0; i<n; i++))
do
    read -ra A <<< "${alloc[i]}"
    read -ra M <<< "${max[i]}"

    echo -n "P$i : "

    for ((j=0; j<r; j++))
    do
        need["$i,$j"]=$((M[j] - A[j]))
        echo -n "${need["$i,$j"]}  "
    done

    echo
done

# ------------------------------------------
# Step 2: Initialize Finish Array
# ------------------------------------------

for ((i=0; i<n; i++))
do
    finish[$i]=0
done

completed=0
ind=0

# ------------------------------------------
# Step 3: Find Safe Sequence
# ------------------------------------------

echo
echo "----------- PROCESS EXECUTION -----------"

while (( completed < n ))
do
    progress=0

    for ((i=0; i<n; i++))
    do
        if (( finish[i] == 0 ))
        then
            can_run=1

            for ((j=0; j<r; j++))
            do
                need_value=${need["$i,$j"]}

                if (( need_value > avail[j] ))
                then
                    can_run=0
                    break
                fi
            done

            if (( can_run == 1 ))
            then
                echo
                echo "Process P$i can execute."

                ans[$ind]=$i
                ((ind++))

                # Release allocated resources
                read -ra A <<< "${alloc[i]}"

                for ((j=0; j<r; j++))
                do
                    avail[$j]=$((avail[j] + A[j]))
                done

                finish[$i]=1
                ((completed++))
                ((progress++))

                echo "Updated Available Resources: ${avail[*]}"
            fi
        fi
    done

    # Stop if no process can execute
    if (( progress == 0 ))
    then
        break
    fi
done

# ------------------------------------------
# Step 4: Display Final Result
# ------------------------------------------

echo
echo "=========================================="

if (( completed == n ))
then
    echo "       SYSTEM IS IN SAFE STATE"
    echo "=========================================="

    echo -n "Safe Sequence: "

    for ((i=0; i<n; i++))
    do
        echo -n "P${ans[i]}"

        if (( i < n-1 ))
        then
            echo -n " -> "
        fi
    done

    echo
else
    echo "      SYSTEM IS IN UNSAFE STATE"
    echo "=========================================="

    echo "Completed Processes: $completed out of $n"
    echo "Remaining Processes:"

    for ((i=0; i<n; i++))
    do
        if (( finish[i] == 0 ))
        then
            echo "P$i is not completed."
        fi
    done
fi

echo "=========================================="
