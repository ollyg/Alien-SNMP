package My::ModuleBuild;

use strict;
use warnings;
use 5.010001;
use parent 'Alien::Base::ModuleBuild';
use Config;
use ExtUtils::CChecker;
use Capture::Tiny qw( capture );

if ($^O eq 'MSWin32') {
  print "OS not supported\n";
  exit;
}

sub alien_check_installed_version {
  my ($self) = @_;

  my $cc = ExtUtils::CChecker->new(
    quiet  => 1,
    config => {libs => "$Config{libs} -lnetsnmp"},
  );

  $cc->push_extra_linker_flags('-lnetsnmp');

  my ($version, undef, $ok) = capture {

    $cc->try_compile_run(
      source => <<'EOF',
#include <stdio.h>
#include <net-snmp/net-snmp-config.h>
#include <net-snmp/version.h>

int
main(int argc, char *argv[])
{
  printf("%s", netsnmp_get_version());
  return 0;
}
EOF
    );
  };

  return unless $ok;
  return if !defined $version || $version ne '5.7.3';

  return $version;
}

sub alien_check_built_version {
  my ($self) = @_;
  return '5.7.3';
}

1;
