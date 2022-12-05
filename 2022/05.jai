day5 :: (input: string) -> string, string
{
    s9000, s9001 := parse_stacks(*input);

    while input
    {
        qty, src, dst := parse_instruction(*input);

        for 1..qty
        {
            array_add(*s9000[dst], pop(*s9000[src]));
            array_insert_at(*s9001[dst], pop(*s9001[src]), s9001[dst].count - it + 1);
        }
    }

    tops_9000, tops_9001: [..]u8;
    for 1..9 array_add(*tops_9000, peek(s9000[it]));
    for 1..9 array_add(*tops_9001, peek(s9001[it]));

    return tprint("%", cast(string)tops_9000), tprint("%", cast(string)tops_9001);
}

#scope_file

parse_instruction :: (s: *string) -> u8, u8, u8
{
    read_word(s);
    qty := read_u8(s);
    read_word(s);
    src := read_u8(s);
    read_word(s);
    dst := read_u8(s);

    return qty, src, dst;
}

parse_stacks :: (s: *string) -> [10][..]u8, [10][..]u8
{
    stacks_9000, stacks_9001 : [10][..]u8;

    while s.data[1] != #char "1"
    {
        for 1..9
        {
            col := (it - 1) * 4 + 1;

            if s.data[col] != #char " "
            {
                array_insert_at(*stacks_9000[it], s.data[col], 0);
                array_insert_at(*stacks_9001[it], s.data[col], 0);
            }
        }

        advance(s, 36);
    }

    advance(s, 36);
    skip_whitespace(s);

    return stacks_9000, stacks_9001;
}