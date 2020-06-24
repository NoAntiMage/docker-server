FROM centos:centos7
RUN yum -y install net-tools \
 && yum -y install wget \
 && yum install passwd openssl openssh-server -y \
 && ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ' ' \
 && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
 && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N '' \
 && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
CMD "/usr/sbin/init"