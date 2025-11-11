# Test Scripts for Auto-Update Functionality

This directory contains test scripts and data to verify the auto-update mechanism works correctly.

## Test Files

### 1. `test_auto_update.py`
Test version of the auto-update script that:
- Uses `findsj_test.dta` instead of `findsj.dta`
- Tests the complete update workflow
- Validates BOM encoding handling
- Confirms all article types are processed correctly

### 2. `findsj_test.dta`
Test database with 1,150 records (100 fewer than the complete database):
- Created by removing the last 100 articles from `findsj.dta`
- Used to test if the update script can successfully fetch and add missing articles
- Safe for testing without affecting the production database

### 3. `create_test_data.py`
Script to generate `findsj_test.dta` from `findsj.dta`:
```bash
python create_test_data.py
```

## Running Tests

### Local Testing
```bash
# Create test database
python create_test_data.py

# Run test update
python test_auto_update.py
```

Expected result: The script should find and add 100 missing articles.

### GitHub Actions Testing
The test workflow `.github/workflows/test-auto-update.yml` automatically runs when:
- Manually triggered via workflow_dispatch
- Changes are pushed to main branch affecting relevant files

## Test Validation

The test is successful if:
- ✓ All ~1,228 article IDs are fetched from search page
- ✓ Script identifies 100 missing articles
- ✓ All 100 articles are successfully fetched (100% success rate)
- ✓ BOM-encoded articles (st0785, gn0104, st0766, st0769, gn0103) work correctly
- ✓ Final database contains 1,250 records
- ✓ Backup file is created

## Expected Output

```
======================================================================
Stata Journal Auto-Update Program - TEST VERSION
Time: YYYY-MM-DD HH:MM:SS
Database: findsj_test.dta
Strategy: Fetch all artids from search page and check for new articles
======================================================================

[1] Fetching article list from search page...
    Found 1228 unique article IDs
    Newest: st0780
    Oldest: gr0001

[2] Reading existing database...
    Existing records: 1150

[3] Analyzing new articles...
    Search page articles: 1228
    Existing database: 1150
    New articles: 100

[4] Fetching details for new articles...
    [1/100] st0780... [OK]
    [2/100] st0781... [OK]
    ...
    [100/100] gn0049... [OK]

[5] Backing up original file...
    Backup: findsj_test_backup_YYYYMMDD_HHMMSS.dta

[6] Merging data...

[7] Saving updates...
    Saved successfully: findsj_test.dta

======================================================================
TEST COMPLETED SUCCESSFULLY!
======================================================================
Before: 1150 records
Added:  100 records
After:  1250 records
...
✓ Test script executed successfully!
✓ The update mechanism is working correctly.
======================================================================
```

## Notes

- Test database is intentionally smaller to validate the update mechanism
- The test should complete in ~1-2 minutes (100 articles × 0.5s delay)
- BOM encoding auto-detection ensures compatibility with special articles
- All test files are safe to commit to the repository
