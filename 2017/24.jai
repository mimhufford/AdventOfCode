day24 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    components := get_optimised_components(input);

    Route :: struct {
        used: s64;
        next: s32;
        strength: s32;
        length: s32;
    }

    routes : [..]Route;
    array_reserve(*routes, 750_000);
    array_add(*routes);

    longest := 0;
    index := 0;
    while index < routes.count {
        r := routes[index];
        for c, ci: components {
            if (1 << ci) & r.used continue;
            if c.a != r.next && c.b != r.next continue;
            n := array_add(*routes);
            n.used = r.used | (1 << ci);
            n.next = ifx c.a == r.next then c.b else c.a;
            n.strength = r.strength + c.strength;
            n.length = r.length + c.length;
            part1 = max(part1, n.strength);
            if n.length >= longest {
                longest = n.length;
                part2 = max(part2, n.strength);
            }
        }
        index += 1;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Component :: struct {
    a, b, strength, length: s32;
}

get_optimised_components :: (input: string) -> []Component {
    components : [..]Component;

    largest := 0;

    while input {
        c := array_add(*components);
        c.a = read_s32(*input);
        advance(*input);
        c.b = read_s32(*input);
        c.strength = c.a + c.b;
        c.length = 1;
        largest = max(largest, c.a);
        largest = max(largest, c.b);
    }

    found : [..]s64;
    for n: 1..largest {
        array_reset_keeping_memory(*found);
        
        for components {
            if it.a == n array_add(*found, it_index);
            if it.b == n array_add(*found, it_index);
        }
        
        if found.count != 2 continue;
        
        if found[0] == found[1] {
            array_unordered_remove_by_index(*components, found[0]);
            continue;
        }

        c1, c2 := *components[found[0]], *components[found[1]];

        if      c1.a == n && c2.a == n then c1.a = c2.b;
        else if c1.a == n && c2.b == n then c1.a = c2.a;
        else if c1.b == n && c2.a == n then c1.b = c2.b;
        else if c1.b == n && c2.b == n then c1.b = c2.a;

        c1.strength += c2.strength;
        c1.length += c2.length;

        array_unordered_remove_by_index(*components, found[1]);
    }

    return components;
}