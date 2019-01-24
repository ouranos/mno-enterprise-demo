# Maestrano Enterprise Demo

Generic mno-enterprise express project

| branch | status |
| ------ | ------ |
| [master](https://github.com/maestrano/mno-enterprise-demo/tree/master) | [![Build Status](https://travis-ci.org/maestrano/mno-enterprise-demo.svg?branch=master)](https://travis-ci.org/maestrano/mno-enterprise-demo) |
| [develop](https://github.com/maestrano/mno-enterprise-demo/tree/develop) | [![Build Status](https://travis-ci.org/maestrano/mno-enterprise-demo.svg?branch=develop)](https://travis-ci.org/maestrano/mno-enterprise-demo) |

## Getting started

Update `config/settings/development.yml` and `config/application.yml` with the configuration you've been provided with.


```
$ bundle
$ foreman start
```

Open http://localhost:7000/ in your browser

## What's in it?

* Generic mno-enterprise host project, generated using the [rails app template](https://github.com/maestrano/mno-enterprise/tree/master/rails-template)
* [Custom fonts](https://github.com/maestrano/mno-enterprise#adding-a-custom-font)

## Upgrading

```
# Update mno-enterprise
bundle update mno-enterprise

# Rebuild the admin-frontend
rm -rf tmp/build tmp/cache
bin/rake mnoe:admin:dist
bin/rake mnoe:frontend:update
```
