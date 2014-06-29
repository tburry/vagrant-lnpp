# Class: provision::nginx::vhosts
#
#
class provision::nginx::vhosts
{
  $sites_dir = $core::params::sites_dir
  $nginx_dir = "${core::params::templates_dir}/nginx"

  file { "error_pages.conf":
    ensure => file,
    path => "/etc/nginx/error_pages.conf",
    source => "${nginx_dir}/error_pages.conf",
    require => Package["nginx"]
  }

  file { "fastcgi.conf":
    ensure => file,
    path => "/etc/nginx/fastcgi.conf",
    # source => template("${nginx_dir}/fastcgi.conf.erb"),
    source => "${nginx_dir}/fastcgi.conf",
    require => Package["nginx"]
  }

  file { "upstreams.conf":
    ensure => file,
    path => "/etc/nginx/conf.d/upstreams.conf",
    source => "${nginx_dir}/upstreams.conf",
    require => Package["nginx"]
  }

  nginx::vhost { "default":
    root     => "${sites_dir}/default",
    index    => "index.php",
    template => "${nginx_dir}/default.conf.erb"
  }

  nginx::vhost { "hhvm":
    root     => "${sites_dir}/default",
    index    => "index.php",
    template => "${nginx_dir}/hhvm.conf.erb"
  }

  # Pre-defined setups
  # nginx::vhost { "vanilla.dev":
  #   root        => "${sites_dir}/vanilla",
  #   index       => "index.php",
  #   template   => "${nginx_dir}/vanilla.conf.erb"
  # }

  define nginx::vhost::vanilla (
    $host        = "$title",
    $php_server  =  "php_fpm",
    $root        =  "${core::params::sites_dir}/vanilla"
  ) {
    nginx::vhost { $host:
      root        => $root,
      index       => "index.php",
      template    => "${provision::nginx::vhosts::nginx_dir}/vanilla.conf.erb"
    }
  }

  nginx::vhost::vanilla { "vanilla.dev":
    php_server  => "php_fpm"
  }

  nginx::vhost::vanilla { "vanilla.hhvm":
    php_server  => "php_hhvm"
  }

  # nginx::vhost { "kirby":
  #   root     => "${sites_dir}/kirby",
  #   index    => "index.php",
  #   template => "${nginx_dir}/kirby.conf.erb"
  # }

  # nginx::vhost { "statamic":
  #   root     => "${sites_dir}/statamic",
  #   index    => "index.php",
  #   template => "${nginx_dir}/statamic.conf.erb"
  # }
}
