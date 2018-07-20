#
# Cookbook:: opennms_helm
# Spec:: default
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

require 'spec_helper'

describe 'opennms_helm::default' do
  %w(6.9 7.4.1708).each do |plat_ver|
    context "When not using search for OpenNMS instances on CentOS #{plat_ver}" do
      before do
        stub_command('rpm -qai "*gpg*" | grep -q OpenNMS').and_return(false)
      end

      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new(platform: 'centos', version: plat_ver) do |node|
          node.default['helm']['organizations']['Businesstown'] = { name: 'The Town of Business' }
          node.default['opennms']['instances']['localhost'] = {}
          node.default['opennms']['instances']['remotehost'] = { username: 'scarves', password: 'caps', org: 'sweaters', users: { vault: 'longjohns', item: 'slacks' } }
        end
        runner.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'installs and enables helm' do
        expect(chef_run).to install_package('opennms-helm')
        expect(chef_run).to post_http_request('enable helm').with(headers: { 'Authorization' => 'Basic YWRtaW46YWRtaW4=' })
        expect(chef_run.http_request('enable helm')).to notify("file[#{Chef::Config['file_cache_path']}/helm_enabled]").to(:create).immediately
      end

      it 'adds opennms datasources for localhost' do
        expect(chef_run).to create_grafana_datasource('opennms-performance-localhost').with(datasource: { type: 'opennms-helm-performance-datasource', access: 'proxy', url: 'http://localhost:8980/opennms', basicAuth: true, basicAuthUser: 'admin', basicAuthPassword: 'admin' }, admin_user: 'admin', admin_password: 'admin')
        expect(chef_run).to create_grafana_datasource('opennms-fault-localhost').with(datasource: { type: 'opennms-helm-fault-datasource', access: 'proxy', url: 'http://localhost:8980/opennms', basicAuth: true, basicAuthUser: 'admin', basicAuthPassword: 'admin' }, admin_user: 'admin', admin_password: 'admin')
        expect(chef_run).to create_grafana_datasource('opennms-flow-localhost').with(datasource: { type: 'opennms-helm-flow-datasource', access: 'proxy', url: 'http://localhost:8980/opennms', basicAuth: true, basicAuthUser: 'admin', basicAuthPassword: 'admin' }, admin_user: 'admin', admin_password: 'admin')
      end

      it 'adds opennms datasources for remotehost' do
        expect(chef_run).to create_grafana_datasource('opennms-performance-remotehost').with(datasource: { type: 'opennms-helm-performance-datasource', access: 'proxy', url: 'http://remotehost:8980/opennms', basicAuth: true, basicAuthUser: 'scarves', basicAuthPassword: 'caps' }, admin_user: 'admin', admin_password: 'admin')
        expect(chef_run).to create_grafana_datasource('opennms-fault-remotehost').with(datasource: { type: 'opennms-helm-fault-datasource', access: 'proxy', url: 'http://remotehost:8980/opennms', basicAuth: true, basicAuthUser: 'scarves', basicAuthPassword: 'caps' }, admin_user: 'admin', admin_password: 'admin')
        expect(chef_run).to create_grafana_datasource('opennms-flow-remotehost').with(datasource: { type: 'opennms-helm-flow-datasource', access: 'proxy', url: 'http://remotehost:8980/opennms', basicAuth: true, basicAuthUser: 'scarves', basicAuthPassword: 'caps' }, admin_user: 'admin', admin_password: 'admin')
      end

      it 'manages Main Org.' do
        expect(chef_run).to update_grafana_organization('Main Org.').with(organization: { name: 'Main Org.' })
      end

      it 'manages Businesstown' do
        expect(chef_run).to update_grafana_organization('Businesstown').with(organization: { name: 'The Town of Business' })
      end

      it 'nothing a state file' do
        expect(chef_run).to nothing_file("#{Chef::Config['file_cache_path']}/helm_enabled")
      end
    end
    context "When using search for OpenNMS instances on CentOS #{plat_ver}" do
      before do
        stub_command('rpm -qai "*gpg*" | grep -q OpenNMS').and_return(false)
        stub_search(:node, 'recipes:"opennms"').and_return([{ fqdn: 'localhost', opennms: { properties: { jetty: { port: 8980 } }, users: { admin: { password: 'admin' } } } }])
      end

      let(:chef_run) do
        runner = ChefSpec::SoloRunner.new(platform: 'centos', version: plat_ver)
        runner.converge(described_recipe)
      end

      it 'adds opennms datasources for localhost' do
        expect(chef_run).to create_grafana_datasource('opennms-performance-localhost').with(datasource: { type: 'opennms-helm-performance-datasource', access: 'proxy', url: 'http://localhost:8980/opennms', basicAuth: true, basicAuthUser: 'admin', basicAuthPassword: 'admin' }, admin_user: 'admin', admin_password: 'admin')
        expect(chef_run).to create_grafana_datasource('opennms-fault-localhost').with(datasource: { type: 'opennms-helm-fault-datasource', access: 'proxy', url: 'http://localhost:8980/opennms', basicAuth: true, basicAuthUser: 'admin', basicAuthPassword: 'admin' }, admin_user: 'admin', admin_password: 'admin')
        expect(chef_run).to create_grafana_datasource('opennms-flow-localhost').with(datasource: { type: 'opennms-helm-flow-datasource', access: 'proxy', url: 'http://localhost:8980/opennms', basicAuth: true, basicAuthUser: 'admin', basicAuthPassword: 'admin' }, admin_user: 'admin', admin_password: 'admin')
      end
    end
  end
end
