# Define: ssh_keygen
# Parameters:
# $home
#
define ssh_keygen($ensure = present, $home=undef, $key_path=undef, $user='root', $comment='puppet generated key') {

  Exec { path => '/bin:/usr/bin' }

  if $home != undef and $key_path != undef {
    fail('You must provide one of $home or $key_path, not both.')
  }

  if $key_path != undef {
    $key_path_real = $key_path
  } else {
    $home_real = $home ? {
      undef =>  "/home/${user}",
      default => $home
    }
    $key_path_real = "${home_real}/.ssh/id_rsa"
  }
  if $ensure == present {
    exec { "ssh_keygen-${name}":
      command => "ssh-keygen -f \"${key_path_real}\" -N '' -C \"${comment}\"",
      user    => $user,
      creates => "${key_path_real}",
    }
  } 
  if $ensure == absent {
    file {
      [$key_path_real, "${key_path_real}.pub"]:
        ensure => absent
    }
  }
}
