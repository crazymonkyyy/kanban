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

/**
 * Clamps a value between a minimum and maximum
 */
T clamp(T)(T value, T min, T max) {
    if(value < min) return min;
    if(value > max) return max;
    return value;
}

/**
 * T clamptoindex(ref T[] data,ref int i,T init)
 * Ensures any data[i] is valid, if data is empty add a value
 */
T clamptoindex(T)(ref T[] data, ref int i, T init) {
    if(data.length == 0) {
        // If array is empty, append the init value and set index to 0
        data ~= init;
        i = 0;
    } else {
        // Clamp the index to be within valid bounds
        i = clamp(i, 0, cast(int)data.length - 1);
    }
    return data[i];
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

/// Unit tests for clamptoindex function
unittest {
    // Test 1: Empty array case
    int[] emptyArr;
    int idx = 5;  // Any index should become 0 for empty array
    int result = clamptoindex(emptyArr, idx, 42);  // Using 42 as init value
    assert(emptyArr.length == 1, "Empty array should have 1 element after clamptoindex");
    assert(emptyArr[0] == 42, "First element should be the init value");
    assert(idx == 0, "Index should be set to 0 for empty array");
    assert(result == 42, "Function should return the init value");
    
    // Test 2: Index too high
    int[] arr = [10, 20, 30];
    idx = 5;  // Out of bounds
    result = clamptoindex(arr, idx, 99);  // init value shouldn't be used
    assert(idx == 2, "Index should be clamped to array length - 1");
    assert(result == 30, "Function should return the last element");
    
    // Test 3: Index too low (negative)
    idx = -3;  // Negative index
    result = clamptoindex(arr, idx, 99);  // init value shouldn't be used
    assert(idx == 0, "Index should be clamped to 0");
    assert(result == 10, "Function should return the first element");
    
    // Test 4: Valid index
    idx = 1;  // Valid index
    result = clamptoindex(arr, idx, 99);  // init value shouldn't be used
    assert(idx == 1, "Index should remain unchanged when valid");
    assert(result == 20, "Function should return the element at the valid index");
    
    // Test 5: Boundary case - exact length
    arr = [100, 200, 300];
    idx = 3;  // Exactly at the length (one past last valid index)
    result = clamptoindex(arr, idx, 999);
    assert(idx == 2, "Index should be clamped to length - 1");
    assert(result == 300, "Function should return the last element");
    
    // Test 6: Test with int[][] (2D array)
    int[][] matrix;
    idx = 2;  // Index for the outer array
    int[] defaultRow = [0, 0, 0];  // Default row to add if matrix is empty
    int[] rowResult = clamptoindex(matrix, idx, defaultRow);
    assert(matrix.length == 1, "Matrix should have 1 row after clamptoindex with empty matrix");
    assert(matrix[0] == defaultRow, "First row should be the default row");
    assert(idx == 0, "Index should be set to 0 for empty matrix");
    assert(rowResult == defaultRow, "Function should return the default row");
    
    // Add more rows to test with non-empty matrix
    matrix ~= [1, 2, 3];  // Add second row
    matrix ~= [4, 5, 6];  // Add third row
    idx = 5;  // Index out of bounds
    rowResult = clamptoindex(matrix, idx, [9, 9, 9]);  // Should clamp to existing rows
    assert(idx == 2, "Index should be clamped to matrix length - 1");
    assert(rowResult == matrix[2], "Function should return the last row");
    assert(rowResult == [4, 5, 6], "Last row should have correct values");
    
    writeln("All clamptoindex tests passed!");
}

/// When compiled with -unittest flag, this module will run its unit tests
unittest {
    // This empty unittest block ensures the module can be compiled with -unittest flag
}