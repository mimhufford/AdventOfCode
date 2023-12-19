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

    part2 := process_ranges(in, .[1, 4000], .[1, 4000], .[1, 4000], .[1, 4000]);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

workflows : Table(string, [..]Rule);

process_ranges :: (rules: *[]Rule, _x: [2]s64, _m: [2]s64, _a: [2]s64, _s: [2]s64) -> s64
{
    x, m, a, s := _x, _m, _a, _s;
    accumulator := 0;

    for r: rules.*
    {
        if r.var == 0 && r.dst == null
        {
            if !r.accept return accumulator;
            else return accumulator + (x[1]-x[0]+1) * (m[1]-m[0]+1) * (a[1]-a[0]+1) * (s[1]-s[0]+1);
        }
        else if r.var == 0 && r.dst != null
        {
            return accumulator + process_ranges(r.dst, x, m, a, s);
        }
        else
        {
            if r.var == #char "x"
            {
                nx := x;
                if (r.op == #char ">") { nx[0] = r.val+1; x[1] = r.val; }
                else                   { nx[1] = r.val-1; x[0] = r.val; }

                if r.dst != null accumulator += process_ranges(r.dst, nx, m, a, s);
                else if r.accept accumulator += (nx[1]-nx[0]+1) * (m[1]-m[0]+1) * (a[1]-a[0]+1) * (s[1]-s[0]+1);
            }
            else if r.var == #char "m"
            {
                nm := m;
                if (r.op == #char ">") { nm[0] = r.val+1; m[1] = r.val; }
                else                   { nm[1] = r.val-1; m[0] = r.val; }

                if r.dst != null accumulator += process_ranges(r.dst, x, nm, a, s);
                else if r.accept accumulator += (x[1]-x[0]+1) * (nm[1]-nm[0]+1) * (a[1]-a[0]+1) * (s[1]-s[0]+1);
            }
            else if r.var == #char "a"
            {
                na := a;
                if (r.op == #char ">") { na[0] = r.val+1; a[1] = r.val; }
                else                   { na[1] = r.val-1; a[0] = r.val; }

                if r.dst != null accumulator += process_ranges(r.dst, x, m, na, s);
                else if r.accept accumulator += (x[1]-x[0]+1) * (m[1]-m[0]+1) * (na[1]-na[0]+1) * (s[1]-s[0]+1);
            }
            else
            {
                ns := s;
                if (r.op == #char ">") { ns[0] = r.val+1; s[1] = r.val; }
                else                   { ns[1] = r.val-1; s[0] = r.val; }

                if r.dst != null accumulator += process_ranges(r.dst, x, m, a, ns);
                else if r.accept accumulator += (x[1]-x[0]+1) * (m[1]-m[0]+1) * (a[1]-a[0]+1) * (ns[1]-ns[0]+1);
            }
        }
    }

    assert(false);
    return 0;
}

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