
bash 'install_es_source' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  apt-get -y install apt-transport-https
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
  apt-get update
  EOH
  not_if 'test -f /etc/apt/sources.list.d/elastic-5.x.list'
end

directory '/root/.aws' do
  owner 'root'
  group 'root'
  mode 00700
  recursive true
  action :create
end

package 'awscli' do
  action :install
  not_if "test -e /usr/bin/aws"
end

#Credentials for CLI access to AWS APIs
template '/root/.aws/credentials' do
  source 'aws_cli_credentials.erb'
  owner 'root'
  group 'root'
  mode 0600
  variables({
    :aws_access_key_id     => node['vel']['aws']['key'],
    :aws_secret_access_key => node['vel']['aws']['secret']
  })
end

#Credentials for CLI access to AWS APIs
template '/root/.aws/config' do
  source 'aws_cli_config.erb'
  owner 'root'
  group 'root'
  mode 0600
  variables({
    :aws_access_key_id     => node['vel']['aws']['key'],
    :aws_secret_access_key => node['vel']['aws']['secret']
  })
end
