#Warning - extreamly dangerous, exec not parsed in any way, just
#executing code.

s = input("[>] Specify function (x, y):\n[>] ")

exec("f = lambda x, y: int("+s+")")

array = []

for x in range(201):
    p_array = []
    for y in range(201):
        p_array.append(f(x, y))
    array.append(p_array)

filename = input("[>] Specify filename\n[>] ")
with open(filename, "w+") as f:
    for line in array:
        for element in line:
            f.write(str(element))
            f.write(" ")
        f.write("\n")
