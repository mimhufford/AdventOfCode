day7 :: (input: string) -> string, string
{
    dirs := parse_log(input);

    part1 := 0;
    part2 := S64_MAX;

    for dirs
    {
        if it.size <= 100000 part1 += it.size;
        if it.size >= dirs[0].size - 40000000 && it.size < part2 part2 = it.size;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Directory :: struct
{
    name     : string;
    size     : s64;
    parent   : *Directory;
}

parse_log :: (log: string) -> []*Directory
{
    dirs : [..]*Directory;
    cwd  : *Directory;

    while log.count
    {
        if log[0] == #char "$" && log[2] == #char "c"
        {
            advance(*log, 5);
            dir_name := read_word(*log);
            if dir_name == ".." cwd = cwd.parent;
            else
            {
                dir := New(Directory);
                dir.name = dir_name;
                dir.parent = cwd;
                array_add(*dirs, dir);
                cwd = dir;
            }
        }
        else if is_digit(log[0])
        {
            size := read_s64(*log);
            read_word(*log);
            dir := cwd;
            while dir
            {
                dir.size += size;
                dir = dir.parent;
            }
        }
        else skip_to_next_line(*log);
    }

    return dirs;
}