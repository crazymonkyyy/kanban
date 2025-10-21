module utility;

import std;

/**
 * Clamps an index to be within the bounds of an array
 * Ensures that i is >= 0 and < a.length
 * If array is empty, extends it with a default element
 */
ref T clampindex(T, I)(ref T[] a, ref I i) {
    if(i<0||i==I.max) {
        writeln("WARNING: clampindex called with negative or max value: ", i);
        i=0;
    }
    if(a.length==0) {
        // If array is empty, just set i to 0 and extend the array with a default element
        writeln("WARNING: clampindex called with empty array, extending with default element");
        i=0;
        a ~= T.init;  // Append a default-initialized element
    }
    if(cast(size_t)i >= a.length) {
        if(a.length == 0) {
            i = 0;
        } else {
            writeln("WARNING: clampindex clamping index ", i, " to ", cast(I)(a.length - 1));
            i = cast(I)(a.length - 1);
        }
    }
    return a[i];
}

unittest {
    // Basic functionality tests
    int[] arr = [1, 2, 3, 4, 5];
    int idx = 2;
    auto ref_elem = clampindex(arr, idx);
    assert(idx == 2);
    assert(ref_elem == 3);
    
    // Test clamping to upper bound
    idx = 10;  // Out of bounds
    auto ref_elem2 = clampindex(arr, idx);
    assert(idx == 4);  // Should be clamped to length-1
    assert(ref_elem2 == 5);
    
    // Test clamping to lower bound
    idx = -5;  // Negative
    auto ref_elem3 = clampindex(arr, idx);
    assert(idx == 0);  // Should be clamped to 0
    assert(ref_elem3 == 1);
    
    // Test with max value - should be set to 0 like negative values
    idx = int.max;
    auto ref_elem4 = clampindex(arr, idx);
    assert(idx == 0);  // Should be reset to 0 (matching original behavior)
    assert(ref_elem4 == 1);  // Should be the first element of the array (arr[0] = 1)
    
    // Test with empty array
    int[] empty_arr;
    writeln("Before: empty_arr.length = ", empty_arr.length, ", idx = 5");
    idx = 5;
    auto ref_elem5 = clampindex(empty_arr, idx);
    writeln("After: empty_arr.length = ", empty_arr.length, ", idx = ", idx, ", ref_elem5 = ", ref_elem5);
    assert(idx == 0);  // Should be set to 0
    assert(ref_elem5 == 0);  // Default initialized value
    assert(empty_arr.length == 1);  // Should have one default element
    
    writeln("All basic clampindex tests passed!");
}

// Fuzzing tests for clampindex function
unittest {
    import std.random : randomSample, uniform, rndGen;
    import std.range : iota;
    import std.format : format;
    import std.algorithm : min;
    
    // Run multiple randomized tests
    foreach(test_num; 0..1000) {
        // Generate random array size
        int arr_size = uniform(0, 100, rndGen);
        int[] test_arr = new int[arr_size];
        foreach(i; 0..arr_size) {
            test_arr[i] = i;  // Fill with index values for easy verification
        }
        
        // Generate random index to test
        int test_idx = uniform(-100, 200, rndGen);  // Range includes negative and out-of-bounds
        int original_idx = test_idx;
        
        // Apply clampindex
        auto ref_elem = clampindex(test_arr, test_idx);
        
        // Verify the index is properly clamped
        if(arr_size == 0) {
            assert(test_idx == 0, format("Empty array test %d: expected idx=0, got %d", test_num, test_idx));
            assert(ref_elem == 0, format("Empty array test %d: expected ref_elem=0, got %d", test_num, ref_elem)); // Default initialized value
            assert(test_arr.length == 1, format("Empty array test %d: expected length=1, got %d", test_num, test_arr.length));
        } else {
            int expected_idx = test_idx;
            // In the original implementation, both negative and max values are set to 0
            if(expected_idx < 0 || expected_idx == int.max) {
                expected_idx = 0;
            } else if(expected_idx >= arr_size) {
                expected_idx = arr_size - 1;
            }
            
            assert(test_idx == expected_idx, 
                   format("Test %d: expected idx=%d, got %d (original was %d, arr_size=%d)", 
                          test_num, expected_idx, test_idx, original_idx, arr_size));
            
            // ref_elem should be the value at the clamped index, not the index itself
            // Note: clampindex may have modified the array (e.g., by extending an empty array)
            // So we should check the value in the array after the clampindex call
            if (ref_elem != test_arr[test_idx]) {
                writeln(format("Fuzz test %d FAILED: ref_elem=%d, test_arr[test_idx]=%d, test_idx=%d, original_idx=%d, arr_size=%d", 
                              test_num, ref_elem, test_arr[test_idx], test_idx, original_idx, arr_size));
                if (test_arr.length > 0) {
                    writeln("First few elements of test_arr: ", test_arr[0..min(5, test_arr.length)]);
                } else {
                    writeln("test_arr is empty");
                }
            }
            assert(ref_elem == test_arr[test_idx], 
                   format("Test %d: expected ref_elem=%d, got %d (test_arr[%d]=%d)", 
                          test_num, test_arr[test_idx], ref_elem, test_idx, test_arr[test_idx]));
        }
    }
    
    writeln("Fuzzing tests for clampindex passed!");
}

/// When compiled with -unittest flag, this module will run its unit tests
unittest {
    // This empty unittest block ensures the module can be compiled with -unittest flag
}