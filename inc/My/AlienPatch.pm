package My::AlienPatch;

use strict;
use warnings;
use Tie::File;

sub main::alien_patch {
  my $text = "\nuse Alien::SNMP;\n";
  tie my @lines, 'Tie::File', 'perl/SNMP/SNMP.pm'
    or die "can't open devnull: $!";
  for (@lines) {
    if (/use warnings;/) {
      $_ .= $text;
      last;
    }
  }
}

1;
