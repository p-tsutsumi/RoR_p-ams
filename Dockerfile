FROM rockylinux/rockylinux:9.4

ENV container docker
RUN dnf groupinstall -y "Development Tools"
RUN dnf install -y man man-pages which
RUN dnf install -y perl zlib-devel openssl-devel gcc
RUN dnf install -y libffi-devel openssl-devel readline-devel postgresql-devel postgresql
RUN dnf install -y nodejs
RUN dnf install -y --enablerepo=crb libyaml-devel

COPY ./idp/certs/server.crt /etc/pki/ca-trust/source/anchors/keycloak-server.crt
RUN update-ca-trust

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH="/root/.rbenv/bin:/root/.rbenv/plugins/ruby-build/bin:$PATH"
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN rbenv install 3.3.10 && rbenv global 3.3.10
ENV PATH="/root/.rbenv/shims:$PATH"

RUN gem install rails -v 7.1.5
RUN gem install ruby-debug-ide
RUN gem install solargraph
