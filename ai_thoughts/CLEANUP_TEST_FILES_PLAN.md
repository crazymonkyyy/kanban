# Action Plan: Clean Up Test Files and Organize Kantban Files

## Objective
Clean up worthless test files, organize .kantban files, and improve file organization.

## Current State Analysis

### Worthless Test Files
Found multiple files with `test_` prefix that are worthless:
- `test_formatting.d` - Simple function with basic formatting
- `test_formatting2.d` - Same function with different spacing
- `test_formatting3.d` - Same function with different spacing
- `test_formatting4.d` - Same function with different spacing
- `test_formatting5.d` - Same function with different spacing
- `test_complex.d` - Appears to be a complex test but likely worthless
- `test_corrupt.kantban` - Corrupted kanban file for testing
- `test_copy.kantban` - Copy of kanban file for testing
- `test_copy.kantban.corrupted` - Corrupted copy of kanban file

### Kantban Files
Found multiple .kantban files:
- `TODO.kantban` - Main kanban file (should be kept)
- `minimal.kantban` - Minimal kanban file (should be kept)
- `checkbox_test.kantban` - Checkbox testing file (should be kept)
- `test.kantban` - Test kanban file (likely worthless)
- `test_corrupt.kantban` - Corrupted kanban file for testing (worthless)
- `test_copy.kantban` - Copy of kanban file for testing (worthless)
- `test_copy.kantban.corrupted` - Corrupted copy of kanban file (worthless)

## Action Plan

### Phase 1: Delete Worthless Test Files (Today)
1. Delete all `test_formatting*.d` files (5 files)
2. Delete `test_complex.d` file
3. Delete `test_corrupt.kantban` file
4. Delete `test_copy.kantban` file
5. Delete `test_copy.kantban.corrupted` file
6. Delete `test.kantban` file

### Phase 2: Organize Remaining Kantban Files (Today)
1. Create `samples/` directory for sample kanban files
2. Move `minimal.kantban` to `samples/` directory
3. Move `checkbox_test.kantban` to `samples/` directory
4. Update any references to these files in documentation or code

### Phase 3: Verify Changes (Today)
1. Test that application still works with remaining files
2. Verify no broken references to deleted files
3. Update documentation if needed

### Implementation Notes
- All changes should be made directly to the main branch (NO BRANCHES)
- Commit changes incrementally with descriptive messages
- Test each change before proceeding to the next
- Use direct commits to main branch for all cleanup work

## Files to Keep
- `TODO.kantban` - Main application file
- `minimal.kantban` - Sample file (moved to samples/)
- `checkbox_test.kantban` - Sample file (moved to samples/)

## Expected Outcome
- Reduced file clutter by removing 9 worthless test files
- Better organization with sample files in dedicated directory
- Cleaner repository structure
- No impact on core application functionality

## Timeline
- **Phase 1**: 30 minutes
- **Phase 2**: 30 minutes
- **Phase 3**: 30 minutes
- **Total**: 1.5 hours