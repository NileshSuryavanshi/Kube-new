
# ALL ABOUT AND KUBE

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
     command:
     - wget
     - "-O"
     - "/shared/index.html"
     volumeMounts:
     -  name: shared
        mountPath: /shared
  volumes:
  - name: shared
    emptyDir: {}
## Multiple init containers
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
