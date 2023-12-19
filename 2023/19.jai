day19 :: (input: string) -> string, string
{
    parts := split(trim(input), "\n\n");

    init(*workflows, 600);

    for * workflow: split(parts[0], "\n")
    {
        id := read_up_to(workflow, #char "{");
        rules := find_or_add(*workflows, id);

        advance(workflow);
        workflow.count -= 1;

        for rule: split(workflow.*, ",")
        {
            r := array_add(rules);

            if contains(rule, #char ":")
            {
                r.var = rule[0];         advance(*rule);
                r.op  = rule[0];         advance(*rule);
                r.val = read_s64(*rule); advance(*rule);
                if      rule[0] == #char "A" r.accept = true;
                else if rule[0] == #char "R" r.accept = false;
                else    r.dst = find_or_add(*workflows, rule);

            }
            else if rule[0] == #char "A" r.accept = true;
            else if rule[0] == #char "R" r.accept = false;
            else    r.dst = find_or_add(*workflows, rule);
        }
    }

    in := table_find_pointer(*workflows, "in");
    part1 := 0;

    for part: split(parts[1], "\n")
    {
        advance(*part, 3); x := read_s64(*part);
        advance(*part, 3); m := read_s64(*part);
        advance(*part, 3); a := read_s64(*part);
        advance(*part, 3); s := read_s64(*part);
        part1 += process_part(in, x, m, a, s);
    }

    return tprint("%", part1), tprint("%", 0);
}

#scope_file
    
workflows : Table(string, [..]Rule);

process_part :: (rules: *[]Rule, x: s64, m: s64, a: s64, s: s64) -> s64
{
    for r: rules.*
    {
        if r.var == 0 && r.dst == null
        {
            if !r.accept return 0;
            return x + m + a + s;
        }
        else if r.var == 0 && r.dst != null
        {
            return process_part(r.dst, x, m, a, s);
        }
        else
        {
            val := x;
            if      r.var == #char "m" val = m;
            else if r.var == #char "a" val = a;
            else if r.var == #char "s" val = s;

            if (r.op == #char ">" && val > r.val) || (r.op == #char "<" && val < r.val)
            {
                if r.dst != null
                {
                    return process_part(r.dst, x, m, a, s);
                }
                else
                {
                    if !r.accept return 0;
                    return x + m + a + s;
                }
            }
        }
    }

    assert(false);
    return 0;
}

Rule :: struct
{
    var : u8;
    op : u8;
    val : s64;
    dst : *[]Rule;
    accept : bool;
}