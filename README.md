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
# These containers are run during pod
  initContainers:
  -  name: install
     image: busybox
     command:
     - wget
     - "-O"
     - "/shared/index.html"
     - https://kubesimplify.com/
     volumeMounts:
     -  name: shared
        mountPath: /shared
  volumes:
  - name: shared
    emptyDir: {}
