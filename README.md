# Init container

### Simple example of init container
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
    
    
    
    # Multi-container
   
### Simple example of multi-container

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
