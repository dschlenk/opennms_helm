#
# Cookbook:: opennms-helm
# Recipe:: default
#
# Copyright:: 2018, ConvergeOne
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

yum_repository 'grafana' do
  baseurl node['helm']['grafana_yum']['baseurl']
  gpgkey node['helm']['grafana_yum']['gpgkey']
  only_if { node['helm']['manage_grafana_repo'] }
end

yum_package 'grafana' do
  version node['grafana']['version']
  flush_cache true
end

package 'opennms-helm' do
  version node['helm']['version']
end

service 'grafana-server' do
  supports status: true, restart: true
  action :enable
end

template '/etc/grafana/grafana.ini' do
  source 'grafana.ini.erb'
  mode 00640
  owner 'root'
  group 'grafana'
  variables(
    grafana: node['grafana_ini']
  )
  notifies :restart, 'service[grafana-server]'
end

template '/etc/grafana/ldap.toml' do
  source 'ldap.toml.erb'
  mode 00640
  owner 'root'
  group 'grafana'
  variables(
    ldap: node['grafana_ldap']
  )
  notifies :restart, 'service[grafana-server]', :immediately
end

# enable the helm app
# curl -v --basic -XPOST 'admin:admin@localhost:3001/api/plugins/opennms-helm-app/settings?enabled=true' -d ''
port = node['grafana_ini']['server']['http_port'] || 3000

http_request 'enable helm' do
  url "http://localhost:#{port}/api/plugins/opennms-helm-app/settings"
  message 'id=opennms-helm-app&enabled=true'
  headers 'Authorization' => 'Basic YWRtaW46YWRtaW4='
  action :post
  notifies :create, "file[#{Chef::Config['file_cache_path']}/helm_enabled]", :immediately
  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/helm_enabled]") }
end

opennms_host = 'localhost'
if node.key?('opennms') && node['opennms'].key?('host')
  opennms_host = node['opennms']['host']
end
opennms_port = 8980
if node.key?('opennms') && node['opennms'].key?('properties') && node['opennms']['properties'].key?('jetty') && node['opennms']['properties']['jetty'].key?('port')
  opennms_port = node['opennms']['properties']['jetty']['port']
end
opennms_password = 'admin'
if node.key?('opennms') && node['opennms'].key?('secure_admin_password')
  opennms_password = node['opennms']['secure_admin_password']
end
http_request 'create performance datasource' do
  url "http://localhost:#{port}/api/datasources"
  message "{ \"name\": \"opennms-performance\",  \"type\": \"opennms-helm-performance-datasource\",  \"access\": \"proxy\",   \"url\": \"http://#{opennms_host}:#{opennms_port}/opennms\",  \"basicAuth\": true,  \"basicAuthUser\": \"admin\",  \"basicAuthPassword\": \"#{opennms_password}\" }"
  headers 'Authorization' => 'Basic YWRtaW46YWRtaW4=', 'Content-Type' => 'application/json'
  action :post
  notifies :create, "file[#{Chef::Config['file_cache_path']}/performance_ds]", :immediately
  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/performance_ds") }
end

http_request 'create fault datasource' do
  url "http://localhost:#{port}/api/datasources"
  message "{ \"name\": \"opennms-fault\",  \"type\": \"opennms-helm-fault-datasource\",  \"access\": \"proxy\",   \"url\": \"http://#{opennms_host}:#{opennms_port}/opennms\",  \"basicAuth\": true,  \"basicAuthUser\": \"admin\",  \"basicAuthPassword\": \"#{opennms_password}\" }"
  headers 'Authorization' => 'Basic YWRtaW46YWRtaW4=', 'Content-Type' => 'application/json'
  action :post
  notifies :create, "file[#{Chef::Config['file_cache_path']}/fault_ds]", :immediately
  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/fault_ds") }
end

http_request 'create flow datasource' do
  url "http://localhost:#{port}/api/datasources"
  message "{ \"name\": \"opennms-flow\",  \"type\": \"opennms-helm-flow-datasource\",  \"access\": \"proxy\",   \"url\": \"http://#{opennms_host}:#{opennms_port}/opennms\",  \"basicAuth\": true,  \"basicAuthUser\": \"admin\",  \"basicAuthPassword\": \"#{opennms_password}\" }"
  headers 'Authorization' => 'Basic YWRtaW46YWRtaW4=', 'Content-Type' => 'application/json'
  action :post
  notifies :create, "file[#{Chef::Config['file_cache_path']}/flow_ds]", :immediately
  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/flow_ds") }
end
file "#{Chef::Config['file_cache_path']}/helm_enabled" do
  action :nothing
end
file "#{Chef::Config['file_cache_path']}/performance_ds" do
  action :nothing
end
file "#{Chef::Config['file_cache_path']}/fault_ds" do
  action :nothing
end
file "#{Chef::Config['file_cache_path']}/flow_ds" do
  action :nothing
end
