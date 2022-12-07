day7 :: (input: string) -> string, string
{
    root := parse_log(input);

    part1 := 0;
    part2 := S64_MAX;

    queue : [..]*Directory;
    array_add(*queue, root);
    while queue.count
    {
        dir := pop(*queue);
        if dir.size <= 100000 part1 += dir.size;
        if dir.size >= root.size - 40000000 && dir.size < part2 part2 = dir.size;
        for * dir.children array_add(*queue, it);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Directory :: struct
{
    name     : string;
    size     : s64;
    parent   : *Directory;
    children : [..]Directory;
}

parse_log :: (log: string) -> *Directory
{
    root := New(Directory);
    root.name = "/";

    cwd := root;

    while log.count && log[0] == #char "$"
    {
        advance(*log, 2);
        if log[0] == #char "c" // cd
        {
            advance(*log, 3);
            dir_name := read_word(*log);
            if dir_name == ".." cwd = cwd.parent;
            else for * cwd.children if it.name == dir_name cwd = it;
        }
        else // ls
        {
            advance(*log, 3);
            while log.count && log[0] != #char "$"
            {
                if log[0] == #char "d" // dir
                {
                    advance(*log, 4);
                    dir_name := read_word(*log);
                    dir := array_add(*cwd.children);
                    dir.name = dir_name;
                    dir.parent = cwd;
                }
                else // file
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
            }
        }
    }

    return root;
}