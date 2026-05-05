#!/bin/bash

BUCKET='one-hundred1 one-thousand1 one-million1'

for x in $BUCKET
do
aws s3 mb s3://$x

done

