module Opennms
  module Helm
    def auth_header(node)
      sec = node['grafana']['ini']['security']
      { 'Authorization' => "Basic #{Base64.strict_encode64(sec['admin_user'] + ':' + sec['admin_password'])}" }
    end

    def json_auth_header(node)
      ret = auth_header(node)
      ret['Content-Type'] = 'application/json'
      ret
    end

    def helm_datasource(opennms_host, instance, type)
      opennms_port = instance['port'] || 8980
      opennms_user = instance['username'] || 'admin'
      opennms_password = instance['password'] || 'admin'
      {
        type: "opennms-helm-#{type}-datasource",
        access: 'proxy',
        url: "http://#{opennms_host}:#{opennms_port}/opennms",
        basicAuth: true,
        basicAuthUser: opennms_user,
        basicAuthPassword: opennms_password,
      }
    end
  end
end

Chef::Recipe.send(:include, Opennms::Helm)
Chef::Resource.send(:include, Opennms::Helm)
