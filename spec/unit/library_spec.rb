require 'spec_helper'

describe Opennms::Helm do
  describe '#auth_header(node)' do
    let(:node) { { 'grafana_ini' => { 'security' => { 'admin_user' => 'admin', 'admin_password' => 'admin' } } } }
    let(:dummy_class) { Class.new { include Opennms::Helm } }

    it 'gives us the right auth header' do
      expect(dummy_class.new.auth_header(node)).to eq('Authorization' => 'Basic YWRtaW46YWRtaW4=')
    end

    it 'gives us the right json auth header' do
      expect(dummy_class.new.json_auth_header(node)).to eq('Authorization' => 'Basic YWRtaW46YWRtaW4=', 'Content-Type' => 'application/json')
    end
  end
end
