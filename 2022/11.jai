day11 :: (input: string) -> string, string
{
    part1 := simulate(parse_monkeys(input), 20, 1);
    part2 := simulate(parse_monkeys(input), 10_000, 2);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Monkey :: struct
{
    items : [..]s64;
    mul   : u8 = 1;
    add   : u8 = 0;
    sqr   := false;
    mod   : u8;
    next  : [2]u8;
    inspections : u64;
}

simulate :: (monkeys: []Monkey, rounds: s64, part: s64) -> u64
{
    lcm := 1; for monkeys lcm *= it.mod;

    for 1..rounds
    {
        for * m: monkeys
        {
            while m.items.count
            {
                m.inspections += 1;
                item := m.items[0];
                array_ordered_remove_by_index(*m.items, 0);
                item += m.add;
                item *= m.mul;
                if m.sqr item *= item;
                if part == 1 item /= 3;
                item %= lcm;
                array_add(*monkeys[m.next[1 - cast(u8)(item % m.mod == 0)]].items, item);
            }
        }
    }

    inspections : [..]u64;
    for monkeys array_add(*inspections, it.inspections);
    quick_sort(inspections, n => n);
    return inspections[7] * inspections[6];
}

parse_monkeys :: (input: string) -> []Monkey
{
    monkeys : [..]Monkey;

    while input
    {
        m := array_add(*monkeys);
        for 1..4 read_word(*input);
        while true
        {
            array_add(*m.items, read_number(s64, *input, skip_trailing_whitespace=false));
            if input[0] == #char "\n" break; else advance(*input, 2);   
        }
        skip_whitespace(*input);
        for 1..4 read_word(*input);
        operation := read_word(*input);
        operand   := read_word(*input);
        if operation[0] == #char "+" m.add = xx string_to_int(operand);
        else if is_digit(operand[0]) m.mul = xx string_to_int(operand);
        else                         m.sqr = true;
        for 1..3 read_word(*input);
        m.mod = read_u8(*input);
        for 1..5 read_word(*input);
        m.next[0] = read_u8(*input);
        for 1..5 read_word(*input);
        m.next[1] = read_u8(*input);
    }

    return monkeys;
}