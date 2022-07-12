day22 :: (input: string) -> string, string
{
    player1_1 : [..]u8;
    player2_1 : [..]u8;

    while input[0] != #char "\n" advance(*input); advance(*input);
    while input[0] != #char "\n" array_add(*player1_1, read_number(*input)); advance(*input);
    while input[0] != #char "\n" advance(*input); advance(*input);
    while input.count && input[0] != #char "\n" array_add(*player2_1, read_number(*input));

    player1_2 : [..]u8; for player1_1 array_add(*player1_2, it);
    player2_2 : [..]u8; for player2_1 array_add(*player2_2, it);

    while player1_1.count > 0 && player2_1.count > 0
    {
        c1 := player1_1[0];
        c2 := player2_1[0];
        array_ordered_remove_by_index(*player1_1, 0);
        array_ordered_remove_by_index(*player2_1, 0);

        if c1 > c2
        {
            array_add(*player1_1, c1);
            array_add(*player1_1, c2);
        }
        else if c2 > c1
        {
            array_add(*player2_1, c2);
            array_add(*player2_1, c1);
        }
    }

    part1 : u64;
    if player1_1.count for player1_1 part1 += xx (player1_1.count-it_index)*cast(u64)it;
    else if player2_1.count for player2_1 part1 += xx (player2_1.count-it_index)*cast(u64)it;

    history : [..][51]u8; // 50 cards plus a 0 value for a divider

    winner, deck := play(player1_2, player2_2);
    part2 : u64;
    for deck part2 += xx (deck.count-it_index)*cast(u64)it;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

play :: (p1: [..]u8, p2: [..]u8) -> u8, [..]u8
{
    history : Table(u64, bool); // bool not used, just want a hash set

    while true
    {
        // play a game
        c1 := p1[0];
        c2 := p2[0];
        array_ordered_remove_by_index(*p1, 0);
        array_ordered_remove_by_index(*p2, 0);

        if c1 > p1.count || c2 > p2.count
        {
            if c1 > c2
            {
                array_add(*p1, c1);
                array_add(*p1, c2);
            }
            else if c2 > c1
            {
                array_add(*p2, c2);
                array_add(*p2, c1);
            }
        }
        else
        {
            // recurse with new decks
            new_p1 : [..]u8; for 0..c1-1 array_add(*new_p1, p1[it]);
            new_p2 : [..]u8; for 0..c2-1 array_add(*new_p2, p2[it]);
            winner := play(new_p1, new_p2);
            if winner == 1
            {
                array_add(*p1, c1);
                array_add(*p1, c2);
            }
            else
            {
                array_add(*p2, c2);
                array_add(*p2, c1);
            }
        }

        // check for winner
        if p1.count == 0 return 2, p2;
        if p2.count == 0 return 1, p1;

        // check if seen state before
        state : u64;
        for p1 state = (state << 16) + (state << 6) - state + it;
        state = (state << 16) + (state << 6) - state; // divide decks
        for p2 state = (state << 16) + (state << 6) - state + it;
        if table_find_pointer(*history, state) return 1, p1; // player 1 wins

        // didn't see it before, so record it
        table_add(*history, state, true);
    }

    shh_compiler : [..]u8;
    return 0, shh_compiler;
}

read_number :: (s: *string) -> u8
{
    num: u8;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    if s.count advance(s);

    return num;
}