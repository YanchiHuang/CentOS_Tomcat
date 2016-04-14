# Centos based container with Java and Tomcat
FROM centos:centos7
MAINTAINER Seaman

# Install prepare infrastructure
RUN yum -y update && \
	yum -y install wget && \
	yum -y install tar 

# Prepare environment 
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Oracle Java8
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
	http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz && \
	tar -xvf jdk-8u45-linux-x64.tar.gz && \
	rm jdk*.tar.gz && \
	mv jdk* ${JAVA_HOME}


# Install Tomcat
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.33

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh

# Create Tomcat admin user
#RUN mkdir $CATALINA_HOME/scripts/
#ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
#ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
#RUN chmod +x $CATALINA_HOME/scripts/*.sh

# Create tomcat user
#RUN groupadd -r tomcat && \
#	useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
#	chown -R tomcat:tomcat ${CATALINA_HOME}

WORKDIR /opt/tomcat

EXPOSE 8080


#USER tomcat
CMD ["starpup.sh"]
