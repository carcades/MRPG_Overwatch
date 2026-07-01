#!mainFile "../main.opy"

rule "Test mapped array index":
    @Event global
    
    globalvar arr1
    globalvar arr2
    globalvar res1
    globalvar res2
    globalvar res3
    
    arr1 = [10, 20, 30]
    arr2 = [100, 200, 300]
    
    # syntax 1: arr1.index(x)
    res1 = [arr2[arr1.index(x)] for x in arr1]
    
    # syntax 2: can we map over something else?
    # What if we mapped over evalOnce(arr1)? No, evalOnce is for dynamic evaluation inside mapped array.
    
    # Wait, what if we use range inside mapped array?
    # res2 = [x for x in range(len(arr1))] # this throws 'Iterator' error
    
    # Let's try evalOnce
    res3 = [evalOnce(arr1.index(x)) for x in arr1]
