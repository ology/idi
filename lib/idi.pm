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

  perl -Midi -E's(qw(c1 f o5); n(qw(qn Cs)); n("F"); n("Ds"); n(qw(hn Gs_d1))'

  timidity idi.mid

  # Compare with:
  perl -MMIDI::Simple -E'new_score; noop qw(c1 f o5); n qw(qn Cs); n "F"; n "Ds"; n qw(hn Gs_d1); write_score "idi.mid"'

=head1 DESCRIPTION

Easy Command-line MIDI

=head1 ATTRIBUTES

=head2 score

  $score = $m->score;

A C<MIDI::Simple-E<gt>new_score> object

=head1 METHODS

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

=cut

has filename => (
    is      => 'ro',
    default => sub { 'idi.mid' },
);

has score => (
    is      => 'ro',
    default => sub { MIDI::Simple->new_score },
);

sub b {
    my $self = shift;
    my ($bpm) = @_;
    $self->score->set_tempo(bpm_to_ms($bpm) * 1000);
}

sub c {
    my $self = shift;
    $self->score->Channel(@_);
}

sub d {
    my $self = shift;
    $self->score->Duration(@_);
}

sub o {
    my $self = shift;
    $self->score->Octave(@_);
}

sub n {
    my $self = shift;
    $self->score->n(@_);
}

sub p {
    my $self = shift;
    $self->score->patch_change(@_);
}

sub r {
    my $self = shift;
    $self->score->r(@_);
}

sub s {
    my $self = shift;
    $self->score->noop(@_);
}

sub t {
    my $self = shift;
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
    my $self = shift;
    $self->score->Volume(@_);
}

sub w {
    my $self = shift;
    my $name = shift || $self->filename;
    $self->score->write_score($name);
}

1;
