day11 :: (input: string) -> string, string
{
    part1 := simulate(parse_monkeys(input), 3, 20);
    part2 := simulate(parse_monkeys(input), 1, 10_000);

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
    inspections : s64;
}

simulate :: (monkeys: []Monkey, $worry_divisor: s64, rounds: s64) -> s64
{
    worry_modulus := 1; for monkeys worry_modulus *= it.mod;

    for 1..rounds
    {
        for * m: monkeys
        {
            for item: m.items
            {
                m.inspections += 1;
                item += m.add;
                item *= m.mul;
                if m.sqr item *= item;
                item /= worry_divisor;
                item %= worry_modulus;
                array_add(*monkeys[m.next[1 - cast(u8)(item % m.mod == 0)]].items, item);
            }
            m.items.count = 0;
        }
    }

    quick_sort(monkeys, (a, b) => b.inspections - a.inspections);
    return monkeys[0].inspections * monkeys[1].inspections;
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