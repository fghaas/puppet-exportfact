define exportfact::import (
) {

  $category = $name

  $categoryfile = "$exportfact::factsdir/$category.txt"

  ensure_resource('file',
                  "$categoryfile",
                  { owner => "root",
                    group => "root",
                    mode => "0640" }) 

  Augeas <<| tag == "fact_$category" |>> {
  }
}
