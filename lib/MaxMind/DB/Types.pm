package MaxMind::DB::Types;

use strict;
use warnings;

use Carp qw( confess );
use Exporter qw( import );
use List::AllUtils;
use Scalar::Util ();
use Sub::Quote qw( quote_sub );

our @EXPORT_OK = qw(
    ArrayRefOfStr
    Bool
    Decoder
    Epoch
    FileHandle
    HashRef
    HashRefOfStr
    Int
    MathUUInt128
    Metadata
    Str
);

{
    my $t = quote_sub(
        q{
(
           defined $_[0]
        && Scalar::Util::reftype( $_[0] ) eq 'ARRAY'
        && List::AllUtils::all(
        sub { defined $_ && !ref $_ },
        @{ $_[0] }
        )
    )
    or MaxMind::DB::Types::_confess(
    '%s is not an arrayref',
    $_[0]
    );
}
    );

    sub ArrayRefOfStr () { $t }
}

{
    my $t = quote_sub(
        q{
( !defined $_[0] || $_[0] eq q{} || "$_[0]" eq '1' || "$_[0]" eq '0' )
    or MaxMind::DB::Types::_confess(
    '%s is not a boolean',
    $_[0]
    );
}
    );

    sub Bool () { $t }
}

{
    my $t = _object_isa_type('MaxMind::DB::Reader::Decoder');

    sub Decoder () { $t }
}

{
    my $t = quote_sub(
        q{
(
    defined $_[0] && ( ( !ref $_[0] && $_[0] =~ /^[0-9]+$/ )
        || ( Scalar::Util::blessed( $_[0] )
            && ( $_[0]->isa('Math::UInt128') || $_[0]->isa('Math::BigInt') ) )
        )
    )
    or MaxMind::DB::Types::_confess(
    '%s is not an integer, a Math::UInt128 object, or a Math::BigInt object',
    $_[0]
    );
}
    );

    sub Epoch () { $t }
}

{
    my $t = quote_sub(
        q{
(          ( defined $_[0] && Scalar::Util::openhandle( $_[0] ) )
        || ( Scalar::Util::blessed( $_[0] ) && $_[0]->isa('IO::Handle') ) )
    or MaxMind::DB::Types::_confess(
    '%s is not a file handle',
    $_[0]
    );
}
    );

    sub FileHandle () { $t }
}

{
    my $t = quote_sub(
        q{
( defined $_[0] && Scalar::Util::reftype( $_[0] ) eq 'HASH' )
    or MaxMind::DB::Types::_confess(
    '%s is not a hashref',
    $_[0]
    );
}
    );

    sub HashRef () { $t }
}

{
    my $t = quote_sub(
        q{
(
           defined $_[0]
        && Scalar::Util::reftype( $_[0] ) eq 'HASH'
        && &List::AllUtils::all(
        sub { defined $_ && !ref $_ }, values %{ $_[0] }
        )
    )
    or MaxMind::DB::Types::_confess(
    '%s is not a hashref of strings',
    $_[0]
    );
}
    );

    sub HashRefOfStr () { $t }
}

{
    my $t = quote_sub(
        q{
( defined $_[0] && !ref $_[0] && $_[0] =~ /^[0-9]+$/ )
    or MaxMind::DB::Types::_confess(
    '%s is not a valid integer',
    $_[0]
    );
}
    );

    sub Int () { $t }
}

{
    my $t = quote_sub(
        q{
(
    defined $_[0] && ( ( !ref $_[0] && $_[0] =~ /^[0-9]+$/ )
        || ( Scalar::Util::blessed( $_[0] ) && $_[0]->isa('Math::UUInt128') ) )
    )
    or MaxMind::DB::Types::_confess(
    '%s is not a valid integer for an IP address',
    $_[0]
    );
}
    );

    sub IPInt () { $t }
}

{
    my $t = quote_sub(
        q{
( defined $_[0] && !ref $_[0] && ( $_[0] == 4 || $_[0] == 6 ) )
    or MaxMind::DB::Types::_confess(
    '%s is not a valid IP version (4 or 6)',
    $_[0]
    );
        }
    );

    sub IPVersion () { $t }
}

{
    my $t = quote_sub(
        q{
( !ref $_[0] && $_[0] >= 0 && $_[0] <= 128 )
    or MaxMind::DB::Types::_confess(
    '%s is not a valid IP network mask length (0-128)', $_[0] );
}
    );

    sub MaskLength () { $t }
}

{
    my $t = _object_isa_type('Math::UInt128');

    sub MathUInt128 () { $t }
}

{
    my $t = _object_isa_type('MaxMind::DB::Metadata');

    sub Metadata () { $t }
}

{
    my $t = quote_sub(
        q{
( defined $_[0] && !ref $_[0] )
    or MaxMind::DB::Types::_confess( '%s is not binary data', $_[0] );
}
    );

    sub PackedBinary () { $t }
}

{
    my $t = quote_sub(
        q{
( defined $_[0] && !ref $_[0] )
    or MaxMind::DB::Types::_confess( '%s is not a string', $_[0] );
}
    );

    sub Str () { $t }
}

sub _object_isa_type {
    my $class = shift;

    return quote_sub(
        qq{
( Scalar::Util::blessed( \$_[0] ) && \$_[0]->isa('$class') )
    or MaxMind::DB::Types::_confess(
    '%s is not a $class object',
    \$_[0]
    );
}
    );
}

sub _confess {
    confess sprintf(
        $_[0],
        defined $_[1] ? overload::StrVal( $_[1] ) : 'undef'
    );
}

1;
