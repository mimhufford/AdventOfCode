day10 :: (input: string) -> string, string
{
    part1, part2 := 0;

    Asteroid :: struct { x, y, visible, distance: s64; angle: float; }
    asteroids : [..]Asteroid;

    for y: 0..30 for x: 0..30 {
        if input[y * 32 + x] != "#" continue;
        array_add(*asteroids, {x=x, y=y});
    }

    for i: 0..asteroids.count-1 {
        a := *asteroids[i];
        for j: i+1..asteroids.count-1 {
            b := *asteroids[j];
            dx, dy := b.x - a.x, b.y - a.y;
            steps := abs(gcd(dx, dy));
            step_x, step_y := dx / steps, dy / steps;

            for step: 1..steps-1 {
                x, y := a.x + step * step_x, a.y + step * step_y;
                if input[y * 32 + x] == "#" continue j;
            }

            a.visible, b.visible += 1;
        }
    }

    laser : *Asteroid;
    for * asteroids {
        if it.visible <= part1 continue;
        part1, laser = it.visible, it;
    }

    angle_group : Table(float, [..]*Asteroid);
    angles : [..]float;

    for * a: asteroids {
        if a == laser continue;
        dx, dy := laser.x - a.x, laser.y - a.y;
        a.distance = dx*dx + dy*dy;
        a.angle = -atan2(dx.(float), dy.(float));
        if a.angle < 0 a.angle += TAU;
        array_add_if_unique(*angles, a.angle);
    }

    quick_sort(asteroids, a => -a.distance);
    quick_sort(angles, a => a);

    for * a: asteroids {
        if a == laser continue;
        group := find_or_add(*angle_group, a.angle);
        array_add(group, a);
    } 

    for index: 0..S64_MAX {
        angle := angles[index % angles.count];
        group := find_or_add(*angle_group, angle);
        if group.count == 0 continue;
        destroy := pop(group);
        part2 += 1;
        if part2 < 199 continue;
        part2 = destroy.x * 100 + destroy.y;
        break;
    }

    return tprint("%", part1), tprint("%", part2);
}