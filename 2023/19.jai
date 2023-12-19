day19 :: (input: string) -> string, string
{
    parts := split(trim(input), "\n\n");

    init(*workflows, 600);

    for * workflow: split(parts[0], "\n")
    {
        id := read_up_to(workflow, #char "{");
        w  := find_or_add(*workflows, id);

        advance(workflow);
        workflow.count -= 1;

        for rule: split(workflow.*, ",")
        {
            r := array_add(*w.rules);

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

    part1 := 0;

    for part: split(parts[1], "\n")
    {
        advance(*part, 3); x := read_s64(*part);
        advance(*part, 3); m := read_s64(*part);
        advance(*part, 3); a := read_s64(*part);
        advance(*part, 3); s := read_s64(*part);
        part1 += process_part(x, m, a, s);
    }

    return tprint("%", part1), tprint("%", 0);
}

#scope_file
    
workflows : Table(string, Workflow);

process_part :: (x:s64, m:s64, a:s64, s:s64) -> s64
{
    w := table_find_pointer(*workflows, "in");
    rid := 0;

    while true
    {
        r := w.rules[rid];

        if r.var == 0 && r.dst == null && r.accept == true
        {
            return x + m + a + s;
        }
        else if r.var == 0 && r.dst == null && r.accept == false
        {
            return 0;
        }
        else if r.var == 0 && r.dst != null
        {
            w = r.dst;
            rid = 0;
            continue;
        }
        else
        {
            val := x;
            if      r.var == #char "m" val = m;
            else if r.var == #char "a" val = a;
            else if r.var == #char "s" val = s;

            if (r.op == #char ">" && val > r.val) ||
               (r.op == #char "<" && val < r.val)
            {
                if r.dst != null
                {
                    w = r.dst;
                    rid = 0;
                    continue;
                }
                else if r.accept == true
                {
                    return x + m + a + s;
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                rid += 1;
            }
        }
    }

    assert(false);
    return 0;
}

Workflow :: struct
{
    rules : [..]Rule;
}

Rule :: struct
{
    var : u8;
    op : u8;
    val : s64;
    dst : *Workflow;
    accept : bool;
}