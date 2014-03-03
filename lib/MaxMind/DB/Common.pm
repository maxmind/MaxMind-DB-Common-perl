package MaxMind::DB::Common;

use strict;
use warnings;

# This is a hack to let us test code that requires a specific
# MaxMind::DB::Common version against the MaxMind-DB-Common git repo code, but
# without actually setting the $VERSION variable.
BEGIN {
    $MaxMind::DB::Common::{VERSION} = \99
        unless exists $MaxMind::DB::Common::{VERSION};
}

my $separator_size;

BEGIN {
    $separator_size = 16;
}

use constant {
    LEFT_RECORD                 => 0,
    RIGHT_RECORD                => 1,
    DATA_SECTION_SEPARATOR_SIZE => $separator_size,
    DATA_SECTION_SEPARATOR      => ( "\0" x $separator_size ),
    METADATA_MARKER             => "\xab\xcd\xefMaxMind.com",
};

use Exporter qw( import );

our %TypeNumToName = (
    0  => 'extended',
    1  => 'pointer',
    2  => 'utf8_string',
    3  => 'double',
    4  => 'bytes',
    5  => 'uint16',
    6  => 'uint32',
    7  => 'map',
    8  => 'int32',
    9  => 'uint64',
    10 => 'uint128',
    11 => 'array',
    12 => 'container',
    13 => 'end_marker',
    14 => 'boolean',
    15 => 'float',
);

our %TypeNameToNum = reverse %TypeNumToName;

our @EXPORT_OK = qw(
    LEFT_RECORD
    RIGHT_RECORD
    DATA_SECTION_SEPARATOR_SIZE
    DATA_SECTION_SEPARATOR
    METADATA_MARKER
    %TypeNumToName
    %TypeNameToNum
);

1;

# ABSTRACT: Code shared by the MaxMind DB reader and writer modules

__END__

=head1 DESCRIPTION

This distribution provides some shared code for use by both the MaxMind DB
reader and writer Perl modules.

For now, the only piece documented for public consumption is
L<MaxMind::DB::Metadata>.

=head1 VERSIONING POLICY

This module uses semantic versioning as described by
L<http://semver.org/>. Version numbers can be read as X.YYYZZZ, where X is the
major number, YYY is the minor number, and ZZZ is the patch number.

=head1 SUPPORT

Please report all issues with this code using the GitHub issue tracker at
L<https://github.com/maxmind/MaxMind-DB-Common-perl/issues>.
