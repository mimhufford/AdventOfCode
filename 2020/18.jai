day18 :: (input: string) -> string, string
{
    input1 := input;  part1 : u64;
    while input1.count part1 += evaluate1(*input1);

    input2 := input;  part2 : u64;
    while input2.count part2 += evaluate2(*input2);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

evaluate1 :: (s: *string) -> u64
{
    num : u64;
    add := true;

    while true
    {
        if is_num(s)
        {
            if add num += read_number(s);
            else   num *= read_number(s);
        }
        else if is_open(s)
        {
            if add num += evaluate1(s);
            else   num *= evaluate1(s);
        }
        else assert(false);

        if is_add(s) add = true;
        else if is_mul(s) add = false;
        else if is_close(s) return num;
    }

    assert(false);
    return 0;
}

evaluate2 :: (s: *string) -> u64
{
    numbers : [..]u64;
    tokens  : [..]u8;

    maybe_resolve_add :: inline (numbers: *[..]u64, tokens: *[..]u8)
    {
        if tokens.count && tokens.data[tokens.count-1] == #char "+"
        {
            numbers.data[numbers.count-2] += numbers.data[numbers.count-1];
            numbers.count -= 1;
            tokens.count -= 1;
        }
    }

    while true
    {
        if s.count == 0 break;
        if s.data[0] == #char "\n" { advance(s); break; }

        if      is_open(s)  array_add(*tokens, #char "(");
        else if is_add(s)   array_add(*tokens, #char "+");
        else if is_mul(s)   array_add(*tokens, #char "*");
        else if is_close(s)
        {
            while tokens[tokens.count-1] != #char "("
            {
                numbers[numbers.count-2] *= numbers[numbers.count-1];
                numbers.count -= 1;
                tokens.count -= 1;
            }
            tokens.count -= 1; // remove the ( token
            maybe_resolve_add(*numbers, *tokens);
        }
        else if is_num(s)
        {
            array_add(*numbers, read_number(s));
            maybe_resolve_add(*numbers, *tokens);
        }
    }

    for 0..numbers.count-2 numbers[it+1] *= numbers[it];
    return numbers[numbers.count-1];
}

is_add :: inline (s: *string) -> bool {
    result := s.data[0] == #char "+";
    if result advance(s, 2);
    return result;
}

is_mul :: inline (s: *string) -> bool {
    result := s.data[0] == #char "*";
    if result advance(s, 2);
    return result;
}

is_open :: inline (s: *string) -> bool {
    result := s.data[0] == #char "(";
    if result advance(s);
    return result;
}

is_close :: inline (s: *string) -> bool {
    result := s.count == 0 || s.data[0] == #char "\n" || s.data[0] == #char ")";
    if s.count && result advance(s);
    eat_space(s);
    return result;
}

is_num :: inline (s: *string) -> bool {
    return s.data[0] >= #char "0" && s.data[0] <= #char "9";
}

eat_space :: inline (s: *string) {
    if s.count && s.data[0] == #char " " advance(s);
}

read_number :: inline (s: *string) -> u64 {
    num := s.data[0] - #char "0";
    advance(s); eat_space(s);
    return num;
}