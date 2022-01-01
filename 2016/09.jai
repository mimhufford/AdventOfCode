day9 :: (data: string) -> string, string
{
    input := data;
    input.count -= 1; // trim the newline

    return tprint("%", decompress(input, .V1)), tprint("%", decompress(input, .V2));
}

#scope_file

decompress :: (s: string, version: enum{V1; V2;}) -> u64
{
    count : u64;

    while s.count
    {
        if s[0] == #char "("
        {
            chars, repeats := parse_chars_and_repeats(*s);

            if version == .V1 count += chars * repeats;
            else
            {
                segment := s;
                segment.count = xx chars;
                count += repeats * decompress(segment, version);
            }

            advance(*s, xx chars);
        }
        else
        {
            count += 1;
            advance(*s, 1);
        }
    }

    return count;
}

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