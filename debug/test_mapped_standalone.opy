globalvar INDEX_ARRAY
globalvar arr1
globalvar arr2
globalvar res1
globalvar buffId
globalvar newExpire

rule "Test mapped array index over predefined array":
    @Event global
    
    INDEX_ARRAY = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    arr1 = [10, 20, 10, 30] # active_buff_ids
    arr2 = [100, 200, 300, 400] # active_buff_expire_times
    buffId = 10
    newExpire = 999
    
    # slice the index array to the length of arr1
    # then map over it.
    res1 = [newExpire if arr1[x] == buffId else arr2[x] for x in INDEX_ARRAY.slice(0, len(arr1))]
