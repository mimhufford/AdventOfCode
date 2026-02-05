day12 :: (data: string) -> string, string
{
    total, total_non_red := parse_obj(*data);

    return tprint("%", total), tprint("%", total_non_red);
}

parse_obj :: (s: *string) -> s64, s64
{
    total : s64;
    total_non_red : s64;
    contains_red : bool;

    assert(s.data[0] == #char "{");
    advance(s, 1); // skip {

    while s.data[0] != #char "}"
    {
        assert(s.data[0] == #char "\"", "%\n", s.*);
        advance(s, 3); // skip the key "?"
        assert(s.data[0] == #char ":", "%\n", s.*);
        advance(s, 1); // skip :
        
        if      s.data[0] == #char "{"  total, total_non_red += parse_obj(s);
        else if s.data[0] == #char "["  total, total_non_red += parse_arr(s);
        else if s.data[0] == #char "\"" contains_red |= parse_str(s);
        else { n := parse_num(s); total += n; total_non_red += n; }

        if s.data[0] == #char "," advance(s, 1);
    }

    advance(s, 1); // skip }

    return total, ifx contains_red then 0 else total_non_red;
}

parse_arr :: (s: *string) -> s64, s64
{
    total : s64;
    total_non_red : s64;

    assert(s.data[0] == #char "[");
    advance(s, 1); // skip [

    while s.data[0] != #char "]"
    {
        if      s.data[0] == #char "{"  total, total_non_red += parse_obj(s);
        else if s.data[0] == #char "["  total, total_non_red += parse_arr(s);
        else if s.data[0] == #char "\"" parse_str(s);
        else { n := parse_num(s); total += n; total_non_red += n; }

        if s.data[0] == #char "," advance(s, 1);
    }

    advance(s, 1); // skip ]

    return total, total_non_red;
}

parse_str :: (s: *string) -> bool
{
    str : string = ---;
    str.count = 0;
    str.data = s.data + 1;

    assert(s.data[0] == #char "\"");
    advance(s, 1); // skip "
    while s.data[0] != #char "\""
    {
        advance(s, 1);
        str.count += 1;
    }
    advance(s, 1); // skip "

    return str == "red";
}

parse_num :: (s: *string) -> s64
{
    num : s64;
    mul : s64 = 1;

    if s.data[0] == #char "-"
    {
        mul = -1;
        advance(s, 1);
    }
    
    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    num *= mul;
    return num;
}