# locust-demo

An opinionated demonstration using [locust](https://locust.io/)

# 1 -- clone repo
git clone  https://github.com/doitintl/locust-demo  

# 2 -- setup docker to use google container registry 
- examples will need to be swapped to your project name  

gcloud auth configure-docker  
docker build . -t us.gcr.io/andy-playground-264516/locust-image:latest  
docker push us.gcr.io/andy-playground-264516/locust-image:latest  

# 3 -- setup k8s 
- examples will need to be swapped to your project specifics  

gcloud config set account andy@doit-intl.com  
gcloud config set compute/region us-central1  
gcloud config set compute/zone us-central1-c  
gcloud config set project andy-playground-264516  

```
gcloud container clusters create locust-cluster \
         --zone us-central1-c \
         --scopes "https://www.googleapis.com/auth/cloud-platform" \
         --num-nodes "3" \
         --enable-autoscaling --min-nodes "3" \
         --max-nodes "10" \
         --addons HorizontalPodAutoscaling,HttpLoadBalancing  
```
gcloud config set container/cluster locust-cluster   

# 4 -- setup kubectl to use against new cluster

```
gcloud container clusters get-credentials locust-cluster \
 --zone us-central1-c \
 --project andy-playground-264516
```

# 5 -- set up k8s resources from this projects yaml (NOTE: this yaml will need to be modified also for the gcr container image)

```
kubectl apply -f ./kubernetes/deployment-master.yaml  
kubectl apply -f ./kubernetes/deployment-worker.yaml  
kubectl apply -f ./kubernetes/locust-master-service.yaml  
```

- once the master container is running (check via 'kubectl get po') run the following command to port forward to the pod:  

```
kubectl port-forward locust-master-84d545bcdf-6qwpv 8089  
```
note: replace locust-master-84d545bcdf-6qwpv with you pod name  

# 6 -- run load
- navigate to http://127.0.0.1:8089


