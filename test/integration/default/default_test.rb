# # encoding: utf-8

# Inspec test for recipe opennms_helm::default

describe user('grafana') do
  it { should exist }
end

describe package('opennms-helm') do
  it { should be_installed }
end

describe service('grafana-server') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3000) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
  its('processes') { should include 'grafana-server' }
end

%w(performance fault flow).each do |type|
  %w(localhost remotehost).each do |host|
    describe http("http://localhost:8123/api/datasources/name/opennms-#{type}-#{host}", auth: { user: 'admin', pass: 'admin'}, enable_remote_worker: false) do
      its('status') { should eq 200 }
      its('body') { should match /\{"id":\d+,"orgId":\d+,"name":"opennms-#{type}-#{host}","type":"opennms-helm-#{type}-datasource","typeLogoUrl":"","access":"proxy","url":"http:\/\/#{host}:8980\/opennms","password":"","user":"","database":"","basicAuth":true,"basicAuthUser":"admin","basicAuthPassword":"admin","withCredentials":false,"isDefault":false,"jsonData":\{\},"secureJsonFields":\{\},"version":1,"readOnly":true\}/ }
    end
  end
end

describe http('http://localhost:8123/api/orgs/name/Main%20Org%2E', auth: { user: 'admin', pass: 'admin'}, enable_remote_worker: false) do
  its('status') { should eq 200 }
  its('body') { should match /\{"id":\d+,"name":"Main Org.","address":\{"address1":"","address2":"","city":"","zipCode":"","state":"","country":""\}\}/ }
end
