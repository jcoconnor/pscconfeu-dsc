# Plan to bootstrap puppet
plan puppet::bootstrap_puppet(String $nodes) {
  $node_list = split($nodes, ',')

  run_task(puppet::install_choco, $node_list)

  run_task(puppet::install_puppet, $node_list)
}
