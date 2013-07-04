class exportfact {

  $facterdir = $puppetversion ? {
    /Enterprise/ => '/etc/puppetlabs/facter',
    default      => '/etc/facter'
  }
  ensure_resource(file, 
                  $facterdir, 
                  { ensure => directory })

  $factsdir = "$facterdir/facts.d"
  ensure_resource(file, 
                  "$factsdir",
                  { ensure => directory,
                    require => File[$facterdir] })
}
