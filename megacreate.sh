#!/usr/bin/env bash
filename='users.txt'
while read line; do
# reading each line
./create_mail_user_SQL.sh $line Password~1234~ 
done < $filename