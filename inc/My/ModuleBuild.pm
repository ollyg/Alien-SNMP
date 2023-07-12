package My::ModuleBuild;

use strict;
use warnings;

use parent 'Alien::Base::ModuleBuild';

if ($^O eq 'MSWin32') {
  print "OS not supported\n";
  exit;
}

sub alien_check_installed_version { return }
#sub alien_check_installed_version { `snmpstatus --version 2>&1 | awk '{print \$NF}'` }
sub alien_check_built_version { return '5.9.3' }

1;
