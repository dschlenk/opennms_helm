default['helm']['manage_grafana_repo'] = true
default['helm']['grafana_yum']['baseurl'] = "https://packagecloud.io/grafana/stable/el/#{node['platform_version'].to_i}/$basearch"
default['helm']['grafana_yum']['gpgkey'] = 'https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana'
default['grafana_ini']['app'] = {}
default['grafana_ini']['paths'] = {}
default['grafana_ini']['server'] = {}
default['grafana_ini']['database'] = {}
default['grafana_ini']['session'] = {}
default['grafana_ini']['dataproxy'] = {}
default['grafana_ini']['analytics'] = {}
default['grafana_ini']['security'] = {}
default['grafana_ini']['security']['admin_user'] = 'admin'
default['grafana_ini']['security']['admin_password'] = 'admin'
default['grafana_ini']['snapshots'] = {}
default['grafana_ini']['users'] = {}
default['grafana_ini']['auth'] = {}
default['grafana_ini']['auth.anonymous'] = {}
default['grafana_ini']['auth.github'] = {}
default['grafana_ini']['auth.google'] = {}
default['grafana_ini']['auth.generic_oauth'] = {}
default['grafana_ini']['auth.grafana_com'] = {}
default['grafana_ini']['auth.proxy'] = {}
default['grafana_ini']['auth.basic'] = {}
default['grafana_ini']['auth.ldap'] = {}
default['grafana_ini']['smtp'] = {}
default['grafana_ini']['emails'] = {}
default['grafana_ini']['log'] = {}
default['grafana_ini']['log.console'] = {}
default['grafana_ini']['log.file'] = {}
default['grafana_ini']['log.syslog'] = {}
default['grafana_ini']['event_publisher'] = {}
default['grafana_ini']['dashboards.json'] = {}
default['grafana_ini']['alerting'] = {}
default['grafana_ini']['metrics'] = {}
default['grafana_ini']['metrics.graphite'] = {}
default['grafana_ini']['tracing.jaeger'] = {}
default['grafana_ini']['grafana_com'] = {}
default['grafana_ini']['external_image_storage'] = {}
default['grafana_ini']['external_image_storage.s3'] = {}
default['grafana_ini']['external_image_storage.webdav'] = {}
default['grafana_ini']['external_image_storage.gcs'] = {}
default['grafana_ldap']['host'] = '127.0.0.1'
default['grafana_ldap']['port'] = 389
default['grafana_ldap']['use_ssl'] = false
default['grafana_ldap']['start_tls'] = false
default['grafana_ldap']['ssl_skip_verify'] = false
default['grafana_ldap']['root_ca_cert'] = nil
default['grafana_ldap']['bind_dn'] = 'cn=admin,dc=grafana,dc=org'
default['grafana_ldap']['bind_password'] = 'grafana'
default['grafana_ldap']['search_filter'] = '(cn=%s)'
default['grafana_ldap']['search_base_dns'] = '["dc=grafana,dc=org"]'
default['grafana_ldap']['group_search_filter'] = nil
default['grafana_ldap']['group_search_filter_user_attribute'] = nil
default['grafana_ldap']['group_search_base_dns'] = nil
default['grafana_ldap']['servers.attributes']['name'] = 'givenName'
default['grafana_ldap']['servers.attributes']['surname'] = 'sn'
default['grafana_ldap']['servers.attributes']['username'] = 'cn'
default['grafana_ldap']['servers.attributes']['member_of'] = 'memberOf'
default['grafana_ldap']['servers.attributes']['email'] = 'email'
default['grafana_ldap']['servers.group_mappings'] = [
  {
    'group_dn' => 'cn=admins,dc=grafana,dc=org',
    'org_role' => 'Admin',
    'org_id' => nil,
  },
  {
    'group_dn' => 'cn=users,dc=grafana,dc=org',
    'org_role' => 'Editor',
    'org_id' => nil,
  },
  {
    'group_dn' => '*',
    'org_role' => 'Viewer',
    'org_id' => nil,
  },
]
default['helm']['version'] = '2.0.0-1'
default['grafana']['version'] = '5.1.3-1'
