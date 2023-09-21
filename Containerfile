FROM ubi8/ubi:8.3
LABEL io.openshift.expose-services="8080:http"

ENV DOCROOT=/var/www/html

EXPOSE 8080
# Change web server port to 8080
RUN yum install -y httpd && \
    yum clean all && \

RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/#ServerName www.example.com:80/ServerName 0.0.0.0:8080/g" /etc/httpd/conf/httpd.conf && \

RUN chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

RUN echo "Esta es la imagen parent" >> ${DOCROOT}/index.html
ONBUILD COPY src/ ${DOCROOT}/
# Run as a non-privileged user
USER 1001


CMD ["httpd", "-D", "FOREGROUND"]
