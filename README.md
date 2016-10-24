# mysqld cookbook

Manage your mysqld servers with this cookbook.
Unlike the official [opscode mysql cookbook](https://github.com/opscode-cookbooks/mysql),
it doesn't mess with the default mysql configuration. If you do not specify anything explicitly, the
defaults of your distribution will be used.
(At least if I do not mess up - Check the
[default attributes](https://github.com/chr4/chef-mysqld/blob/master/attributes/defaults.rb),
if unsure (and file a pull request if you need to correct anything))

Features

* Defaults to OS settings unless explicitly specified otherwise
* Supports **all** my.cnf settings

## Compatibility
This cookbook is currently tested on Ubuntu 16.04. It should work on other Ubuntu/ Debian systems as well, as long as a compatible database version is used (e.g. `>= mysql-5.7.6` or `>= mariadb-10.1`).

For older database versions, it might be required to adapt some of the `my.cnf` attributes. Furthermore, the `mysqld_password` provider only works with the mentioned compatible databases. In case you need to use `mysqld_password` with older versions (e.g. `< mysql-5.7.6`), you need to version-lock this cookbook to `1.0.5`. This can be achieved by putting the following in your `Berksfile`:

```ruby
cookbook 'mysqld', '~> 1.0'
```

**Note: The support for RHEL was dropped with version `v2.2.0`, pull-requests are welcome!**

[Contributions](https://github.com/chr4/chef-mysqld#contributing) to support other systems are very
welcome!

## Requirements

You need to add the following line to your metadata.rb

    depends 'mysqld'


## Attributes

### Configuration

Everything in your my.cnf can be maintained using attributes.
Consider using the provides LWRPs (see below)

If you do not specify anything, the defaults of your os will be used.

This recipe supports **every** setting in the my.cnf.  All your settings will be merged with the
systems default, and then written to the my.cnf config file. The packages to install, the path to
my.cnf as well as the name of the service are set automatically, and can be overwritten using the
following attributes:


```ruby
node['mysqld']['my.cnf_path']
node['mysqld']['service_name']
node['mysqld']['mysql_packages']          # When node['mysqld']['use_mariadb'] == false
node['mysqld']['mariadb_packages']
node['mysqld']['mariadb_galera_packages'] # When using mariadb_galera_install recipe
```

The configuration is stored in the ```node['mysqld']['my.cnf']``` hash, and can be adapted like so


```ruby
# node['mysqld']['my.conf'][<category>][<key>] = <value>
node['mysqld']['my.cnf']['mysqld']['bind-address'] = '0.0.0.0'
```

This will expand to the following in your config file (leaving all other settings untouched)

```
[mysqld]
bind-address = 0.0.0.0
```

To remove a default option, you can pass `false` or `nil` as the value

```ruby
# Remove deprecated innodb option
default['mysqld']['my.cnf']['mysqld']['innodb_additional_mem_pool_size'] = false
```

As the configuration file is constructed from the config hash, every my.cnf configuration option is
supported.


```ruby
node['mysqld']['root_password'] = 'yourpass'
```



## Recipes

### default

- Setup official MariaDB repository
- Install MariaDB server
- Configure MariaDB server according to the attributes. If no attributes are given, stick with the
  systems default


### mariadb\_repository

Sets up official MariaDB repository to install packages from.
Configure it using the following attributes

```ruby
node['mysqld']['repository']['version'] # Defaults to '10.1'
node['mysqld']['repository']['mirror']  # Defaults to HostEurope mirror
```

### install

Install mariadb/ mysql packages (according to attributes, defaults to `mariadb-server`)

### configure

Configure mysql according to attributes. Sets the databases root account (resp. debian-sys-maint on
Debian/Ubuntu systems) to use the password in `node['mysqld']['root_password']`, if the attribute is
set.

### mariadb\_galera\_init

Run `mariadb_repository` and `mariadb_galera_install` recipes, then configure as the `configure`
recipe would do, but start mariadb with `--wsrep-new-cluster --wsrep_cluster_address=gcomm://` to
initialize a new Galera cluster.

Use this if you want to setup a new Galera cluster, and run it on your first node once:

```bash
$ sudo chef-client --once -o 'recipe[mysqld::mariadb_galera_init]'
```

Once you connected the other nodes using the regular recipes, re-run chef-client as you did on the
other servers.

*Note: If you use a wrapper cookbook to configure your instances, attributes might not be available
when running the recipe with `-o recipe[]`. Create a mariadb_galera_init recipe in your wrapper
cookbook, calling this recipe if you have trouble.*


## Providers

### mysqld

You can configure your database also using the `mysqld` provider:


```ruby
include_recipe 'mysqld::mariadb_galera_install'

# Name attribute will be ignored. Choose something that makes sense for you
mysqld 'galera' do
  my_cnf { 'bind-address' => '0.0.0.0' }
end
```

### password

You can set passwords (incl. root and debian-sys-maint accounts) using this provider.
By default, the provider uses the created root/debian-sys-maint accounts depending on the system you
are on.

```ruby
mysqld_password 'root' do
  password 'get_from_data_bag_maybe?'

  # If required, you can specify your own auth-scheme here
  # auth '-u specialuser -pmypass'
end
```


# Contributing

Contributions are very welcome!

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


# License and Authors

Authors: Chris Aumann <me@chr4.org>

License: GPLv3
