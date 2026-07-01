globalvar arr1
globalvar arr2
rule "test":
    @Event global
    arr2 = [100 if arr1[i] == 5 else arr2[i] for i in range(len(arr1))]
