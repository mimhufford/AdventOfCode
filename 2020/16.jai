day16 :: (input: string) -> string, string
{
    fields : [..]Field;
    ticket : [..]u16;
    others : [..][..]u16;
    part1  := 0;
    part2  := 1;

    // read fields
    while input[0] != #char "\n"
    {
        f: Field;
        while input[0] != #char ":" advance(*input);
        advance(*input, 2); // skip ": "
        f.lo1 = read_number(*input);
        advance(*input); // skip "-"
        f.hi1 = read_number(*input);
        advance(*input, 4); // skip " or "
        f.lo2 = read_number(*input);
        advance(*input); // skip "-"
        f.hi2 = read_number(*input);
        advance(*input); // skip "\n"
        array_add(*fields, f);
    }

    advance(*input, 14); // skip "\nyour ticket:\n"

    // read "your ticket"
    while true
    {
        array_add(*ticket, read_number(*input));
        if input[0] == #char "\n" { advance(*input); break; }
        else advance(*input);
    }

    advance(*input, 17); // skip "\nnearby tickets:\n"

    // read "nearby tickets"
    while input.count
    {
        t: [..]u16;
        valid := true;
        while true
        {
            value := read_number(*input);
            if !is_valid(value, fields)
            {
                part1 += value;
                valid = false;
            }
            else
            {
                array_add(*t, value);
            }
            if !input.count break;
            if input[0] == #char "\n"
            {
                advance(*input);
                break;
            }
            advance(*input);
        }
        if valid array_add(*others, t);
    }

    matches := fields_matched_by_index(fields, others);

    while true
    {
        reduced := true;
        for matches if it.count > 0 { reduced = false; break; }
        if reduced break;

        for matches
        {
            if it.count != 1 continue;
            if it[0] < 6 part2 *= ticket[it_index];
            for * m: matches array_unordered_remove_by_value(m, it[0]);
            break;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Field :: struct
{
    lo1, hi1: u16;
    lo2, hi2: u16;
}

fields_matched_by_index :: (fields: []Field, tickets: [..][..]u16) -> [..][..]s64
{
    matches : [..][..]s64;

    for index: 0..tickets[0].count
    {
        matching_field_indices : [..]s64;

        for f, fi: fields
        {
            all_match := true;

            for t: tickets
            {
                v := t[index];

                if ! ((v >= f.lo1 && v <= f.hi1) || (v >= f.lo2 && v <= f.hi2))
                {
                    all_match = false;
                    break;
                }
            }

            if all_match array_add(*matching_field_indices, fi);
        }

        array_add(*matches, matching_field_indices);
    }

    return matches;
}

is_valid :: (value: u16, fields: []Field) -> bool
{
    for fields
    {
        if value >= it.lo1 && value <= it.hi1 return true;
        if value >= it.lo2 && value <= it.hi2 return true;
    }

    return false;
}

read_number :: (s: *string) -> u16
{
    num: u16;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    return num;
}