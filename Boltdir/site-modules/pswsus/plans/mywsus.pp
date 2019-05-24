plan pswsus::mywsus(
  String $base_node_name,
) {
  apply ('localhost') {
    class { 'pswsus::mywsus':
      base_node_name =>  $base_node_name,
    }
  }
}
