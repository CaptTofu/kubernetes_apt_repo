from debian:wheezy

RUN apt-get -y update
RUN apt-get install -y wget apache2 dpkg-dev

RUN mkdir -p /var/www/deb/amd64

RUN wget --no-check-certificate https://s3-us-west-2.amazonaws.com/k8s-releases/kubernetes_client_1.0.6-1.deb --directory-prefix=/var/www/deb/amd64/
RUN wget  --no-check-certificate https://s3-us-west-2.amazonaws.com/k8s-releases/kubernetes_master_1.0.6-1.deb --directory-prefix=/var/www/deb/amd64/
RUN wget --no-check-certificate https://s3-us-west-2.amazonaws.com/k8s-releases/kubernetes_minion_1.0.6-1.deb --directory-prefix=/var/www/deb/amd64/
RUN wget --no-check-certificate https://s3-us-west-2.amazonaws.com/k8s-releases/flanneld_0.5.3-1.deb --directory-prefix=/var/www/deb/amd64/
RUN wget --no-check-certificate https://s3-us-west-2.amazonaws.com/k8s-releases/etcd_2.0.12-1.deb --directory-prefix=/var/www/deb/amd64/
RUN wget --no-check-certificate https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.9.0-0~jessie_amd64.deb --directory-prefix=/var/www/deb/amd64

# sometimes asked for Packages.gz, sometimes Packages
RUN cd /var/www/deb && dpkg-scanpackages amd64 | gzip -9c > amd64/Packages.gz
RUN cd /var/www/deb && dpkg-scanpackages amd64 > amd64/Packages

RUN chown -R nobody /var/www

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
EXPOSE 80

ENTRYPOINT /usr/sbin/apache2 -DFOREGROUND
