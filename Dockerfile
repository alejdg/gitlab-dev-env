FROM debian:jessie

RUN apt-get update

RUN apt-get -y install curl

RUN apt-get -y install git

# Trying to make systemd work with docker
RUN ln -s /lib/systemd/system/systemd-logind.service /etc/systemd/system/multi-user.target.wants/systemd-logind.service
RUN mkdir /etc/systemd/system/sockets.target.wants/
RUN ln -s /lib/systemd/system/dbus.socket /etc/systemd/system/sockets.target.wants/dbus.socket
RUN systemctl set-default multi-user.target

# Prepare gitlab repo
RUN curl -s https://packages.gitlab.com/install/repositories/gitlab/nightly-builds/script.deb.sh | bash

RUN apt-get install -y gitlab-ce=8.1.0+git.2045.2aec8f6.26290-rc1.ce.0

RUN echo "postgresql['shared_buffers'] = \"256MB\"" >> /etc/gitlab/gitlab.rb

####
#  Needed to run inside the container
####
#RUN  /opt/gitlab/embedded/bin/runsvdir-start &
#RUN gitlab-ctl reconfigure
####

CMD ["bash"]