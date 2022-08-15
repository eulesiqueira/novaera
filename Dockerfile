FROM centos:7

COPY mysql6-5.rpm /usr/
COPY bematech-driver_CentOS_6.9-2.0.0.2-1.x64.rpm /usr/
RUN rpm -ivh /usr/mysql6-5.rpm
COPY my.cnf /etc/

RUN yum -y update && yum clean all
RUN yum install -y \
        ftp \
        epel-release \
        cups \
        libusb \
        mysql-server && yum clean all

RUN yum install -y proftpd
RUN rpm -ivh /usr/bematech-driver_CentOS_6.9-2.0.0.2-1.x64.rpm

COPY inicia-srv.sh /usr/sbin/
RUN chmod +x /usr/sbin/inicia-srv.sh

COPY mysqld /etc/init.d/

COPY installConc-econect-srv-V_RLS_12_28_1_0.jar /usr/
COPY installConc-econect-cli-V_RLS_12_28_1_0.jar /usr/
COPY jre-8u241-linux-x64.tar.gz /usr/
COPY auto-install.xml /usr/
COPY auto-install-cli.xml /usr/

RUN mkdir -p /usr/socin/econect/ftp
RUN useradd socinftp -d /usr/socin/econect/ftp
RUN echo socinftp:1234ftp | chpasswd

WORKDIR /usr/
RUN tar -xzvf jre-8u241-linux-x64.tar.gz
RUN ln -sf /usr/jre1.8.0_241/bin/java /usr/bin/java
RUN ln -sf /usr/jre1.8.0_241/bin/javaws /usr/bin/javaws

RUN rm -f jre-8u241-linux-x64.tar.gz
RUN rm -f mysql6-5.rpm
RUN rm -f bematech-driver_CentOS_6.9-2.0.0.2-1.x64.rpm

COPY PoolConcService.properties /usr/
COPY gtc /usr/gtc
RUN mkdir /usr/share/fonts/msttcore
COPY cups /etc/cups
COPY msttcore /usr/share/fonts/msttcore

######### ALTERACOES #########
#COPY econect-conc.jar /usr/socin
#COPY econect-util.jar /usr/socin

ENTRYPOINT ["/usr/sbin/inicia-srv.sh"]
