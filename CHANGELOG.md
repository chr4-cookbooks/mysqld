mysqld CHANGELOG
================

This file is used to list changes made in each version of the mysqld cookbook.

1.0.0
-----

-

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
