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
# grafana_plugin 'opennms-helm-app' do
#  action :install
# end

port = node['grafana']['ini']['server']['http_port'] || 3000
http_request 'enable helm' do
  url "http://localhost:#{port}/api/plugins/opennms-helm-app/settings"
  message 'id=opennms-helm-app&enabled=true'
  headers lazy { auth_header(node) }
  action :post
  notifies :create, "file[#{Chef::Config['file_cache_path']}/helm_enabled]", :immediately
  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/helm_enabled]") }
end
# END until https://github.com/sous-chefs/grafana/pull/197

# disable search by specifying node['opennms']['instances'] yourself
if node['opennms'].nil? || !node['opennms'].key?('instances')
  opennms_instances = search(:node, node['helm']['instance_search'])
  opennms_instances.each do |instance|
    node.default['opennms']['instances'][instance['fqdn']]['port'] = instance['opennms']['properties']['jetty']['port']
    node.default['opennms']['instances'][instance['fqdn']]['username'] = 'admin'
    node.default['opennms']['instances'][instance['fqdn']]['password'] = instance['opennms']['users']['admin']['password']
  end
end

Chef::Log.fatal "No OpenNMS instances found. Either modify the search string (node['helm']['instance_search'], currently #{node['helm']['instance_search']}) or manually specify OpenNMS instances under node['opennms']['instances']. See README.md for more info." if node['opennms'].nil? || node['opennms']['instances'].nil?

node['opennms']['instances'].each do |host, nms|
  node['helm']['datasource_types'].each do |type|
    grafana_datasource "opennms-#{type}-#{host}" do
      datasource helm_datasource(host, nms, type)
      admin_user node['grafana']['ini']['security']['admin_user']
      admin_password node['grafana']['ini']['security']['admin_password']
      action :create
    end
  end
end

node['helm']['organizations'].each do |name, org|
  grafana_organization name do
    organization(
      name: org['name']
    )
    admin_user node['grafana']['ini']['security']['admin_user']
    admin_password node['grafana']['ini']['security']['admin_password']
    action :update
  end
end

file "#{Chef::Config['file_cache_path']}/helm_enabled" do
  action :nothing
end
