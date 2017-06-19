#
# Cookbook Name:: vel_es
# Recipe:: es
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#




package 'elasticsearch' do
  action :install
end

bash 'update_rc.d' do
  user 'root'
  code <<-EOH
  update-rc.d elasticsearch defaults 95 10
  EOH
end

cookbook_file '/etc/default/elasticsearch' do
  source 'elasticsearch.default'
  owner 'root'
  group 'root'
  mode 00660
end

bash 'system_tweaks' do
  user 'root'
  code <<-EOH
  echo "elasticsearch  -  nofile  65536" >> /etc/security/limits.conf
  sed -i -e 's/# session    required   pam_limits.so/session    required   pam_limits.so/g' /etc/pam.d/su
  EOH
  not_if 'grep -qs "elasticsearch" /etc/security/limits.conf'
end

cookbook_file '/etc/elasticsearch/jvm.options' do
  source 'jvm.options'
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml'
  owner 'root'
  group 'root'
  mode 00644
end

execute 'start_es' do
  command 'service elasticsearch start'
  action :run
end
