default['helm']['manage_grafana'] = true
default['helm']['version'] = '2.0.0-1'
default['helm']['datasource_types'] = %w(performance fault flow)
default['grafana']['install_type'] = 'package'
default['grafana']['package']['version'] = '5.1.3-1'
default['grafana']['ini']['security']['admin_user'] = 'admin'
default['grafana']['ini']['security']['admin_password'] = 'admin'
default['grafana']['ini']['server']['http_port'] = 3000
default['helm']['organizations']['Main Org.']['name'] = 'Main Org.'
default['helm']['instance_search'] = 'recipes:"opennms"'
