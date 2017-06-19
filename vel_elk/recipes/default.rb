#
# Cookbook Name:: vel_es
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


bash 'install_java' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  apt-add-repository ppa:webupd8team/java
  apt-get update
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
  apt-get install -y -q oracle-java8-installer
  echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> /root/.bashrc
  source /root/.bashrc
  update-java-alternatives -s java-8-oracle
  EOH
  not_if 'test -x /usr/lib/jvm/java-8-oracle/bin/java'
end



include_recipe "#{cookbook_name}::es"
include_recipe "#{cookbook_name}::logstash"
include_recipe "#{cookbook_name}::kibana"
