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

# ABSTRACT: Code shared by the DB reader and writer modules

__END__

=head1 DESCRIPTION

This first release is being done for the sake of the L<GeoIP2> package. Real
documentation for this distro is forthcoming.
