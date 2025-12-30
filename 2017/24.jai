day24 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    components := get_optimised_components(input);

    for components print("%\n", it);

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