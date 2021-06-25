FROM centos:8
EXPOSE 389

RUN dnf module enable -y 389-ds && yum install -y 389-ds-base-1.4.3.16 389-ds-base-legacy-tools-1.4.3.16 && yum clean all
RUN mkdir -p /etc/dirsrv_orig && cp -r /etc/dirsrv/* /etc/dirsrv_orig/
RUN rm -r /etc/dirsrv /var/log/dirsrv /var/lib/dirsrv
RUN ln -s /data/etc /etc/dirsrv && ln -s /data/var /var/lib/dirsrv && ln -s /data/log /var/log/dirsrv
RUN echo -e '#!/bin/bash\n/start.sh' > /usr/bin/systemctl && mv /usr/lib/systemd/system /usr/lib/systemd/system2
COPY install.inf /
COPY entrypoint.sh /
COPY start.sh /
CMD /entrypoint.sh
