#!/usr/bin/perl

use 5.036;
use utf8;

use Feature::Compat::Class 0.07;
use List::Util qw(first shuffle zip);

class Person {
    field $title :param :reader;
    field $family_name :param :reader;

    method is_related_to ($other) { $family_name eq $other->family_name }

    method to_string {"$title $family_name"}

    method equals ($other) { $self->to_string eq $other->to_string }

    sub from_name ($class, $name) {
        my ($title, $family_name) = split q{ }, $name, 2;
        return Person->new(title => $title, family_name => $family_name);
    }

    sub persons ($class, @names) {
        return map { Person->from_name($_) } @names;
    }
}

sub secret_santa (@persons) {
    # Assign random givers.
    my @teams = zip [shuffle @persons], [@persons];
    # Try to team persons with different family names.
    for my $team (@teams) {
        my ($giver, $receiver) = @{$team};
        if ($giver->is_related_to($receiver)) {
            # Find an unrelated giver.
            my $other_team = first {
                my ($other_giver, $other_receiver) = @{$_};
                !(     $other_giver->is_related_to($receiver)
                    || $giver->is_related_to($other_receiver))
            } @teams;
            if (!defined $other_team) {
                if ($giver->equals($receiver)) {
                    # Find a relative.
                    $other_team = first {
                        my ($other_giver) = @{$_};
                        !$other_giver->equals($giver)
                            && $other_giver->is_related_to($giver)
                    } @teams;
                }
            }
            last if !defined $other_team;
            # Swap the givers.
            ($team->[0], $other_team->[0]) = ($other_team->[0], $team->[0]);
        }
    }
    return @teams;
}

my @names = (
    'Mr. Wall',
    'Mrs. Wall',
    'Mr. Anwar',
    'Mrs. Anwar',
    'Mr. Conway',
    'Mr. Cross',
);

for my $team (secret_santa(Person->persons(@names))) {
    my ($giver, $receiver) = @{$team};
    say $giver->to_string, ' -> ', $receiver->to_string;
}
