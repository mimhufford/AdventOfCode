day21 :: (input: string) -> string, string
{
    foods : [..]Food;
    while input.count array_add(*foods, read_line(*input));

    allergens : [..]Allergen;
    for food: foods
    {
        for allergen: food.allergens
        {
            all : *Allergen;
            for * allergens if it.name == allergen { all = it; break; }
            if all
            {
                // do intersection
                for all.ingredients if !array_find(food.ingredients, it) remove it;
            }
            else
            {
                all : Allergen;
                all.name = allergen;
                for food.ingredients array_add(*all.ingredients, it);
                array_add(*allergens, all);
            }
        }
    }

    while true
    {
        for * a: allergens
        {
            if a.ingredients.count == 1
            {
                for * b: allergens
                {
                    if a == b continue;

                    array_ordered_remove_by_value(*b.ingredients, a.ingredients[0]);
                }
            }
        }

        all_1 := true;
        for * allergens if it.ingredients.count != 1 { all_1 = false; break; }
        if all_1 break;
    }

    confirmed_allergens : [..]string;
    for allergens array_add(*confirmed_allergens, it.ingredients[0]);
    part1 : u64;

    for foods for it.ingredients if !array_find(confirmed_allergens, it) part1 += 1;

    quick_sort(allergens, (a,b) => compare_strings(a.name, b.name));
    str : String_Builder;
    for allergens append(*str, tprint("%,", it.ingredients[0]));
    part2 := builder_to_string(*str);
    part2.count -= 1;
    return tprint("%", part1), part2;
}

Food :: struct
{
    ingredients : [..]string;
    allergens   : [..]string;
}

Allergen :: struct
{
    name : string;
    ingredients : [..]string;
}

read_line :: (s: *string) -> Food
{
    result : Food;

    // ingredients
    while s.data[0] != #char "("
    {
        ing : string;
        ing.data = s.data;
        while s.data[0] != #char " "
        {
            ing.count += 1;
            advance(s);
        }
        advance(s);
        array_add(*result.ingredients, ing);
    }

    quick_sort(result.ingredients, compare_strings);

    advance(s, 10); // "(contains "

    // allergens
    while s.data[0] != #char ")"
    {
        all : string;
        all.data = s.data;
        while s.data[0] != #char "," && s.data[0] != #char ")"
        {
            all.count += 1;
            advance(s);
        }
        if s.data[0] == #char "," advance(s, 2);
        array_add(*result.allergens, all);
    }

    advance(s);

    if s.count advance(s);

    return result;
}