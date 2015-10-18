#!/usr/bin/env perl

use strict;
use warnings;
use 5.010001;
use utf8;

use lib 'inc';
use My::ModuleBuild;

my $conf_cmd = [
  '%c',                     '--with-pic',
  '--prefix=%s',            '--disable-agent',
  '--disable-applications', '--disable-manuals',
  '--disable-scripts',      '--disable-mibs',
  '--enable-ipv6',          '--with-mibs=""',
  '--with-perl-modules',    '--disable-embedded-perl',
  '--with-defaults',
];

my %module_build_args = (
  alien_autoconf_with_pic => 0,
  alien_build_commands    => [$conf_cmd, 'make'],

  # Not using FFI, default_store library only dynamic and needed for XS
  alien_isolate_dynamic => 0,
  alien_name            => 'netsnmp',

  # Headers referenced as net-snmp/xxx.h, autodiscovery appends net-snmp
  alien_provides_cflags => '-I${pcfiledir}/include',
  alien_provides_libs   => '-lnetsnmp',
  alien_repository      => {
    protocol       => 'http',
    host           => 'sourceforge.net',
    location       => '/projects/net-snmp/files/net-snmp/5.7.3/',
    exact_filename => 'net-snmp-5.7.3.tar.gz',
  },
  alien_stage_install => 1,
  build_requires      => {},
  configure_requires  => {
    "Alien::Base"        => '0.020',
    "ExtUtils::CChecker" => '0.10',
    "File::ShareDir"     => '1.03',
    "Module::Build"      => '0.42',
    "perl"               => '5.010001'
  },
  create_license    => 1,
  create_readme     => 1,
  dist_abstract     => 'Build and install Net-SNMP',
  dist_author       => 'Eric A. Miller <emiller AT cpan DOT org>',
  dist_name         => 'Alien-SNMP',
  dist_version_from => 'lib/Alien/SNMP.pm',
  license           => 'bsd',
  module_name       => "Alien::SNMP",
  recommends        => {},
  requires          => {
    "Alien::Base"    => '0.020',
    "File::ShareDir" => '1.03',
    "parent"         => 0,
    "perl"           => '5.010001'
  },
  test_requires =>
    {"Test::CChecker" => 0, "Test::More" => '0.94', "perl" => '5.010001'},

);

my %fallback_build_requires
  = ("Test::CChecker" => 0, "Test::More" => '0.94', "perl" => '5.010001');

unless (eval { Module::Build->VERSION(0.4004) }) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $builder = My::ModuleBuild->new(%module_build_args);

$builder->create_build_script;
