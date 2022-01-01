day7 :: (data: string) -> string, string
{
    lines := split(data, "\n");
    lines.count -= 1;

    supports_tls := 0;

    for lines
    {
        currently_inside := false;
        contains_abba_inside := false;
        contains_abba_outside := false;

        for i: 0..it.count-4
        {
            a := it[i+0];
            b := it[i+1];
            c := it[i+2];
            d := it[i+3];

            if a == #char "[" || b == #char "[" || c == #char "["|| d == #char "["
                currently_inside = true;
            
            if a == #char "]" || b == #char "]" || c == #char "]"|| d == #char "]"
                currently_inside = false;

            if a == d && b == c && a != b
            {
                contains_abba_inside  |=  currently_inside;
                contains_abba_outside |= !currently_inside;
            }
        }

        if contains_abba_outside && !contains_abba_inside  supports_tls += 1;
    }

    return tprint("%", supports_tls), tprint("%", "");
}