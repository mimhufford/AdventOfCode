day9 :: (data: string) -> string, string
{
    input := data;
    input.count -= 1; // trim the newline

    count : u64;

    while input.count
    {
        if input[0] == #char "("
        {
            chars, repeats := parse_chars_and_repeats(*input);
            count += chars * repeats;
            advance(*input, xx chars);
        }
        else
        {
            count += 1;
            advance(*input, 1);
        }
    }

    return tprint("%", count), tprint("%", "");
}

#scope_file

parse_chars_and_repeats :: (s: *string) -> u64, u64
{
    chars, repeats : u64;

    advance(s, 1); // skip (
    
    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        chars *= 10;
        chars += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 1); // skip (

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        repeats *= 10;
        repeats += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 1); // skip )

    return chars, repeats;
}