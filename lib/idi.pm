package idi;

# ABSTRACT: Easy Command-line MIDI

use strict;
use warnings;

use MIDI::Simple ();
use Music::Tempo qw(bpm_to_ms);
use Moo;
use strictures 2;
use namespace::clean;

our $VERSION = '0.0100';

=head1 SYNOPSIS

  perl -Midi -E's(qw(c1 f o5); n(qw(qn Cs)); n("F"); n("Ds"); n(qw(hn Gs_d1)); w()'

  timidity idi.mid

  # Compare with:
  perl -MMIDI::Simple -E'new_score; noop qw(c1 f o5); n qw(qn Cs); n "F"; n "Ds"; n qw(hn Gs_d1); write_score shift()' idi.mid

=head1 DESCRIPTION

Easy Command-line MIDI

=head1 FUNCTIONS

=head2 b

BPM

=head2 c

Channel

=head2 d

Duration

=head2 n

Note

=head2 o

Octave

=head2 p

Patch

=head2 r

Rest

=head2 s

Setup score (C<MIDI::Simple::noop>)

=head2 t

Time signature

=head2 v

Volume

=head2 w

Write score

=for Pod::Coverage BUILD

=cut

my $self;

sub BEGIN {
    $self = __PACKAGE__->new;
}

has filename => (
    is      => 'ro',
    default => sub { 'idi.mid' },
);

has score => (
    is      => 'ro',
    default => sub { MIDI::Simple->new_score },
);

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

sub o {
    $self->score->Octave(@_);
}

sub n {
    $self->score->n(@_);
}

sub p {
    $self->score->patch_change(@_);
}

sub r {
    $self->score->r(@_);
}

sub s {
    $self->score->noop(@_);
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
    my $name = shift || $self->filename;
    $self->score->write_score($name);
}

1;
