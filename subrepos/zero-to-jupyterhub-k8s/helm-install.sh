RELEASE=jhub

NAMESPACE=jhub

helm install    $RELEASE jupyterhub/jupyterhub   --namespace $NAMESPACE   --create-namespace   --version=0.10.2     --values config.yaml
