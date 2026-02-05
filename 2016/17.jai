day17 :: (data: string) -> string, string
{
    solve :: (key: string, worst: *s64, best: *s64, best_path: *string, x: s64 = 0, y: s64 = 0, steps: s64 = 0, path: string = "")
    {
        if x == 3 && y == 3 {
            if steps < best.*  {  best.* = steps; best_path.* = path; }
            if steps > worst.* { worst.* = steps; }
            return;
        }

        #import "md5";
        dirs := md5(tprint("%1%2", key, path));
        if y>0 && dirs[0] >= #char "b" && dirs[0]<= #char "f" solve(key, worst, best, best_path, x, y-1, steps + 1, tprint("%U", path));
        if y<3 && dirs[1] >= #char "b" && dirs[1]<= #char "f" solve(key, worst, best, best_path, x, y+1, steps + 1, tprint("%D", path));
        if x>0 && dirs[2] >= #char "b" && dirs[2]<= #char "f" solve(key, worst, best, best_path, x-1, y, steps + 1, tprint("%L", path));
        if x<3 && dirs[3] >= #char "b" && dirs[3]<= #char "f" solve(key, worst, best, best_path, x+1, y, steps + 1, tprint("%R", path));
    }

    key := data; key.count -= 1;

    best := S64_MAX;
    worst := S64_MIN;
    shortest_path : string = ---;

    solve(key, *worst, *best, *shortest_path);

    return tprint("%", shortest_path), tprint("%", worst);
}