#!/usr/bin/false3

# Note: requires libraries to be available. Consider importing python/GEOSpyD/Min24.4.0-0_py3.12 or similar

# Imports
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Load data
df = pd.read_csv("/discover/nobackup/mgsanbor/matmul/tables/table.dat", header=None, sep='\s+') # delim_whitespace=True

# Denote column names
df.columns = [ "build_type", "time", "flops", "flops_time", "sum_c", "N" ]

# Keep only relevant info
df_plot = df[[ "build_type", "N", "time" ]]

# Try to convert to numeric
df_plot["N"] = pd.to_numeric(df_plot["N"], errors="coerce")
df_plot["time"] = pd.to_numeric(df_plot["time"], errors="coerce")

# Discard missing values
df_plot.dropna(subset=["N", "time"], inplace=True)

# Jitter offset
j_offs = 0

# Build plot
plt.figure(figsize=(10, 6))

unique_groups = df_plot["build_type"].unique()
#group_offsets = np.linspace(-0.5, 0.5, len(unique_groups))

#for offset, build_type in zip(group_offsets, unique_groups):
for build_type in unique_groups:
    group_data = df_plot[df_plot["build_type"] == build_type]
    #jittered_x = group_data["N"] + offset * 400 # apply offset
    plt.scatter(group_data["N"], group_data["time"], label=build_type, alpha=0.7)
    #plt.plot(jittered_x, group_data["time"], label=build_type)
    #plt.scatter(group_data["time"], group_data["N"], label=build_type, alpha=0.7)
    #plt.plot(group_data["time"], group_data["N"], 'o-', label=build_type, alpha=0.7)

plt.xlabel("N")
plt.ylabel("Time")
plt.title("Time by compile type")
plt.legend(title="Type:")
plt.grid(True)
plt.show()

