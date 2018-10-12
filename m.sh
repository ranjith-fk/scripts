#!/bin/bash
mutt -s "Hadoop Server Login" $1 -a hadoop_admin.pem < .public_ip.txt
