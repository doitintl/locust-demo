# locust-demo

git clone  https://github.com/doitintl/locust-demo


## local dev

from https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/

Setup virtual env for pthon:    
python3 -m pip install --user --upgrade pip  
python3 -m pip install --user virtualenv  
python3 -m venv env  
source env/bin/activate  
which python  

If you want to switch projects or otherwise leave your virtual environment, simply run:  
deactivate  

## setup docker to use google container registry
(examples will need to be swapped to your project name)

gcloud auth configure-docker  
docker build . -t us.gcr.io/andy-playground-264516/locust-image:latest  
docker push us.gcr.io/andy-playground-264516/locust-image:latest  

## setup k8s 
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

setup kubectl to use against new cluster

```
gcloud container clusters get-credentials locust-cluster \
 --zone us-central1-c \
 --project andy-playground-264516
```

set up k8s resources from this projects yaml (NOTE: this yaml will need to be modified also for the gcr container image)

```
kubectl apply -f ./kubernetes/deployment-master.yaml  
kubectl apply -f ./kubernetes/deployment-worker.yaml  
kubectl apply -f ./kubernetes/locust-master-service.yaml  
```

once the master container is running (check via 'kubectl get po')  

run the following command to port forward to the pod:  

```
kubectl port-forward locust-master-84d545bcdf-6qwpv 8089  
```
replace locust-master-84d545bcdf-6qwpv with you pod name  


## quick comands to build and redeploy
docker build . -t us.gcr.io/andy-playground-264516/locust-image:latest
docker push us.gcr.io/andy-playground-264516/locust-image:latest
k delete deploy locust-master
k delete deploy locust-worker
k delete svc locust-master
kubectl apply -f ./kubernetes/deployment-master.yaml
kubectl apply -f ./kubernetes/locust-master-service.yaml
kubectl apply -f ./kubernetes/deployment-worker.yaml




# misc 
wget --spider -qT5 locust-master:5557

/usr/local/bin/locust -f ./locustfile.py --slave --master-host=$LOCUST_MASTER 

kubetail locust-worker

kubectl port-forward locust-master-84d545bcdf-6qwpv 8089
