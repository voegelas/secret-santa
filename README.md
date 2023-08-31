# Secret Santa

Secret Santa is a Christmas tradition in which members of a group are randomly
assigned a person to whom they give a gift.

You are given a list of names.  Write a script that teams persons from
different families, if possible.

## Example 1

The givers are randomly chosen but don't share family names with the receivers.

### Input

    @names = (
        'Mr. Wall',
        'Mrs. Wall',
        'Mr. Anwar',
        'Mrs. Anwar',
        'Mr. Conway',
        'Mr. Cross',
    );

### Output

    Mr. Conway -> Mr. Wall
    Mr. Anwar -> Mrs. Wall
    Mrs. Wall -> Mr. Anwar
    Mr. Cross -> Mrs. Anwar
    Mr. Wall -> Mr. Conway
    Mrs. Anwar -> Mr. Cross

## Example 2

One gift is given to a family member.

### Input

    @names = (
        'Mr. Wall',
        'Mrs. Wall',
        'Mr. Anwar',
    );

### Output

    Mr. Anwar -> Mr. Wall
    Mr. Wall -> Mrs. Wall
    Mrs. Wall -> Mr. Anwar
