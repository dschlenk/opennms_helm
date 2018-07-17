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
