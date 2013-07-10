define exportfact::export (
  $value,
  $category = "fact",
) {

  $categoryfile = "$exportfact::factsdir/$category.txt"

  ensure_resource('file',
                  "$categoryfile",
                  { owner => "root",
                    group => "root",
                    mode => "0640" }) 

  @@augeas { "fact_$name":
    context => "/files$categoryfile",
    incl => "$categoryfile",
    lens => "Shellvars.lns",
    changes => "set $name $value",
    require => [Class['exportfact'],File[$categoryfile]],
    tag => "fact_$category"
  }

}
