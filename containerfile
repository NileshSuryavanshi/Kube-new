FROM rhel9
LABEL description = " just a apache server "
RUN yum install -y httpd
CMD echo "Hello from nil"
EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd","-D","FOREGROUND"]
