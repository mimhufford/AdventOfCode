day12 :: (data: string) -> string, string
{
    total : int;

    parse_obj(*data);

    while data.count
    {
        if is_digit(*data) total += read_num(*data);
        else advance(*data, 1);
    }

    return tprint("%", total), tprint("%", "");
}

parse_obj :: (s: *string) {
    assert(s.data[0] == #char "{");
    advance(s, 1); // skip {
    advance(s, 3); // skip "?"
    assert(s.data[0] == #char ":");
    advance(s, 1); // skip :
    
    if      s.data[0] == #char "{" parse_obj(s);
    else if s.data[0] == #char "[" parse_arr(s);
    else if is_digit(s)            parse_num(s);
    else                           parse_str(s);

}
parse_str :: (s: *string) {}
parse_arr :: (s: *string) {}
parse_num :: (s: *string) {}

is_digit :: inline (s: *string) -> bool { return s.data[0] == #char "-" || (s.data[0] >= #char "0" && s.data[0] <= #char "9"); }

read_num :: (s: *string) -> int
{
    num : int;
    mul : int = 1;

    if s.data[0] == #char "-"
    {
        mul = -1;
        advance(s, 1);
    }
    
    while is_digit(s)
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 1);

    return num * mul;
}