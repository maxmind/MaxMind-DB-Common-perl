package MaxMind::DB::Metadata;

use strict;
use warnings;
use namespace::autoclean;

use Math::Int128;

use Moo;
use MaxMind::DB::Types qw( ArrayRefOfStr Epoch HashRefOfStr Int Str );
use MooX::StrictConstructor;

with 'MaxMind::DB::Role::Debugs';

{
    my %metadata = (
        binary_format_major_version => Int,
        binary_format_minor_version => Int,
        build_epoch                 => Epoch,
        database_type               => Str,
        description                 => HashRefOfStr,
        ip_version                  => Int,
        node_count                  => Int,
        record_size                 => Int,
    );

    for my $attr ( keys %metadata ) {
        has $attr => (
            is       => 'ro',
            isa      => $metadata{$attr},
            required => 1,
        );
    }
}

has languages => (
    is      => 'ro',
    isa     => ArrayRefOfStr,
    default => sub { [] },
);

sub metadata_to_encode {
    my $self = shift;

    my %metadata;
    foreach my $attr ( $self->meta()->get_all_attributes() ) {
        my $method = $attr->name;
        $metadata{$method} = $self->$method;
    }

    return \%metadata;
}

sub debug_dump {
    my $self = shift;

    $self->_debug_newline();

    $self->_debug_message('Metadata:');
    my $version = join '.',
        $self->binary_format_major_version(),
        $self->binary_format_minor_version();
    $self->_debug_string( '  Binary format version', $version );

    require DateTime;
    $self->_debug_string(
        '  Build epoch',
        $self->build_epoch() . ' ('
            . DateTime->from_epoch( epoch => $self->build_epoch() ) . ')'
    );

    $self->_debug_string( '  Database type', $self->database_type() );

    my $description = $self->description();
    for my $locale ( sort keys %{$description} ) {
        $self->_debug_string(
            "  Description [$locale]",
            $description->{$locale}
        );
    }

    $self->_debug_string( '  IP version',            $self->ip_version() );
    $self->_debug_string( '  Node count',            $self->node_count() );
    $self->_debug_string( '  Record size (in bits)', $self->record_size() );
    $self->_debug_string(
        '  Languages', join ', ',
        @{ $self->languages() }
    );

    return;
}

__PACKAGE__->meta()->make_immutable();

1;
