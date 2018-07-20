# opennms-helm

This cookbook allows you to manage the installation and configuration of Grafana + OpenNMS Helm with Chef.

## Requirements

* CentOS 6 or 7
* An OpenNMS system, ideally managed with the [OpenNMS Chef cookbook](https://github.com/dschlenk/opennms-cookbook), potentially on the same Chef node.
* Chef >= 12.14

## Usage

### Quick Start

The easiest way to deploy is to add this cookbook's default recipe to a Chef node that can search for a node (potentially itself) that is running OpenNMS already and is managed by Chef.  

### Package and Version Options

By default the public [grafana cookbook](https://github.com/sous-chefs/grafana) is used to install Grafana. Refer to that cookbook's documentation for options to control Grafana including selecting a specific version, changing values in the ini file, using LDAP for authentication, etc. The attributes specified in this cookbook select a version of Grafana that is known to work with the version of the OpenNMS Helm plugin at the time of release, but newer releases may exist. To change the Grafana version, set this node attribute: `node['grafana']['package']['version']`. To change the Helm version, set this node attribute: `node['helm']['version']`.

If for some strange reason you'd rather manage the grafana installation and configuration yourself, simply change `node['helm']['manage_grafana']` to false. This cookbook will still install the helm package and attempt to set up datasources for your OpenNMS instance(s).

### OpenNMS Datasources

Helm needs some OpenNMS fault, performance and flow datasources to operate. The default method by which OpenNMS instances are found to create these datasources is through a Chef search query for nodes that have the opennms default recipe in its recipes list. You can modify that behavior with the node attribute `node['helm']['instance_search']`.

By default performance, fault and flow datasources are created for each OpenNMS instance found or specified. You can modify that with the node attribute `node['helm']['datasource_types']`.

### Manually Specify OpenNMS Instances

You can manually specify the OpenNMS instance(s) you want to use as your datasources rather than using the default Chef search query method. To do so, populate the node attribute `node['opennms']['instances']` similarly to:

```
default['opennms']['instances']['localhost']['port'] = 8980
default['opennms']['instances']['localhost']['username'] = 'admin'
default['opennms']['instances']['localhost']['password'] = 'admin'
```

### Manage Organizations

If you'd like to manage Grafana organiztions you can do so by adding node attributes under `node['helm']['organizations']`. For example, the default attributes include the 'Main Org.' organization (which is included with Grafana OOTB):

```
default['helm']['organizations']['Main Org.']['name'] = 'Main Org.'
```

A future version of this cookbook may allow you to manage users as well, but for now management of organizations is probably only useful when using LDAP for authentication.

### Dashboards

This cookbook does not attempt to manage dashboards at this time. At the time of writing, Helm ships with an example dashboard called 'Flow Deep Dive'. You can use the `grafana_dashboard` resource in your own wrapper to deploy additional dashboards.

## License
Apache 2.0

## Author
David Schlenk (<dschlenk@convergeone.com>)

Development
===========

This cookbook uses common ChefDK tools for testing like test kitchen, inspec, ChefSpec, foodcritic, and cookstyle.

The default rake task will run the style, lint and unit tests.

Use `rake integration:vagrant` to run the integration tests. 

Pull requests welcome!
