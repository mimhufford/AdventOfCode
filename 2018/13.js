const input = require("./data").day13.split('\n')

const getData = () => {
    const tracks = input.map(line => line.replace(/[v\^]/g, '|').replace(/[><]/g, '-').split(''))
    const carts = []
    input.forEach((line, y) => line.split('').forEach((d, x) => {
        if (d.match(/[\^v<>]/))
            carts.push({ d, x, y, nextTurn: 'l', alive: true })
    }))
    return { tracks, carts }
}

const tick = (tracks, carts) => {
    const order = carts.sort((a, b) => a.y === b.y ? a.x - b.x : a.y - b.y)
    for (const cart of order) {
        if (!cart.alive) continue
        const dx = cart.d === '<' ? -1 : cart.d === '>' ? 1 : 0
        const dy = cart.d === '^' ? -1 : cart.d === 'v' ? 1 : 0
        const nxt = tracks[cart.y + dy][cart.x + dx]
        cart.x += dx
        cart.y += dy
        if (dx === 1 && nxt === '\\') cart.d = 'v'
        else if (dx === 1 && nxt === '/') cart.d = '^'
        else if (dx === -1 && nxt === '/') cart.d = 'v'
        else if (dx === -1 && nxt === '\\') cart.d = '^'
        else if (dy === 1 && nxt === '\\') cart.d = '>'
        else if (dy === 1 && nxt === '/') cart.d = '<'
        else if (dy === -1 && nxt === '/') cart.d = '>'
        else if (dy === -1 && nxt === '\\') cart.d = '<'
        else if (nxt === '+') {
            if (cart.nextTurn === 'l') {
                if (dx === 1) cart.d = '^'
                else if (dx === -1) cart.d = 'v'
                else if (dy === 1) cart.d = '>'
                else if (dy === -1) cart.d = '<'
                cart.nextTurn = 's'
            } else if (cart.nextTurn === 's') {
                if (dx === 1) cart.d = '>'
                else if (dx === -1) cart.d = '<'
                else if (dy === 1) cart.d = 'v'
                else if (dy === -1) cart.d = '^'
                cart.nextTurn = 'r'
            } else if (cart.nextTurn === 'r') {
                if (dx === 1) cart.d = 'v'
                else if (dx === -1) cart.d = '^'
                else if (dy === 1) cart.d = '<'
                else if (dy === -1) cart.d = '>'
                cart.nextTurn = 'l'
            }
        }
        for (const otherCart of carts) {
            if (!otherCart.alive || otherCart === cart) continue
            if (cart.x === otherCart.x && cart.y === otherCart.y)
                otherCart.alive = cart.alive = false
        }
    }
}

const findFirstCrash = ({ tracks, carts }) => {
    while (true) {
        tick(tracks, carts)
        const crashed = carts.filter(cart => !cart.alive)
        if (crashed.length > 0) return `${crashed[0].x},${crashed[0].y}`
    }
}

const findLastCart = ({ tracks, carts }) => {
    while (true) {
        tick(tracks, carts)
        carts = carts.filter(cart => cart.alive)
        if (carts.length === 1) return `${carts[0].x},${carts[0].y}`
    }
}

console.log("Part 1:", findFirstCrash(getData()))
console.log("Part 2:", findLastCart(getData()))