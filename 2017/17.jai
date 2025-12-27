day17 :: (input: string) -> string, string
{
    steps := read_s64(*input) + 1;
    state : [..]s64;
    index := 0;
    array_add(*state, 0);

    for 0..2016 {
        index = (index + steps) % (it + 1);
        array_insert_at(*state, it + 1, index);
    }

    part1 := state[(index + 1) % state.count];

    index = 0;
    part2 := 0;

    for 1..50000000 {
        if index == 0 then part2 = it;

        skip := (it - index + steps - 1) / steps;
        it += skip;
        index = (index + skip * steps) % it;
        it -= 1;
    }

    return tprint("%", part1), tprint("%", part2);
}