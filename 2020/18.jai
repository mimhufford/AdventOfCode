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
    advance(s);
    return 0;
}

is_add :: (s: *string) -> bool {
    result := s.data[0] == #char "+";
    if result advance(s, 2);
    return result;
}

is_mul :: (s: *string) -> bool {
    result := s.data[0] == #char "*";
    if result advance(s, 2);
    return result;
}

is_open :: (s: *string) -> bool {
    result := s.data[0] == #char "(";
    if result advance(s);
    return result;
}

is_close :: (s: *string) -> bool {
    result := s.count == 0 || s.data[0] == #char "\n" || s.data[0] == #char ")";
    if s.count && result advance(s);
    eat_space(s);
    return result;
}

is_num :: (s: *string) -> bool {
    return s.data[0] >= #char "0" && s.data[0] <= #char "9";
}

eat_space :: (s: *string) {
    if s.count && s.data[0] == #char " " advance(s);
}

read_number :: (s: *string) -> u64 {
    num := s.data[0] - #char "0";
    advance(s); eat_space(s);
    return num;
}