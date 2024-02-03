#!/bin/bash
input=".env"
while IFS= read -r line
do
    arrIN=(${line// / })
    echo "export ${arrIN[0]}=${arrIN[1]}" >> ~/.profile
done < "$input"
