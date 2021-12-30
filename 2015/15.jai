day15 :: (data: string) -> string, string
{
    ingredients : [..]Ingredient;

    lines := split(data, "\n");
    lines.count -= 1;

    for lines
    {
        parts := split(it, " ");
        i : Ingredient;
        i.capacity   = string_to_int(parts[2]);
        i.durability = string_to_int(parts[4]);
        i.flavour    = string_to_int(parts[6]);
        i.texture    = string_to_int(parts[8]);
        i.calories   = string_to_int(parts[10]);
        array_add(*ingredients, i);
    }

    part_1 := 0;
    part_2 := 0;

    for a: 0..100 for b: 0..100 for c: 0..100 for d: 0..100 // this is dumb
    {
        if a+b+c+d != 100 continue;

        amounts: [4]int; amounts[0] = a; amounts[1] = b; amounts[2] = c; amounts[3] = d;

        capacity: int;
        durability: int;
        flavour: int;
        texture: int;
        calories: int;

        for ingredients
        {
            capacity   += it.capacity   * amounts[it_index];
            durability += it.durability * amounts[it_index];
            flavour    += it.flavour    * amounts[it_index];
            texture    += it.texture    * amounts[it_index];
            calories   += it.calories   * amounts[it_index];
        }

        capacity   = max(0, capacity);
        durability = max(0, durability);
        flavour    = max(0, flavour);
        texture    = max(0, texture);

        score := capacity * durability * flavour * texture;
        part_1 = max(score, part_1);
        if calories == 500 part_2 = max(score, part_2);
    }

    return tprint("%", part_1), tprint("%", part_2);
}

Ingredient :: struct
{
    capacity: int;
    durability: int;
    flavour: int;
    texture: int;
    calories: int;
}