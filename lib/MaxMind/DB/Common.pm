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

use constant {
    LEFT_RECORD                 => 0,
    RIGHT_RECORD                => 1,
    DATA_SECTION_SEPARATOR_SIZE => 16,
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
    %TypeNumToName
    %TypeNameToNum
);

1;

# ABSTRACT: Code shared by the DB reader and writer modules

__END__

=head1 DESCRIPTION

This first release is being done for the sake of the L<GeoIP2> package. Real
documentation for this distro is forthcoming.
