package idi;

use strict;
use warnings;

use MIDI::Simple ();
use Music::Tempo qw(bpm_to_ms);

our $VERSION = '0.001000';

=head1 NAME

idi - Easy Command-line MIDI

=head1 SYNOPSIS

  perl -Midi -E'n(qw(ten C4)) for 1..3; n(qw(qn D4)); r("qn"); n(qw(en E4)) for 1..2'

  timidity idi.mid

=head1 DESCRIPTION

Easy Command-line MIDI

=head1 FUNCTIONS

=head2 b

BPM

=head2 c

Channel

=head2 d

Duration

=head2 o

Octave

=head2 n

Note

=head2 p

Patch

=head2 r

Rest

=head2 s

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

