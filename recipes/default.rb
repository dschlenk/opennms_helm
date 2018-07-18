#
# Cookbook:: opennms_helm
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

include_recipe 'grafana::default' if node['helm']['manage_grafana']

package 'opennms-helm' do
  version node['helm']['version']
  notifies :restart, 'service[grafana-server]', :immediately
end

# enable the helm plugin
# START until https://github.com/sous-chefs/grafana/pull/197
#grafana_plugin 'opennms-helm-app' do
#  action :install
#end

port = node['grafana']['ini']['server']['http_port'] || 3000

Chef::Resource::HttpRequest.send(:include, Opennms::Helm)
http_request 'enable helm' do
  url "http://localhost:#{port}/api/plugins/opennms-helm-app/settings"
  message 'id=opennms-helm-app&enabled=true'
  headers lazy { auth_header(node) }
  action :post
  notifies :create, "file[#{Chef::Config['file_cache_path']}/helm_enabled]", :immediately
  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/helm_enabled]") }
end
# END until https://github.com/sous-chefs/grafana/pull/197

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
grafana_datasource 'opennms-performance' do
  datasource(
    type: 'opennms-helm-performance-datasource',
    access: 'proxy',
    url: "http://#{opennms_host}:#{opennms_port}/opennms",
    basicAuth: true,
    basicAuthUser: 'admin',
    basicAuthPassword: opennms_password,
  )
  admin_user node['grafana']['ini']['security']['admin_user']
  admin_password node['grafana']['ini']['security']['admin_password']
  action :create
end

#http_request 'create performance datasource' do
#  url "http://localhost:#{port}/api/datasources"
#  message "{ \"name\": \"opennms-performance\",  \"type\": \"opennms-helm-performance-datasource\",  \"access\": \"proxy\",   \"url\": \"http://#{opennms_host}:#{opennms_port}/opennms\",  \"basicAuth\": true,  \"basicAuthUser\": \"admin\",  \"basicAuthPassword\": \"#{opennms_password}\" }"
#  headers lazy { json_auth_header(node) }
#  action :post
#  notifies :create, "file[#{Chef::Config['file_cache_path']}/performance_ds]", :immediately
#  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/performance_ds") }
#end

grafana_datasource 'opennms-fault' do
  datasource(
    type: 'opennms-helm-fault-datasource',
    access: 'proxy',
    url: "http://#{opennms_host}:#{opennms_port}/opennms",
    basicAuth: true,
    basicAuthUser: 'admin',
    basicAuthPassword: opennms_password,
  )
  admin_user node['grafana']['ini']['security']['admin_user']
  admin_password node['grafana']['ini']['security']['admin_password']
  action :create
end

#http_request 'create fault datasource' do
#  url "http://localhost:#{port}/api/datasources"
#  message "{ \"name\": \"opennms-fault\",  \"type\": \"opennms-helm-fault-datasource\",  \"access\": \"proxy\",   \"url\": \"http://#{opennms_host}:#{opennms_port}/opennms\",  \"basicAuth\": true,  \"basicAuthUser\": \"admin\",  \"basicAuthPassword\": \"#{opennms_password}\" }"
#  headers lazy { json_auth_header(node) }
#  action :post
#  notifies :create, "file[#{Chef::Config['file_cache_path']}/fault_ds]", :immediately
#  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/fault_ds") }
#end

grafana_datasource 'opennms-flow' do
  datasource(
    type: 'opennms-helm-flow-datasource',
    access: 'proxy',
    url: "http://#{opennms_host}:#{opennms_port}/opennms",
    basicAuth: true,
    basicAuthUser: 'admin',
    basicAuthPassword: opennms_password,
  )
  admin_user node['grafana']['ini']['security']['admin_user']
  admin_password node['grafana']['ini']['security']['admin_password']
  action :create
end

#http_request 'create flow datasource' do
#  url "http://localhost:#{port}/api/datasources"
#  message "{ \"name\": \"opennms-flow\",  \"type\": \"opennms-helm-flow-datasource\",  \"access\": \"proxy\",   \"url\": \"http://#{opennms_host}:#{opennms_port}/opennms\",  \"basicAuth\": true,  \"basicAuthUser\": \"admin\",  \"basicAuthPassword\": \"#{opennms_password}\" }"
#  headers lazy { json_auth_header(node) }
#  action :post
#  notifies :create, "file[#{Chef::Config['file_cache_path']}/flow_ds]", :immediately
#  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/flow_ds") }
#end
file "#{Chef::Config['file_cache_path']}/helm_enabled" do
  action :nothing
end
#file "#{Chef::Config['file_cache_path']}/performance_ds" do
#  action :nothing
#end
#file "#{Chef::Config['file_cache_path']}/fault_ds" do
#  action :nothing
#end
#file "#{Chef::Config['file_cache_path']}/flow_ds" do
#  action :nothing
#end
