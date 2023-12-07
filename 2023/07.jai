day7 :: (input: string) -> string, string
{
    hands : [..]Hand;

    while input.count array_add(*hands, read_hand(*input));

    part1 := calculate_winnings(hands, jokers = false);
    part2 := calculate_winnings(hands, jokers = true);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

calculate_winnings :: (hands: []Hand, jokers: bool) -> s64
{
    winnings := 0;
    if jokers for *hands for *it.cards if it.* == 11 it.* = 0;
    for *hands it.rank = calculate_rank(it);
    quick_sort(hands, compare_hands);
    for hands winnings += it.bid * (it_index + 1);
    return winnings;
}

calculate_rank :: (h: *Hand) -> Rank
{
    hand_has_joker := false;
    for h.cards if it == 0 hand_has_joker = true;

    if !hand_has_joker
    {
        unique : [..]u8;
        for h.cards array_add_if_unique(*unique, it);
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
    }

    best_rank := Rank.HIGH_CARD;

    _, i := array_find(h.cards, 0);
    cards_to_try : [..]u8;
    for h.cards if it != 0 array_add_if_unique(*cards_to_try, it);
    if cards_to_try.count == 0 array_add(*cards_to_try, 14);
    for c: cards_to_try
    {
        new_hand := h.*;
        new_hand.cards[i] = c;
        rank := calculate_rank(*new_hand);
        best_rank = max(best_rank, rank);
    }
    return best_rank;
}

compare_hands :: (a: Hand, b: Hand) -> s64
{
    if a.rank < b.rank return -1;
    if a.rank > b.rank return  1;
    return compare_strings(xx a.cards, xx b.cards);
}

read_hand :: (s: *string) -> Hand
{
    h: Hand;
    cards := read_word(s);
    h.bid  = read_s64(s);
    
    for 0..4
    {
        if is_digit(cards[it]) h.cards[it] = cards[it] - #char "0";
        else if cards[it] == #char "T" h.cards[it] = 10;
        else if cards[it] == #char "J" h.cards[it] = 11;
        else if cards[it] == #char "Q" h.cards[it] = 12;
        else if cards[it] == #char "K" h.cards[it] = 13;
        else if cards[it] == #char "A" h.cards[it] = 14;
    }

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
    cards : [5]u8;
    rank  : Rank;
    bid   : s64;
}