FROM centos:latest

# install go
RUN yum install -y wget rpmdevtools make git gcc
RUN wget https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz -P /tmp
RUN tar zxvf /tmp/go1.5.2.linux-amd64.tar.gz -C /usr/local
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

# libnss_stns
ADD ./ /go/src/github.com/pyama86/libnss_stns
RUN chown root:root -R /go/src/github.com/pyama86/libnss_stns/RPM
RUN echo '%_topdir /go/src/github.com/pyama86/libnss_stns/RPM' > ~/.rpmmacros


WORKDIR /go/src/github.com/pyama86/libnss_stns
RUN cp build/ssh_stns_wrapper RPM/BUILD/
RUN go get github.com/tools/godep
RUN godep restore
RUN go build -buildmode=c-shared -o RPM/BUILD/libnss_stns.so libnss_stns.go
CMD rpmbuild -ba RPM/SPECS/libnss_stns.spec