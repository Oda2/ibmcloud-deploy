#!/bin/sh -l

ibmcloud cos download --bucket $1 --key $2 $2

helm update $3 $2 --set=image.tag=$4