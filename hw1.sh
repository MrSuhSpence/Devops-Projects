#!/bin/bash

if [ $1 > 21 ]
then
echo "Your number is lower than 21, making a bucket now..."
aws s3 mb s3://bucket-twenty-one
else
echo "Your number is 21 or higher, try again"
fi

