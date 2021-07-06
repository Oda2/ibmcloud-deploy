#!/bin/sh -l

ibmcloud login --apikey "$4" -r "$5"
ibmcloud cr region-set "$5"
ibmcloud cr login

ibmcloud cos download --bucket $1 --key $2 $2

helm update $3 $2 --set=image.tag=$4