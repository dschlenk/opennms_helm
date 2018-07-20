# CHANGELOG for opennms_helm

This file is used to list changes made in each version of opennms_helm.

## 1.0.0

### New Features

- Use public grafana cookbook to manage installation and configuration of grafana
- Allow creation of datasources against multiple instances of OpenNMS
- Attempt to use Chef search to find OpenNMS instances from which to create datasources.

### Breaking Changes

- The prior release only supported a single OpenNMS host for datasources. These were named `opennms-$TYPE`, where `$TYPE` was one of `flow`, `performance`, or `fault`. These datasources will continue to exist but new datasources with the new naming convention - `opennms-$TYPE-$HOST` - will also be added. Any dashboards created using the old format should be updated before removing the old datasources. Removal via Chef is possible (if using Chef < 14 until [#195](https://github.com/sous-chefs/grafana/pull/195)) with a block like:

```
%w(performance fault flow).each do |type|
  grafana_datasource "opennms-#{flow}" do
    action :delete
  end
end
```

## 0.1.0

- Initial release
