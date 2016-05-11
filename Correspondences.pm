#
#===============================================================================
#
#         FILE: Correspondences.pm
#
#  DESCRIPTION: Correspondences of Names/*junctions in EUROPARL
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Bernhard Fisseni (bfi), bernhard.fisseni@uni-due.de
# ORGANIZATION: Uni Duisburg-Essen
#      VERSION: 1.0
#      CREATED: 2016-05-11, 19:36:13 (CEST)
#     REVISION: ---
#  Last Change: 2016-05-11, 20:30:52 CEST
#===============================================================================

use strict;
use warnings;
use utf8;
use feature qw(say state switch unicode_strings);
use re "/u";
use autodie;
use open qw( :encoding(UTF-8) :std );
 
my %conjunctions = (
    de => qr{und}i,
    nl => qr{en}i,
    sv => qr{och}i,
    da => qr{og}i,
    en => qr{and}i,
);

my %normal = (
    conjunction => "&",
    president => "PRESIDENT",
);

my %presidents = (
    de => qr/präsident(?:in)?/i,
    nl => qr/voorzitt?er/i,
    da => qr/formand(?:en)/i,
    sv => qr/(talman(?:en)?|ordförande(?:n)?)/i,
);

sub clean_speaker {
    my $speaker = shift();
    $speaker =~ s/[\p{punctuation}\p{space}]+$//g;
    $speaker =~ s/^[\p{punctuation}\p{space}]+//g;
    return ($speaker)
}

sub normalise {
    my $speaker = clean_speaker(shift());
    my $lang = shift();
    return conjoin(president($speaker, $lang), $lang)
    
}

*normalize = \&normalise;

sub president {
    my $speaker = shift();
    my $lang = shift();
    if (lc($speaker) =~ m/^.{0,15}$presidents{$lang}/i){
        return $normal{president}
    } else {
        return $speaker
    }
}

sub conjoin{
    my $speaker = shift();
    my $lang = shift();
    $speaker =~ s/\b$conjunctions{$lang}/$normal{conjunction}/;
    return $speaker;
}
