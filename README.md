# opennms-helm

This cookbook allows you to manage the installation and configuration of Grafana + OpenNMS Helm with Chef.

## Requirements

* CentOS 6 or 7
* An OpenNMS system, ideally managed with the [OpenNMS Chef cookbook](https://github.com/dschlenk/opennms-cookbook), potentially on the same Chef node.
* Chef >= 12.14
* A yum repository that contains the Helm RPM.

## Usage

The easiest way to deploy is to add this cookbook's default recipe to a Chef node that already has the OpenNMS managed by Chef. Continue reading for additional options, however.

### Prerequisites

#### Yum Repo

If you'd like to manage the yum repo that contains the Helm RPM in it with Chef, include the `opennms::repositories` recipe in your node's run list.

#### OpenNMS Server Attributes

When not adding the default recipe to a node that also has OpenNMS managed by Chef, you need to set some additional node attributes. Set the following node attributes (via role, environment, wrapper cookbook, etc):

* `node['opennms']['host']`
* `node['opennms']['properties']['jetty']['port']`
* `node['opennms']['secure_admin_password']`

### Advanced Options

#### Tweaking Grafana

##### grafana.ini
Any option in the Grafana ini file can be changed with node attributes. For example, to change the temp data lifetime to 48 hours, you would set this node attribute:

```
node['grafana_ini']['paths']['temp_data_lifetime'] = '48h'
```

This would result in the `[paths]` section of the ini file looking something like:
```
[paths]
temp_data_lifetime = '48h'
```
Each ini section has a Chef mash key in `attributes/default.rb`. (Future versions of Grafana will likely introduce additional ini sections (or remove some of the existing ones), but you can easily override these to fit whatever version of Grafana you want to use).

##### ldap.toml

If you'd like to use LDAP for authentication you can customize the ldap.toml file provided with Grafana. See `attributes/default.rb` for defaults. Note that you will need to set one or more node attributes to modify the ini file for this to do anything:

```
node['grafana_ini']['auth.ldap']['enabled'] = true
node['grafana_ini']['auth.ldap']['enabled'] = true
`

Configuration of LDAP via node attributes is similar to grafana.ini however the base template contains a bit more static content. See `templates/default/ldap.toml.erb` along with the default values under the `grafana_ldap` key in `attributes/default.rb` for more details along with [Grafana's docs on LDAP authentication](http://docs.grafana.org/installation/ldap/) for more information. 

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

FAQs
====

Q: Why aren't you using the [grafana cookbook](https://github.com/sous-chefs/grafana) to install Grafana?
A: I don't have a particularly good reason. In fact, the next release most likely will use that cookbook to handle the installation of Grafana and will also let you decide if you want to handle installation of grafana on your own (with your own wrapper or whatnot).

Q: Who is using this?
A: Right now, mostly tests in the main OpenNMS cookbook, but once refactored to use the Grafana cookbook it should prove quite useful for anyone that wants to use Helm.

Q: Can I do multiple OpenNMS data sources?
A: Not yet. After the refactor, yes.
