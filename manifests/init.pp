class exportfact {

  $facterdir_win = 'C:/ProgramData/PuppetLabs/facter'
  $facterdir_lin = $puppetversion ? {
    /Enterprise/ => '/etc/puppetlabs/facter',
    default      => '/etc/facter'
  }

  $factsdir_win = "$facterdir_win/facts.d"
  $factsdir_lin = "$facterdir_lin/facts.d"

  if $facts['os']['family'] == 'windows' {
    ensure_resource(file, 
                    $facterdir_win, 
                    { ensure => directory })
  
    ensure_resource(file, 
                    "$factsdir_win",
                    { ensure => directory,
                      require => File[$facterdir_win] })
  } else {
    ensure_resource(file, 
                    $facterdir_lin, 
                    { ensure => directory })
  
    ensure_resource(file, 
                    "$factsdir_lin",
                    { ensure => directory,
                      require => File[$facterdir_lin] })
  }
}
