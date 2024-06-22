min = 200000000000000
max = 400000000000000


class HailStone:
    def __init__(self, x, y, z, vx, vy, vz) -> None:
        self.x = int(x)
        self.y = int(y)
        self.z = int(z)
        self.vx = int(vx)
        self.vy = int(vy)
        self.vz = int(vz)

    @staticmethod
    def findForwardIntersect2d(i, j):
        ai = i.vy
        bi = -i.vx
        ci = i.vy * i.x - i.vx * i.y

        dj = j.vy
        ej = -j.vx
        fj = j.vy * j.x - j.vx * j.y

        try:
            xIntersect = (fj / ej - ci / bi) / ((dj / ej) - (ai / bi))
        except ZeroDivisionError:
            return None, None

        yIntersect = (fj / dj - ci / ai) / (ej / dj - bi / ai)
        ti = (xIntersect - i.x) * i.vx
        tj = (xIntersect - j.x) * j.vx
        if ti >= 0 and tj >= 0:
            return xIntersect, yIntersect

        return None, None


positionStrings = [
    [i.split(",") for i in line.strip().split("@")]
    for line in open("input.txt").readlines()
]
hailStorm = [
    HailStone(i[0][0], i[0][1], i[0][2], i[1][0], i[1][1], i[1][2])
    for i in positionStrings
]

count = 0
for i, hail in enumerate(hailStorm):
    for j in range(i + 1, len(hailStorm)):
        x, y = HailStone.findForwardIntersect2d(hail, hailStorm[j])

        if x != None and y != None and (min <= x <= max) and (min <= y <= max):
            count += 1

print(count)
