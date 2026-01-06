day6 :: (input: string) -> string, string
{
    part1, part2 := 0;

    Object :: struct { parent: *Object; children: [..]*Object; steps := 0; }
    objects : Table(string, Object);

    parse :: (input: string, connect: bool) #expand {
        while input {
            a := find_or_add(*objects, slice(input, 0, 3));
            b := find_or_add(*objects, slice(input, 4, 3));
            advance(*input, 8);
            if !connect continue;
            array_add(*a.children, b);
            b.parent = a;
        }
    }

    parse(input, connect = false);
    parse(input, connect = true);

    for * objects while it.parent { part1 += 1; it = it.parent; }

    count :: (start: string) -> s64 #expand {
        steps := 0;
        it := table_find_pointer(*objects, start);
        while it.parent {
            if it.steps return it.steps + steps - 2;
            it.steps = steps;
            steps += 1;
            it = it.parent;
        }
        return steps;
    }

    part2 = count("YOU");
    part2 = count("SAN");

    return tprint("%", part1), tprint("%", part2);
}