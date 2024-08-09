#!/usr/bin/python3

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df_in = pd.read_csv("/discover/nobackup/mgsanbor/matmul/tables/table.dat", skiprows=[0], sep='\s+', names=['build_type', 'time', 'flops', 'flops_time', 'sum_c', 'N'])

df = df_in[[ 'build_type', 'time', 'N' ]]

df.sort_values(by=['build_type', 'N'])

build_types = df['build_type'].unique()

plt.figure(figsize=(12, 8))

for bt in build_types:
    subset = df[df['build_type'] == bt]
    summary = subset.groupby('N')['time'].agg(['mean', 'min', 'max']).reset_index()
    plt.plot(summary['mean'], summary['N'], marker='o', label=f"{bt} mean")
    #plt.fill_between(summary['N'], summary['min'], summary['max'], alpha=0.4)

plt.ylabel('Input Size (N)')
plt.xlabel('Compute Time')
plt.title('N vs. time by compile option')
plt.legend(title='Build type')
plt.grid(True)

plt.show()
