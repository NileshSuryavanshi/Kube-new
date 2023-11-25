From redhat/centos
name nilesh suryavanshi
Label description = " just a apache server "
Run  yum install -y && \
  yum clean all
Run echo "Hello from nil" 
Expose 80
Entrypoint ["httpd","-D","FOREGROUND"]
