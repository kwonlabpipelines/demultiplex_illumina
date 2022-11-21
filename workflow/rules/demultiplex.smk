import os
import csv

with open(config["barcodes"], "r") as f:
    reader = csv.DictReader(f)
    parsed_list = [row for row in reader]
    print(parsed_list)

ALL_SAMPLES = [row["sample"] for row in parsed_list]

rule gunzip_file:
    input:
        os.path.join(config["demultiplex"]["raw_reads_directory"], "{file}.fastq.gz")
    output:
        temp("temp/{file}.fastq")
    shell:
        "gunzip -c {input} > {output}"


rule demultiplex:
    input:
        forward_reads = "temp/Undetermined_S0_L001_R1_001.fastq",
        reverse_reads = "temp/Undetermined_S0_L001_R2_001.fastq",
        i1_barcodes = "temp/Undetermined_S0_L001_I1_001.fastq",
        i2_barcodes = "temp/Undetermined_S0_L001_I2_001.fastq",
        barcode_map = "config/barcodes.csv"
    output:
        forward_reads = "output/{sample}.f.fq",
        reverse_reads = "output/{sample}.r.fq"
    conda:
        "../envs/biopython.yaml"
    script:
        "scripts/demultiplex.py"