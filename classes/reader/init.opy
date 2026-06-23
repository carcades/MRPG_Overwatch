#!mainFile "../../main.opy"

rule "Reader: init holy circle":
    reader_holy_circle_vectors = []
    for reader_holy_circle_iter_vectors in range(10):
        reader_holy_circle_vectors.append((directionFromAngles((reader_holy_circle_iter_vectors + 1) * (360 / 10), 0)) * 4)
        wait(0.1)
