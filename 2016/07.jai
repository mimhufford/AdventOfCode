day7 :: (data: string) -> string, string
{
    lines := split(data, "\n");
    lines.count -= 1;

    supports_tls := 0;
    supports_ssl := 0;

    for lines
    {
        supports_tls += xx tls_check(it);
        supports_ssl += xx ssl_check(it);
    }

    return tprint("%", supports_tls), tprint("%", supports_ssl);

    ssl_check :: (s: string) -> bool
    {
        inside_abas : [..][2]u8;
        outside_abas : [..][2]u8;
        currently_inside := false;
        contains_aba_inside := false;
        contains_bab_outside := false;

        for i: 0..s.count-3
        {
            a := s[i+0];
            b := s[i+1];
            c := s[i+2];

            if a == #char "[" || b == #char "[" || c == #char "["
                currently_inside = true;
            
            if a == #char "]" || b == #char "]" || c == #char "]"
                currently_inside = false;

            if a == c && a != b
            {
                aba : [2]u8;
                aba[0] = a;
                aba[1] = b;

                if currently_inside
                {
                    for outside_abas if it[0] == b && it[1] == a return true;
                    array_add(*inside_abas, aba);
                }
                else
                {
                    for inside_abas if it[0] == b && it[1] == a return true;
                    array_add(*outside_abas, aba);
                }
            }
        }

        return false;
    }

    tls_check :: (s: string) -> bool
    {
        currently_inside := false;
        contains_abba_inside := false;
        contains_abba_outside := false;

        for i: 0..s.count-4
        {
            a := s[i+0];
            b := s[i+1];
            c := s[i+2];
            d := s[i+3];

            if a == #char "[" || b == #char "[" || c == #char "[" || d == #char "["
                currently_inside = true;
            
            if a == #char "]" || b == #char "]" || c == #char "]" || d == #char "]"
                currently_inside = false;

            if a == d && b == c && a != b
            {
                contains_abba_inside  |=  currently_inside;
                contains_abba_outside |= !currently_inside;
            }
        }

        return contains_abba_outside && !contains_abba_inside;
    }
}