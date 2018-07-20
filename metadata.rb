name 'opennms_helm'
maintainer 'ConvergeOne'
maintainer_email 'dschlenk@convergeone.com'
license 'Apache-2.0'
description 'Installs/Configures OpenNMS Helm'
long_description 'Installs/Configures OpenNMS Helm'
version '1.0.0'
chef_version '>= 12.14' if respond_to?(:chef_version)
depends 'grafana', '~> 3.0'
supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'
issues_url 'https://github.com/dschlenk/opennms_helm/issues' if respond_to?(:issues_url)
source_url 'https://github.com/dschlenk/opennms_helm' if respond_to?(:source_url)
