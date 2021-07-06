#!/bin/sh -l

ibmcloud --version 
ibmcloud config --check-version=false
ibmcloud plugin install -f kubernetes-service
ibmcloud plugin install -f container-registry
ibmcloud plugin install -f schematics
ibmcloud plugin install -f cloud-object-storage

ibmcloud plugin list

ibmcloud login --apikey "$5" -r "$6"
ibmcloud cr region-set "$6"
ibmcloud cr login

ibmcloud cos download --bucket $1 --key $2 $2

helm upgrade $3 $2 --set=image.tag=$4