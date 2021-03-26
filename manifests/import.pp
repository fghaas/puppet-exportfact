define exportfact::import (
) {

  $category = $name

  if $facts['os']['family'] == 'windows' {
    $categoryfile = "$exportfact::factsdir_win/$category.txt"
    $file_defaults = {}
    file {$categoryfile:
      ensure => 'file',
    }
  } else {
    $categoryfile = "$exportfact::factsdir_lin/$category.txt"
    $file_defaults = { owner => "root",
                    group => "root",
                    mode => "0640" }

    ensure_resource('file',
                  "$categoryfile",
                  $file_defaults) 
  }

  if $facts['os']['family'] == 'windows' {
    File_line <<| tag == "fact_$category" and tag == "${facts['os']['family']}" |>> { }
  } else {
    Augeas <<| tag == "fact_$category" and tag == "${facts['os']['family']}" |>> { }
  }
}
