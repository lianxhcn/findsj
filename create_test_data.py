#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Create test database for GitHub Actions testing
Remove last 100 records from findsj.dta to create findsj_test.dta
"""

import pandas as pd

# Read complete database
print("Reading complete database (findsj.dta)...")
df = pd.read_stata('findsj.dta', preserve_dtypes=False)
print(f"Total records: {len(df)}")

# Remove last 100 records
df_test = df.iloc[:-100].copy()
print(f"After removing last 100 records: {len(df_test)}")

# Save test database
try:
    df_test.to_stata('findsj_test.dta', write_index=False, version=117)
    print(f"\n✓ Created: findsj_test.dta ({len(df_test)} records)")
except:
    # If encoding issues, convert to strl
    for col in df_test.columns:
        if df_test[col].dtype == 'object':
            df_test[col] = df_test[col].astype('str')
    df_test.to_stata('findsj_test.dta', write_index=False, version=117, 
                    convert_strl=['title', 'author'])
    print(f"\n✓ Created: findsj_test.dta ({len(df_test)} records) [with strl conversion]")

print(f"\nTest database summary:")
print(f"  First article: {df_test.iloc[0]['artid']}")
print(f"  Last article: {df_test.iloc[-1]['artid']}")
print(f"  Records removed: {len(df) - len(df_test)}")
print(f"  Records in test file: {len(df_test)}")
