day17 :: (data: string) -> string, string
{
    key := data; key.count -= 1;

    best := S64_MAX;
    path : string = ---;

    solve(key, *best, *path);

    solve :: (key: string, best: *s64, best_path: *string, x: s64 = 0, y: s64 = 0, steps: s64 = 0, path: string = "")
    {
        if x < 0 || y < 0 return;
        if x > 3 || y > 3 return;
        if steps > <<best return;
        if x == 3 && y == 3 { if steps < <<best { <<best = steps; <<best_path = path; } return; }

        dirs := md5(tprint("%1%2", key, path));
        if dirs[0] >= #char "b" && dirs[0]<= #char "f" solve(key, best, best_path, x, y-1, steps + 1, tprint("%U", path));
        if dirs[1] >= #char "b" && dirs[1]<= #char "f" solve(key, best, best_path, x, y+1, steps + 1, tprint("%D", path));
        if dirs[2] >= #char "b" && dirs[2]<= #char "f" solve(key, best, best_path, x-1, y, steps + 1, tprint("%L", path));
        if dirs[3] >= #char "b" && dirs[3]<= #char "f" solve(key, best, best_path, x+1, y, steps + 1, tprint("%R", path));
    }

    return tprint("%", path), tprint("%", "");
}

#scope_file;
#import "md5";