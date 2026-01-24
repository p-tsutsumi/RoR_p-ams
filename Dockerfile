FROM rockylinux/rockylinux:9.4

ENV container docker
RUN dnf groupinstall -y "Development Tools"
RUN dnf install -y man man-pages which
RUN dnf install -y perl zlib-devel openssl-devel gcc
RUN dnf install -y libffi-devel openssl-devel readline-devel postgresql-devel postgresql
RUN dnf install -y nodejs
RUN dnf install -y --enablerepo=crb libyaml-devel
RUN dnf install -y nginx

COPY ./idp/certs/server.crt /etc/pki/ca-trust/source/anchors/keycloak-server.crt

RUN mkdir /certs
RUN openssl req -x509 -newkey rsa:4096 -keyout certs/server.key -out /certs/server.crt -days 3650 -nodes -subj "/CN=localhost"
COPY /certs/server.crt /etc/pki/ca-trust/source/anchors/rails-server.crt
COPY ./infra/nginx/nginx.conf /etc/nginx/conf.d/default.conf
RUN update-ca-trust
RUN nginx

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH="/root/.rbenv/bin:/root/.rbenv/plugins/ruby-build/bin:$PATH"
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN rbenv install 3.3.10 && rbenv global 3.3.10
ENV PATH="/root/.rbenv/shims:$PATH"

RUN gem install rails -v 7.1.5
RUN gem install ruby-debug-ide
RUN gem install solargraph
