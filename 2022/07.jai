day7 :: (input: string) -> string, string
{
    root := parse_log(input);
    used := calculate_size(root);
    need := 30000000 - (70000000 - used);
    return tprint("%", sum_sizes_lte_100000(root)), tprint("%", find_best_dir_to_delete(root, need));
}

#scope_file

Directory :: struct
{
    name     : string;
    size     : s64;
    parent   : *Directory;
    children : [..]*Directory;
    files    : s64;
}

find_best_dir_to_delete :: (dir: *Directory, minimum: s64) -> s64
{
    if dir.size < minimum return S64_MAX;
    best := dir.size;
    for dir.children best = min(best, find_best_dir_to_delete(it, minimum));
    return best;
}

sum_sizes_lte_100000 :: (dir: *Directory) -> s64
{
    size : s64;
    if dir.size <= 100000 size += dir.size;
    for dir.children size += sum_sizes_lte_100000(it);
    return size;
}

calculate_size :: (dir: *Directory) -> s64
{
    dir.size += dir.files;
    for dir.children dir.size += calculate_size(it);
    return dir.size;
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
            else for cwd.children if it.name == dir_name cwd = it;
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
                    dir := New(Directory);
                    dir.name = dir_name;
                    dir.parent = cwd;
                    array_add(*cwd.children, dir);
                }
                else // file
                {
                    size := read_s64(*log);
                    name := read_word(*log);
                    cwd.files += size;
                }
            }
        }
    }

    return root;
}