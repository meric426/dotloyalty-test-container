FROM ubuntu:18.04

MAINTAINER meric426 "https://github.com/meric426"

# Install packages
RUN apt-get update
RUN apt-get install -y build-essential curl git lftp sudo
RUN apt-get install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libpq-dev
RUN apt-get clean

# Install rbenv and ruby-build

RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN echo 'export PATH="/root/.rbenv/shims:/root/.rbenv/bin:$PATH"' >> ~/.bashrc
ENV PATH /root/.rbenv/shims:/root/.rbenv/bin:$PATH

# Install multiple versions of ruby
ENV CONFIGURE_OPTS --disable-install-doc
ADD ./ruby-versions.txt /root/ruby-versions.txt
RUN xargs -L 1 rbenv install < /root/ruby-versions.txt

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'for v in $(cat /root/ruby-versions.txt); do rbenv global $v; gem install bundler; done'
