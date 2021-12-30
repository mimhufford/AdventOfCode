day19 :: (data: string) -> string, string
{
    new_molecules : [..]string;
    replacements : [..]Replacement;
    molecule : string;

    lines := split(data, "\n");
    molecule = lines[lines.count-2];

    for 0..lines.count-4
    {
        parts := split(lines[it], " => ");
        replacement : Replacement;
        replacement.src = parts[0];
        replacement.dst = parts[1];
        array_add(*replacements, replacement);
    }

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

    return tprint("%", new_molecules.count), tprint("%", "");
}

Replacement :: struct
{
    src: string;
    dst: string;
}