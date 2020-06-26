FROM debian:unstable

RUN printf "deb http://deb.debian.org/debian unstable main contrib non-free\ndeb-src http://deb.debian.org/debian unstable main contrib non-free\n" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y eatmydata
RUN eatmydata apt-get dist-upgrade -y
RUN eatmydata apt-get install -y openssh-server distcc htop vim less

RUN adduser --disabled-password --gecos "Giovanni Mascellani,,," giovanni

RUN mkdir /home/giovanni/.ssh
COPY authorized_keys /home/giovanni/.ssh
RUN chown -Rc giovanni:giovanni /home/giovanni/.ssh

RUN mkdir /root/.ssh
COPY authorized_keys /root/.ssh

RUN mkdir /var/run/sshd
#RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
