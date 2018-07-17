module Opennms
  module Helm
    def auth_header(node)
      sec = node['grafana_ini']['security']
      { 'Authorization' => "Basic #{Base64.strict_encode64(sec['admin_user'] + ':' + sec['admin_password'])}" }
    end

    def json_auth_header(node)
      ret = auth_header(node)
      ret['Content-Type'] = 'application/json'
      ret
    end
  end
end
