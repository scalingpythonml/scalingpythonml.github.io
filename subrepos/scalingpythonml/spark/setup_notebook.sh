#!/bin/bash
pushd containers
./build.sh
popd
kubectl create serviceaccount -n jhub spark
kubectl create namespace spark
kubectl create rolebinding spark-role --clusterrole=edit --serviceaccount=jhub:spark --namespace=spark
# We can't override SA in the launcher on per-container basis
kubectl create rolebinding spark-role-to-dask-acc --clusterrole=edit --serviceaccount=jhub:dask --namespace=spark
# Create a service for the executors to connect back to the driver on the notebook
kubectl create service -n jhub driver-service.yaml