## Sensu-Plugins-raid-checks

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-raid-checks.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-raid-checks)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-raid-checks.svg)](http://badge.fury.io/rb/sensu-plugins-raid-checks)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-raid-checks/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-raid-checks)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-raid-checks/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-raid-checks)
[ ![Codeship Status for sensu-plugins/sensu-plugins-raid-checks](https://codeship.com/projects/a8a17b00-dc04-0132-d98c-1e3fe125131b/status?branch=master)](https://codeship.com/projects/79860)

## Functionality

**check-3ware-status.rb**

**check-megaraid-sas-status.rb**

**check-raid-checks**

**check-smart-array-status.rb**

## Files

* bin/check-3ware-status.rb
* bin/check-megaraid-sas-status.rb
* bin/check-raid-checks
* bin/check-smart-array-status.rb

## Installation


Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install <gem> -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

`gem install sensu-plugins-raid-checks`

Add *sensu-plugins-raid-checks* to your Gemfile, manifest, cookbook, etc

## Notes