FROM centos:7

#RUN echo "include_only=.jp" >> /etc/yum/pluginconf.d/fastestmirror.conf

# install maven
RUN curl -SLO http://ftp.riken.jp/net/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz \
    && mkdir -p /usr/share/maven \
    && tar xzf apache-maven-*.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm apache-maven-*.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Install OpenJDK8, etc.
RUN yum install -y wget java-1.8.0-openjdk-devel \
    && yum clean all

# Install MongoDB, rabbitmq, fluentd
ADD *.repo /etc/yum.repos.d/

RUN cd /opt \
    && wget --no-check-certificate https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.9/rabbitmq-server-3.7.9-1.el7.noarch.rpm \
    && yum install -y mongodb-org rabbitmq-server*.rpm td-agent gcc \
    && /bin/rm rabbitmq-server*.rpm \
    && yum clean all

# Install fluentd mongodb plugin
RUN /usr/sbin/td-agent-gem install fluent-plugin-mongo

# install Node.js
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash - \
    && yum install -y nodejs \
    && yum clean all

# Install OpenJDK 11
ENV JAVA_VERSION 11.0.1
RUN cd /opt \
    && curl -O --insecure https://download.java.net/java/GA/jdk11/13/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz \
    && tar xzf openjdk-${JAVA_VERSION}*.tar.gz \
    && /bin/rm openjdk-${JAVA_VERSION}*.tar.gz \
    && ln -s /opt/jdk-${JAVA_VERSION} /opt/jdk

# Default to use OpenJDK 11
ENV JAVA8_HOME /usr/lib/jvm/java-1.8.0
ENV JAVA_HOME /opt/jdk
ENV PATH ${JAVA_HOME}/bin:${PATH}

# create locale
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && locale -a

# set default timezone / locale
ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# set home dir (for jenkins user)
ENV HOME /home
RUN chmod ugo+rwx ${HOME}

# change permissions
RUN /bin/rm -rf /var/yum/cache/* \
    && chmod -v -R ugo+rwx /var/run /var/log /var/lib/mongo /var/lib/rabbitmq /etc/rabbitmq

# add mongo cofig/scripts
ADD mongo/mongod.conf /etc/
ADD mongo/mongod.sh /opt/

# add fluentd config/scripts
ADD fluentd/td-agent.conf /etc/td-agent/
ADD fluentd/td-agent.sh /opt/

# add rabbitmq config/scripts
ADD rabbitmq/rabbitmq.config /etc/rabbitmq/
ADD rabbitmq/rabbitmq.sh /opt/

# change permission
RUN chmod 755 /opt/*.sh
RUN chmod 755 /opt/*.py
