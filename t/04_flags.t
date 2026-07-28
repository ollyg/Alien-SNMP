use strict;
use warnings;
use Test::More;
use Alien::SNMP;

# Guards the DESTDIR/staging and cflags/libs relocatability class of bug: the
# compiler/linker flags this Alien advertises must point at directories and
# files that actually exist in the share, not at a stale or mis-staged prefix.

my @include_dirs = Alien::SNMP->cflags =~ /-I(\S+)/g;
my @lib_dirs     = Alien::SNMP->libs   =~ /-L(\S+)/g;

ok scalar(@include_dirs), 'cflags__share_build__advertises_an_include_dir';
ok scalar(@lib_dirs),     'libs__share_build__advertises_a_lib_dir';

for my $include_dir (@include_dirs) {
    ok -d $include_dir, "cflags__share_build__include_dir_exists ($include_dir)";
}

ok -e "$include_dirs[0]/net-snmp/net-snmp-config.h",
  'cflags__share_build__points_at_real_netsnmp_headers';

# net-snmp lists snmpIPBaseDomain.h among the transport headers to install but ships
# it under snmplib/transports/, outside the tree the install rule reads from.  GNU
# make swallows the resulting `install` failure, so the header just goes missing;
# BSD and Solaris make abort the whole build.  The alienfile stages the header before
# configure runs, and a complete header set is the observable proof that it worked.
ok -e "$include_dirs[0]/net-snmp/library/snmpIPBaseDomain.h",
  'cflags__share_build__installs_every_configured_transport_header';

for my $lib_dir (@lib_dirs) {
    ok -d $lib_dir, "libs__share_build__lib_dir_exists ($lib_dir)";
}

ok scalar(glob "$lib_dirs[0]/libnetsnmp.*"),
  'libs__share_build__contains_a_libnetsnmp';

done_testing;
