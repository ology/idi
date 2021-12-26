package idi;

use strict;
use warnings;

use MIDI::Simple ();
use Music::Tempo qw(bpm_to_ms);

our $VERSION = '0.0100';

=head1 NAME

idi - Easy Command-line MIDI

=head1 SYNOPSIS

  perl -Midi -E's(qw(c1 f o5); n(qw(qn Cs)); n("F"); n("Ds"); n(qw(hn Gs_d1))'

  timidity idi.mid

  # Compare with:
  perl -MMIDI::Simple -E'new_score; noop qw(c1 f o5); n qw(qn Cs); n "F"; n "Ds"; n qw(hn Gs_d1); write_score "idi.mid"'

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

=for Pod::Coverage END

=cut

my $score = MIDI::Simple->new_score;

sub END {
  $score->write_score('idi.mid');
}

sub b {
    my ($bpm) = @_;
    $score->set_tempo(bpm_to_ms($bpm) * 1000);
}

sub c {
    my ($channel) = @_;
    $score->Channel($channel);
}

sub d {
    my ($duration) = @_;
    $score->Duration($duration);
}

sub o {
    my ($octave) = @_;
    $score->Octave($octave);
}

sub n { $score->n(@_) }

sub p {
    my ($channel, $patch) = @_;
    $score->patch_change($channel, $patch);
}

sub r { $score->r(@_) }

sub s {
    my (@args) = @_;
    $score->noop(@args);
}

sub t {
    my ($signature) = @_;
    my ($beats, $divisions) = split /\//, $signature;
    $score->time_signature(
        $beats,
        ($divisions == 8 ? 3 : 2),
        ($divisions == 8 ? 24 : 18 ),
        8
    );
}

sub v {
    my ($volume) = @_;
    $score->Volume($volume);
}

1;

=head1 AUTHOR

Gene Boggs <gene@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2021 by Gene Boggs.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

