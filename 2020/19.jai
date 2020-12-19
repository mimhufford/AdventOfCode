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
    messages1 := input;
    messages2 := input;

    options_for(0);
    part1 := 0;

    while messages1.count
    {
        str : string = ---;
        str.count = 0;
        str.data = messages1.data;
        while messages1.count && messages1[0] != #char "\n"
        {
            advance(*messages1);
            str.count += 1;
        }

        if messages1.count advance(*messages1);

        for nodes[0].str if strings_are_equal(it, str) { part1 += 1; break; }
    }

    // part 2 is if it matches any number of 42s then a bunch of 31s
    part2 := 0;

    while messages2.count
    {
        str : string = ---;
        str.count = 0;
        str.data = messages2.data;
        while messages2.count && messages2[0] != #char "\n"
        {
            advance(*messages2);
            str.count += 1;
        }
        if messages2.count advance(*messages2);

        r42 := match_as_many_as_possible(42, *str);
        r31 := match_as_many_as_possible(31, *str);

        if r42 && r31 && r42 > r31 && !str.count part2 += 1;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

nodes : [150]Node;

Node :: struct
{
    rules  : [4]u8;
    done   : bool;
    str    : [..]string;
}

match_as_many_as_possible :: (rule: u8, s: *string, count: u8 = 0) -> u8
{
    for nodes[rule].str
    {
        if begins_with(<<s, it)
        {
            advance(s, it.count);
            return match_as_many_as_possible(rule, s, count + 1);
        }
    }

    return count;
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