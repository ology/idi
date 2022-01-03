package idi;

# ABSTRACT: Easy, command-line MIDI

use strict;
use warnings;

use File::Slurper qw(read_binary);
use MIDI::Simple ();
use Music::Tempo qw(bpm_to_ms);
use Moo;
use strictures 2;
use namespace::clean;

use Exporter 'import';
our @EXPORT = qw(
    get_score
    b
    c
    d
    e
    n
    o
    p
    r
    t
    v
    w
    x
);

our $VERSION = '0.0201';

my $self;

sub BEGIN {
    has filename => (
        is      => 'rw',
        default => sub { 'idi.mid' },
    );

    has score => (
        is      => 'ro',
        default => sub { MIDI::Simple->new_score },
    );

    has play => (
        is      => 'rw',
        default => sub { 1 },
    );

    has is_written => (
        is      => 'rw',
        default => sub { 0 },
    );

    $self = __PACKAGE__->new;
}

sub END {
    if ($self->play) {
        $self->score->write_score($self->filename) unless $self->is_written;
        my $content = read_binary($self->filename);
        print $content;
    }
}

sub get_score {
    return $self->score;
}

sub b {
    my ($bpm) = @_;
    $self->score->set_tempo(bpm_to_ms($bpm) * 1000);
}

sub c {
    $self->score->Channel(@_);
}

sub d {
    $self->score->Duration(@_);
}

sub e {
    my ($value) = @_;
    $self->play($value);
}

sub n {
    $self->score->n(@_);
}

sub o {
    $self->score->Octave(@_);
}

sub p {
    $self->score->patch_change(@_);
}

sub r {
    $self->score->r(@_);
}

sub t {
    my ($signature) = @_;
    my ($beats, $divisions) = split /\//, $signature;
    $self->score->time_signature(
        $beats,
        ($divisions == 8 ? 3 : 2),
        ($divisions == 8 ? 24 : 18 ),
        8
    );
}

sub v {
    $self->score->Volume(@_);
}

sub w {
    my ($name) = @_;
    if ($name) {
        $self->filename($name);
    }
    else {
        $name = $self->filename;
    }
    $self->score->write_score($name);
    $self->is_written(1);
}

sub x {
    $self->score->noop(@_);
}

1;

=head1 NAME

idi - Easy, command-line MIDI

=head1 SYNOPSIS

  $ perl -Midi -E'x(qw(c1 f o5)); n(qw(qn Cs)); n("F"); n("Ds"); n(qw(hn Gs_d1))' | timidity -

  # Compare with:
  $ perl -MMIDI::Simple -E'new_score; noop qw(c1 f o5); n qw(qn Cs); n "F"; n "Ds"; n qw(hn Gs_d1); write_score shift()' idi.mid
  $ timidity idi.mid

=head1 DESCRIPTION

Easy, command-line MIDI!

=head1 FUNCTIONS

=head2 b

BPM

=head2 c

Channel

Default: C<0>

=head2 d

Duration

Default: <96>

=head2 e

Play at end

Default: <1>

=head2 n

Add note

=head2 o

Octave

Default: C<5>

=head2 p

Patch

Default: C<0> (piano)

=head2 r

Add rest

=head2 t

Time signature

Default: C<none>

=head2 v

Volume

Default: C<64>

=head2 w

Write score.  Supply a string argument for different name.

Default filename: C<idi.mid>

=head2 x

No-op (with C<MIDI::Simple::noop>)

=for Pod::Coverage filename
=for Pod::Coverage score
=for Pod::Coverage play
=for Pod::Coverage is_written

=head1 AUTHOR

Gene Boggs <gene@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2021 by Gene Boggs.

This is free software, licensed under: The Artistic License 2.0 (GPL Compatible)

=cut
