define exportfact::import (
) {

  $category = $name

  $categoryfile = "$exportfact::factsdir/$category.txt"

  ensure_resource('file', "$categoryfile")

  Augeas <<| tag == "fact_$category" |>> {
  }
}
