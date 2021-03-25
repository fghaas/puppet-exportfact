define exportfact::export (
  $value,
  $category = "fact",
) {

  $categoryfile_win = "$exportfact::factsdir_win/$category.txt"
  $categoryfile_lin = "$exportfact::factsdir_lin/$category.txt"

  if $facts['os']['family'] == 'windows' {
    file {"$categoryfile_win":
      ensure => 'file',
    }
  } else {
    ensure_resource('file',
                    "$categoryfile_lin",
                    { owner => "root",
                      group => "root",
                      mode => "0640" }) 
  }

  @@augeas { "fact_${name}_lin":
    context => "/files$categoryfile_lin",
    incl => "$categoryfile_lin",
    lens => "Shellvars.lns",
    changes => "set $name $value",
    require => [Class['exportfact'],File[$categoryfile_lin]],
    tag => ["fact_$category","RedHat"],
  }

  @@file_line { "fact_${name}_win":
    path => "$categoryfile_win",
    line => "$name=$value",
    match => "^$name=",
    require => [Class['exportfact'],File[$categoryfile_win]],
    tag => ["fact_$category","windows"],
  }

}
