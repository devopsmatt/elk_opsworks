
# install logstash
bash 'install_logstash' do
  user 'root'
  cwd '/opt'
  code <<-EOH
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  apt-get install apt-transport-https
  echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
  apt-get update
  EOH
  not_if "test -f /etc/apt/sources.list.d/elastic-5.x.list"
end

package 'logstash' do
  action :install
end

bash 'system_tweaks' do
  user 'root'
  code <<-EOH
  echo "logstash  -  nofile  65536" >> /etc/security/limits.conf
  sed -i -e 's/# session    required   pam_limits.so/session    required   pam_limits.so/g' /etc/pam.d/su
  EOH
  not_if 'grep -qs "logstash" /etc/security/limits.conf'
end


cookbook_file '/etc/logstash/logstash.yml' do
  source 'logstash.yml'
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file '/etc/init.d/logstash' do
  source 'logstash.init'
  owner 'root'
  group 'root'
  mode 00755
end

execute 'update_rc' do
  command 'update-rc.d logstash defaults 95 10'
  action :run
end

if [ 'dev', 'vagrant'].include?(node.chef_environment)
  cookbook_file '/etc/logstash/conf.d/nginx.conf' do
    source 'nginx_logfilter.conf'
    owner 'root'
    group 'root'
    mode 00644
  end
else
  get_stack_nodes "get_es_nodes" do
    layer_id '3a54a88e-d234-4cdf-997b-8aecb0e23e04'
    region   'us-east-1'
    label    'es'
    only_if "test -f /etc/hosts"
  end
  template '/etc/logstash/conf.d/nginx.conf' do
    source 'nginx_logfilter.conf.erb'
    owner 'root'
    group 'root'
    mode 00644
    variables ({
      :es_host => node['vel']['nodes']['es']
    })
  end
end

package 'nginx' do
  action :install
end

execute 'restart_logstash' do
  command 'service logstash restart'
  action :run
end
#
# bash 'update_rc.d' do
#   user 'root'
#   code <<-EOH
#   update-rc.d logstash defaults 95 10
#   EOH
# end
#
# execute 'start_logstash' do
#   command ''
#   action :run
# end
