day7 :: (input: string) -> string, string
{
    hands : [..]Hand;

    while input.count array_add(*hands, read_hand(*input));

    part1, part2 := 0;
    quick_sort(hands, compare_hands_no_jokers);
    for hands part1 += it.bid * (it_index + 1);

    quick_sort(hands, compare_hands_with_jokers);
    for hands part2 += it.bid * (it_index + 1);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

calculate_rank_2 :: (h: *Hand) -> Rank
{
    // early out for simple hands without a joker
    contains_joker := false;
    for 0..4 if h.cards[it] == 11 contains_joker = true;
    if !contains_joker return calculate_rank_1(h);

    best_rank := calculate_rank_1(h);
    for i: 0..4
    {
        if h.cards[i] == 11
        {
            new_hand := h.*;
            for c: 2..14
            {
                if c == 11 continue;
                new_hand.cards[i] = xx c;
                rank := calculate_rank_2(*new_hand);
                best_rank = max(best_rank, rank);
            }
            return best_rank;
        }
    }

    return best_rank;
}

calculate_rank_1 :: (h: *Hand) -> Rank
{
    unique : [..]u8;
    for 0..4 array_add_if_unique(*unique, h.cards[it]);
    if unique.count == 1 return .FIVE_OF_A_KIND;
    if unique.count == 5 return .HIGH_CARD;
    if unique.count == 4 return .ONE_PAIR;
    if unique.count == 3
    {
        for i: 0..4
        {
            count := 1;
            for j: i+1..4 if h.cards[i] == h.cards[j] count += 1;
            if count == 3 return .THREE_OF_A_KIND;
        }
        return .TWO_PAIR;
    }
    if unique.count == 2
    {
        for i: 0..4
        {
            count := 1;
            for j: i+1..4 if h.cards[i] == h.cards[j] count += 1;
            if count == 4 return .FOUR_OF_A_KIND;
        }
        return .FULL_HOUSE;
    }

    assert(false);
    return xx 0;
}

compare_hands_no_jokers :: (a: Hand, b: Hand) -> s64
{
    if a.rank_1 < b.rank_1 return -1;
    if a.rank_1 > b.rank_1 return  1;
    for 0..4
    {
        if a.cards[it] < b.cards[it] return -1;
        if a.cards[it] > b.cards[it] return  1;
    }
    return 0;
}

compare_hands_with_jokers :: (a: Hand, b: Hand) -> s64
{
    if a.rank_2 < b.rank_2 return -1;
    if a.rank_2 > b.rank_2 return  1;
    for 0..4
    {
        if a.cards[it] == 11 && b.cards[it] != 11 return -1;
        if a.cards[it] != 11 && b.cards[it] == 11 return  1;
        if a.cards[it] < b.cards[it] return -1;
        if a.cards[it] > b.cards[it] return  1;
    }
    return 0;
}

read_hand :: (s: *string) -> Hand
{
    h: Hand;
    cards := read_word(s);
    assert(cards.count == 5);
    for 0..4
    {
        if      cards[it] == #char "2" h.cards[it] = 2;
        else if cards[it] == #char "3" h.cards[it] = 3;
        else if cards[it] == #char "4" h.cards[it] = 4;
        else if cards[it] == #char "5" h.cards[it] = 5;
        else if cards[it] == #char "6" h.cards[it] = 6;
        else if cards[it] == #char "7" h.cards[it] = 7;
        else if cards[it] == #char "8" h.cards[it] = 8;
        else if cards[it] == #char "9" h.cards[it] = 9;
        else if cards[it] == #char "T" h.cards[it] = 10;
        else if cards[it] == #char "J" h.cards[it] = 11;
        else if cards[it] == #char "Q" h.cards[it] = 12;
        else if cards[it] == #char "K" h.cards[it] = 13;
        else if cards[it] == #char "A" h.cards[it] = 14;
        else assert(false);
    }
    h.bid    = read_s64(s);
    h.rank_1 = calculate_rank_1(*h);
    h.rank_2 = calculate_rank_2(*h);

    return h;
}

Rank :: enum
{
    HIGH_CARD       :: 0;
    ONE_PAIR        :: 1;
    TWO_PAIR        :: 2;
    THREE_OF_A_KIND :: 3;
    FULL_HOUSE      :: 4;
    FOUR_OF_A_KIND  :: 5;
    FIVE_OF_A_KIND  :: 6;
}

Hand :: struct
{
    cards  : [5]u8;
    rank_1 : Rank;
    rank_2 : Rank;
    bid    : s64;
}