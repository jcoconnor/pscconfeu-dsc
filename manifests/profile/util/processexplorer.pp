class profile::util::processexplorer {

	include ::chocolatey
	include ::archive

	# The zipfile doesn't create a directory, so we need to create it here.
	file { ['C:/temp', 'C:/temp/processexplorer']:
		ensure => directory,
    before => Archive['C:/temp/processexplorer.zip'],
	}

	archive { 'C:/temp/processexplorer.zip':
	  source       => 'C:/SoftwareDist/ProcessExplorer.zip',
	  extract      => true,
	  extract_path => 'C:/temp/processexplorer',
	  creates      => 'C:/temp/processexplorer/procexp.exe',
	  cleanup      => false,
	}

	file { "${::system32}/procexp.exe":
		ensure  => file,
		source  => 'C:/temp/processexplorer/procexp.exe',
		require => Archive['C:/temp/processexplorer.zip'],
	}
	# Comment to force push
	# Another comment
}
