#!/usr/bin/env bash
filename='users.txt'
while read line; do
# reading each line
./createuser.sh $line Password~1234~ 
done < $filename