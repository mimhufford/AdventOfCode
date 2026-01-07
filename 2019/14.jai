day14 :: (input: string) -> string, string
{
    part1, part2 := 0;

    reactions := parse_reactions(input);

    ore :: (amount: s64) -> s64 #expand {
        balance : Table(string, s64);
        table_add(*balance, "FUEL", -amount);

        while true {
            finished := true;
            for * amount, id: balance {
                if amount.* >= 0 continue;
                r := table_find_pointer(*reactions, id);
                if !r continue;
                finished = false;
                mult := (r.yield - amount.* - 1) / r.yield;
                amount.* += mult * r.yield;
                for r.ingredients find_or_add(*balance, it.name).* -= mult * it.amount;
            }
            if finished break;
        }

        return -table_find_pointer(*balance, "ORE").*;
    }

    part1 = ore(1);

    l, r := 1, 100000000;
    while l + 1 < r {
        m := l + (r - l) / 2;
        if ore(m) > 1000000000000 { r = m; } else { l = m; part2 = m; } 
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Ingredient :: struct {
    name : string;
    amount : s64;
    reaction : *Reaction;
}

Reaction :: struct {
    yield : s64;
    ingredients : [..]Ingredient;
}

parse_reactions :: (input: string) -> Table(string, Reaction) {
    reactions : Table(string, Reaction);

    for line: split(trim(input), "\n") {
        parts := split(line, " => ");
        r := Reaction.{ yield = get(s64, *parts[1]) };
        for ingredient: split(parts[0], ", ") {
            array_add(*r.ingredients, Ingredient.{
                amount = get(s64, *ingredient),
                name = ingredient
            });
        }
        table_add(*reactions, parts[1], r);
    }

    for * reaction: reactions {
        for * ingredient: reaction.ingredients {
            ingredient.reaction = table_find_pointer(*reactions, ingredient.name);
        }
    }

    return reactions;
}