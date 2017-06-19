bash 'install_elastic_repo' do
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

package 'kibana' do
  action :install
end

execute 'update_rc' do
  command 'update-rc.d kibana defaults 95 10'
  action :run
end

bash 'fix_kibana_pid' do
  user 'root'
  cwd '/var/run'
  code <<-EOH
  mkdir kibana
  chown kibana:kibana kibana
  EOH
  not_if 'test -d /var/run/kibana'
end

cookbook_file '/etc/kibana/kibana.yml' do
  source 'kibana.yml'
  owner 'root'
  group 'root'
  mode 00644
end

execute 'start_kibana' do
  command 'service kibana restart'
  action :run
end
