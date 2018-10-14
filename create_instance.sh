#!/bin/bash
# here we use Red Hat Enterprise Linux 7.5 (HVM), SSD Volume Type - ami-7c491f05
#IMAGE_ID=ami-7c491f05
IMAGE_ID=ami-00f11891ed27779a9

# here we using t2.micro
INSTANCE_TYPE=t3.large

# key-pair manually created
KEY_NAME=hadoop_admin

# sec_group_id manually created
SEC_GROUP_ID=sg-02d46a6c8119fb4dc

# output file
OUT_FILE=.output.txt

# instance creation
aws ec2 run-instances --image-id $IMAGE_ID --count 4 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SEC_GROUP_ID > $OUT_FILE
sleep 60
#aws ec2 create-tags --resources `cat .output.txt | grep InstanceId | awk '{print $2}' | cut -d'"' -f2` --tags Key=env,Value=hadoop_training && echo "Tag Added"

# adding tags
for i in `cat .output.txt | grep InstanceId | awk '{print $2}'  | cut -d'"' -f2` ; do aws ec2 create-tags --resources $i --tags Key=env,Value=hadoop_training ; done

sleep 2

echo -e "\tYou can use Instance IP and attached .pem key to login the servers.\n\nInstructions:\n\n1). Download the attached .pem key\n2). Set proper permission for .pem key: chmod 400 hadoop_admin.pem\n3). Username: ec2-user\n4). Login syntax: ssh -i "hadoop_admin.pem" ec2-user@YOUR_PUBLIC_IP\n" > .public_ip.txt

# getting public ips
for i in `cat .output.txt | grep InstanceId | awk '{print $2}'  | cut -d'"' -f2` ; do echo $i: `aws ec2 describe-instances --instance-ids $i | grep PublicIpAddress | awk -F: '{print $2}' | cut -d'"' -f2` ; done  >> .public_ip.txt

sleep 2
# mail sent

mutt -s "Hadoop Server Login" $1 -a hadoop_admin.pem < .public_ip.txt
