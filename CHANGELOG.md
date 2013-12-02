mysqld CHANGELOG
================

This file is used to list changes made in each version of the mysqld cookbook.

0.2.0
-----
- [Chris Aumann] - Do not manage service\_name, when service\_name is empty
                 - Fixes an issue with the template when the LWRP was called from another cookbook
                 - Use deep_merge to merge my.cnf hashes

0.1.0
-----
- [Chris Aumann] - Initial release of mysqld
