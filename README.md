Cookbook raspberry_bakery
============================

https://github.com/Demonsthere/raspberry-packer_scripts

## Description

Brief description of your cookbook

## Requirements

To install dependencies (gems + cookbooks), just run

```
gem install bundler
bundle install
bundle exec berks install
```

### Platforms

 - RHEL/CentOS

### Ruby

 - Ruby <version>
 - RVM <version>

### Chef

 - Chef 12.1+

### Cookbooks

 - List of cookbooks

## Attributes

In order to keep the README manageable and in sync with the attributes, this cookbook documents attributes inline. The usage instructions and default values for attributes can be found in the individual attribute files.

## CI/CD

 * Lint (foodcricit + rubocop) `bundle exec rake lint`
 * Unit tests (rspec) `bundle exec rake unit`
 * Integration tests (serverspec) `bundle exec rake integration`
 * All `bundle exec rake ci`

## License & Author(s)

 * Author: <Author>
 * Contributor: <Contributor>

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
