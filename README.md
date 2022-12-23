
# ALL FUN AND KUBE

JUST MY PERSONAL PROJECT ON KUBE

## InitContainer
```bash
apiVersion: v1
kind: Pod
metadata:
  name: init-demo1
spec:
  containers:
  -  name: nginx
     image: nginx
     ports:
     - containerPort: 80
     volumeMounts:
     -  name: shared
        mountPath: /usr/share/nginx/html
  initContainers:
  -  name: install
     image: busybox
  volumes:
  - name: shared
    emptyDir: {}		
```
    
## Multi init container
```python
apiVersion: v1 
kind: Pod 
metadata:
  name: init-demo2
  labels:
    app: myapp 
spec:
  containers: 
  -  name: app-container
     image: busybox:1.28
     command: ['sh', '-c', 'echo The app is running! && sleep 3600'] 
  initContainers:
  -  name: init-myservice
     image: busybox:1.28
     command: ['sh', '-c', "until nslookup appservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for appservice; sleep 2; done"] 
  -  name: init-mydb
     image: busybox:1.28
     command: ['sh', '-c', "until nslookup dbservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for dbservice; sleep 2 ; done"]
```
### SVC for multi-init container
```bash
apiVersion: v1
kind: Service
metadata:
  name: appservice
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: dbservice
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80		
```

## Multi Container
```bash
apiVersion: v1 
kind: Pod 
metadata:
  name: multi-container
spec:
  volumes:
  - name: shared-data
    emptyDir: {}

  containers: 
  -  name: nginx-container
     image: nginx
     volumeMounts:
     - name: shared-data
       mountPath: /usr/share/nginx/html
  - name: alpine-container
    image: alpine
    volumeMounts:
    - name: shared-data
      mountPath: /mem-info
    command: ["/bin/sh" , "-c"]
    args:
    - while true; do
        date >> /mem-info/index.html ;
        egrep --color 'Mem|Cache|Swap|' /proc/meminfo >> /mem-info/index.html ;
        sleep 2;
      done			
```

## Statefulset

#### local path provisioner

```bash 
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      storageClassName: local-path
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```
