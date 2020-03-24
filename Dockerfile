FROM centos:7

COPY mysql6-5.rpm /usr/
RUN rpm -ivh /usr/mysql6-5.rpm
COPY my.cnf /etc/

RUN yum -y update && yum clean all
RUN yum install -y \
	vsftpd \
	ftp \
	mysql-server && yum clean all

COPY inicia-srv.sh /usr/sbin/
RUN chmod +x /usr/sbin/inicia-srv.sh

COPY mysqld /etc/init.d/
COPY econect-conc.jar /usr/
COPY installConc-econect-srv-V_RLS_9_22_3_0.jar /usr/
COPY installConc-econect-cli-V_RLS_9_22_3_0.jar /usr/
COPY tzdata2018e.tar.gz /usr/
COPY jre-8u241-linux-x64.tar.gz /usr/
COPY tzupdater.jar /usr/
COPY auto-install.xml /usr/
COPY auto-install-cli.xml /usr/
COPY PoolConcService.properties /usr/
COPY gtc /usr/gtc

RUN mkdir -p /usr/socin/econect/ftp
RUN useradd socinftp -d /usr/socin/econect/ftp
RUN echo socinftp:1234ftp | chpasswd

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd /etc/pam.d/

WORKDIR /usr/
RUN tar -xzvf jre-8u241-linux-x64.tar.gz
RUN ln -sf /usr/jre1.8.0_241/bin/java /usr/bin/java
RUN ln -sf /usr/jre1.8.0_241/bin/javaws /usr/bin/javaws

RUN rm -f jre-8u241-linux-x64.tar.gz
RUN rm -f mysql6-5.rpm

ENTRYPOINT ["/usr/sbin/inicia-srv.sh"]
