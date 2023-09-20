FROM ubi8/ubi:8.3
LABEL io.openshift.expose-services="8080:http"
RUN yum install -y httpd && \
    yum clean all

EXPOSE 8080
# Change web server port to 8080
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/#ServerName www.example.com:80/ServerName 0.0.0.0:8080/g" /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

ONBUILD COPY src/ /var/www/html/
# Run as a non-privileged user
USER 1001


CMD ["httpd", "-D", "FOREGROUND"]