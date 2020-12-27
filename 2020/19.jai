day19 :: (input: string) -> string, string
{
    while input[0] != #char "\n"
    {
        index := read_number(*input);
        advance(*input, 2); // ": "

        if input[0] == #char "\""
        {
            advance(*input);
            nodes[index].rules[3] = input[0];
            advance(*input, 3); 
        }
        else // it's the first number
        {
            nodes[index].rules[0] = read_number(*input);

            if input[0] == #char "\n"
            {
                advance(*input);
            }
            else
            {
                advance(*input);

                if input[0] == #char "|"
                {
                    advance(*input, 2);
                    nodes[index].rules[2] = read_number(*input);
                    advance(*input);
                }
                else // it's the second number
                {
                    nodes[index].rules[1] = read_number(*input);

                    if input[0] == #char "\n"
                    {
                        advance(*input);
                    }
                    else // it's an ab|cd, so read c and d
                    {
                        advance(*input, 3);
                        nodes[index].rules[2] = read_number(*input);
                        advance(*input);   
                        nodes[index].rules[3] = read_number(*input);
                        advance(*input);   
                    }
                }
            }
        }
    }

    advance(*input);

    part1 := 0;
    messages1 := input;
    while messages1.count
    {
        str : string; str.data = messages1.data;
        while messages1.count && messages1[0] != #char "\n" { advance(*messages1); str.count += 1; } 
        if messages1.count advance(*messages1);

        result := match(str, 0);
        if result.data && !result.count part1 += 1;
    }

    // part 2 is if it matches any number of 42s then a bunch of 31s
    part2 := 0;
    messages2 := input;
    while messages2.count
    {
        str : string; str.data = messages2.data;
        while messages2.count && messages2[0] != #char "\n" { advance(*messages2); str.count += 1; } 
        if messages2.count advance(*messages2);

        count_42s := 0;
        remainder := str;
        while true
        {
            remainder = match(remainder, 42);
            if remainder.data { count_42s += 1; str = remainder; }
            else break;
        }
        count_31s := 0;
        remainder = str;
        while true
        {
            remainder = match(remainder, 31);
            if remainder.data { count_31s += 1; str = remainder; }
            else break;
        }

        if str.data && !str.count && count_42s && count_31s && count_42s > count_31s part2 += 1;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

nodes : [150]Node;

Node :: struct
{
    rules : [4]u8;
}

match :: (str: string, index: u8) -> string
{
    a := nodes[index].rules[0];
    b := nodes[index].rules[1];
    c := nodes[index].rules[2];
    d := nodes[index].rules[3];
    no_match : string;

    if !a && d // ..|.d
    {
        if str.count && d == str[0] return advance(str);
        return no_match;
    }
    else if d // ab|cd
    {
        ar := match(str, a);
        if ar.data
        {
            br := match(ar, b);
            if br.data return br;
        }

        cr := match(str, c);
        if cr.data
        {
            dr := match(cr, d);
            if dr.data return dr;
        }

        return no_match;
    }
    else if c // a.|c.
    {
        ar := match(str, a);
        if ar.data return ar;
        cr := match(str, c);
        if cr.data return cr;
        return no_match;
    }
    else if b // ab|..
    {
        ar := match(str, a);
        if !ar.data return no_match;
        br := match(ar, b);
        if br.data return br;
        return no_match;
    }
    else // a.|..
    {
        return match(str, a);
    }
}

read_number :: (s: *string) -> u8
{
    num: u8;

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    return num;
}