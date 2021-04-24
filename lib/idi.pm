package idi;

use strict;
use warnings;

use MIDI::Simple ();

our $VERSION = '0.001000';

=head1 NAME

idi - Easy Command-line MIDI

=head1 SYNOPSIS

  perl -Midi -E'n("ten","C4") for 1..3; n("qn","D4"); r("qn"); n("en","E4") for 1..2'

  timidity idi.mid

=head1 DESCRIPTION

Easy Command-line MIDI

=cut

my $score = MIDI::Simple->new_score;

#sub import {
#    print "Hello!\n";
#}

sub END {
  $score->write_score('idi.mid');
}

1;

=head1 AUTHOR

Gene Boggs <gene@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2021 by Gene Boggs.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

