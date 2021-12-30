day19 :: (data: string) -> string, string
{
    replacements, molecule := read_replacements_and_molecule(data);

    unqiue_calibrations := calibrate(molecule, replacements);
    steps_to_reduce     := reduce(molecule);

    return tprint("%", unqiue_calibrations), tprint("%", steps_to_reduce);
}

Replacement :: struct
{
    src: string;
    dst: string;
}

read_replacements_and_molecule :: (s: string) -> []Replacement, string
{
    replacements : [..]Replacement;
    molecule : string;

    lines := split(s, "\n");

    for 0..lines.count-4
    {
        parts := split(lines[it], " => ");
        replacement : Replacement;
        replacement.src = parts[0];
        replacement.dst = parts[1];
        array_add(*replacements, replacement);
    }

    return replacements, lines[lines.count-2];
}

calibrate :: (molecule: string, replacements: []Replacement) -> s64
{
    new_molecules : [..]string;

    for char_index: 0..molecule.count-1
    {
        part := molecule;
        part.data += char_index;
        part.count = 1;

        before := molecule;
        before.count = char_index;
        after := molecule;
        advance(*after, char_index+1);

        for replacement: replacements
        {
            if replacement.src == part 
            {
                new_molecule := tprint("%1%2%3", before, replacement.dst, after);
                array_add_if_unique(*new_molecules, new_molecule);
            }
        }

        if char_index >= molecule.count-1 continue;

        part.count = 2;
        advance(*after, 1);

        for replacement: replacements
        {
            if replacement.src == part 
            {
                new_molecule := tprint("%1%2%3", before, replacement.dst, after);
                array_add_if_unique(*new_molecules, new_molecule);
            }
        }
    }

    return new_molecules.count;
}

reduce :: (molecule: string) -> s64
{
    total_elements := 0;
    Rn_and_Ar_count := 0;
    Y_count := 0;

    while molecule.count
    {
        total_elements += 1;
        element := molecule;
        element.count = 1;
        advance(*molecule, 1); // skip the capital letter

        while molecule.count && molecule[0] >= #char "a" && molecule[0] <= #char "z"
        {
            element.count += 1;
            advance(*molecule, 1);
        }

        if element == "Rn" || element == "Ar" Rn_and_Ar_count += 1;
        else if element == "Y" Y_count += 1;
    }

    return total_elements - Rn_and_Ar_count - 2*Y_count - 1;
}