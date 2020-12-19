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

    options_for(0);
    part1 := 0;

    while input.count
    {
        str : string = ---;
        str.count = 0;
        str.data = input.data;
        while input.count && input[0] != #char "\n"
        {
            advance(*input);
            str.count += 1;
        }

        if input.count advance(*input);

        for nodes[0].str if it == str { part1 += 1; break; }
    }

    return tprint("%", part1), "";
}

#scope_file

nodes : [150]Node;

Node :: struct
{
    rules  : [4]u8;
    done   : bool;
    str    : [..]string;
}

options_for :: (index: u8)
{
    if nodes[index].done return;
    nodes[index].done = true;

    a := nodes[index].rules[0];
    b := nodes[index].rules[1];
    c := nodes[index].rules[2];
    d := nodes[index].rules[3];

    if !a && d // ..|.d
    {
        array_add(*nodes[index].str, ifx d == #char "a" then "a" else "b");
    }
    else if d // ab|cd
    {
        options_for(a); options_for(b); options_for(c); options_for(d);
        for as: nodes[a].str for bs: nodes[b].str array_add(*nodes[index].str, tprint("%1%2", as, bs));
        for cs: nodes[c].str for ds: nodes[d].str array_add(*nodes[index].str, tprint("%1%2", cs, ds));
    }
    else if c // a.|c.
    {
        options_for(a); options_for(c);
        for as: nodes[a].str array_add(*nodes[index].str, as);
        for cs: nodes[c].str array_add(*nodes[index].str, cs);
    }
    else if b // ab|..
    {
        options_for(a); options_for(b);
        for as: nodes[a].str for bs: nodes[b].str array_add(*nodes[index].str, tprint("%1%2", as, bs));
    }
    else // a.|..
    {
        options_for(a);
        nodes[index].str = nodes[a].str;
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