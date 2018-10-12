#!/bin/bash
IMAGE_ID=ami-7c491f05

# here we using t2.micro
INSTANCE_TYPE=t2.micro

# key-pair manually created
KEY_NAME=hadoob_admin

# sec_group_id manually created
SEC_GROUP_ID=sg-0d6518b59831d5cb3

# output file
OUT_FILE=.output.txt
n=1
while [ "$n" -le "4" ]
do
aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SEC_GROUP_ID >> $OUT_FILE && echo "Instance created"
sleep .2
 n=$(($n+1))
done
