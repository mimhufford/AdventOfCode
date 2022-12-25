day25 :: (input: string) -> string, string
{
    total : string;
    while input  total = add_snafu(total, read_word(*input));
    return tprint("%", total), tprint("%", ":)");
}

#scope_file

add_snafu :: (a: string, b: string) -> string
{
    result : [..]u8;

    count := max(a.count, b.count);
    carry : s64;
    digit : u8;

    for 0..count-1
    {
        val := carry;
        if it < a.count val += s_to_d(a[a.count - 1 - it]);
        if it < b.count val += s_to_d(b[b.count - 1 - it]);
        digit, carry = d_to_s(val);
        array_insert_at(*result, digit, 0);
    }

    if carry array_insert_at(*result, d_to_s(carry), 0);

    return xx result;
}

s_to_d :: (s: u8) -> s64
{
    if s == #char "=" return -2;
    if s == #char "-" return -1;
    if s == #char "0" return  0;
    if s == #char "1" return  1;
    if s == #char "2" return  2;
    assert(false); return 0;
}

d_to_s :: (d: s64) -> u8, s64
{
    if d == -5 return #char "0", -1;
    if d == -4 return #char "1", -1;
    if d == -3 return #char "2", -1;
    if d == -2 return #char "=",  0;
    if d == -1 return #char "-",  0;
    if d ==  0 return #char "0",  0;
    if d ==  1 return #char "1",  0;
    if d ==  2 return #char "2",  0;
    if d ==  3 return #char "=",  1;
    if d ==  4 return #char "-",  1;
    if d ==  5 return #char "0",  1;
    assert(false); return 0, 0;
}