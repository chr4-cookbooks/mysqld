mysqld CHANGELOG
================

This file is used to list changes made in each version of the mysqld cookbook.

2.2.0
-----

- Duplicate `my.cnf` config settings when merging with defaults, fixes Chef 13 error

2.1.0
-----

- Fix repository keys for older Ubuntu releases

2.0.0
-----

- Drop support for RHEL, pull-requests apprechiated!
  In case you are using RHEL, make sure to version-lock this cookbook to `~> 1.0.5` e.g. in your Berksfile
- Drop support for `mysql-server-5.6` (Ubuntu 14.04). Migrate to MariaDB, or version-lock this cookbook to `~> 1.0.5` e.g. in your Berksfile
- Bump default mariadb version to `10.1`
- Adapt default attributes for `mysql-5.7` and `mariadb-10.1`
- Remove workaround for deprecated Ubuntu 13.10
- Add `node['mysqld']['use_mariadb']` attribute, default to true
- Replace `mysqld::install_mariadb` and `mysqld::install_mysql` recipes with `mysqld::install``
- Rename `mysqld::mariadb_apt_repository` to `mysqld::mariadb_repository`
- Use `authentication_string` table when changing passwords

1.0.5
-----

- Update mariadb repository key

1.0.4
-----

- Fix attribute typo in `mysqld::mariadb_install` recipe

1.0.3
-----

- Use Upstart provider only on Ubuntu 13.10

1.0.2
-----

- Restart service immediately when my.cnf is updated

1.0.1
-----

- Do not force presence of `password` attribute

1.0.0
-----

- Add support for mariadb
- Add support for mariadb-galera
- Automatically set admin passwords if attribute is given (incl. modifying `/etc/mysql/debian.cnf`
  accordingly, if required)

Compatibility changes:

- Rename `node['mysqld']['packages']` attribute to `node['mysqld']['mysql_packages']`

0.3.0
-----

- Add support to remove configuration options set by default attributes

0.2.0
-----
- Do not manage `service_name`, when `service_name` is empty
- Fixes an issue with the template when the LWRP was called from another cookbook
- Use `deep_merge` to merge my.cnf hashes

0.1.0
-----
- Initial release of mysqld
