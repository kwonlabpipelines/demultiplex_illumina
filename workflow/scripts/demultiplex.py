from Bio import SeqIO
import csv

def get_matching_ids(barcodes1, barcodes2):
    for rec1, rec2 in zip(barcodes1, barcodes2):
        if str(rec1.seq) in barcode_map.keys():
            if str(rec2.seq) in barcode_map.keys():
                if barcode_map[str(rec1.seq)] == snakemake.wildcards.sample and barcode_map[str(rec2.seq)] == snakemake.wildcards.sample:
                    yield rec1.id
                    
def get_matching_reads(reads, matching_ids):
    for rec in reads:
        if rec.id in matching_ids:
            yield rec
        continue

if __name__=="__main__":
    with open(snakemake.input.barcode_map, "r") as f:
        reader = csv.DictReader(f)
        parsed_list = [row for row in reader]
        barcode_map = {}
        for row in parsed_list:
            if row["sample"] == snakemake.wildcards.sample:
                barcode_map[row["i7_barcode"]] = row["sample"]
                barcode_map[row["i5_barcode"]] = row["sample"]

    with open(snakemake.input.i1_barcodes, "r") as f1, open(snakemake.input.i2_barcodes, "r") as f2:
        barcodes1 = SeqIO.parse(f1, "fastq")
        barcodes2 = SeqIO.parse(f2, "fastq")
        matching_ids = set(get_matching_ids(barcodes1, barcodes2))

    with open(snakemake.input.forward_reads, "r") as fin, open(snakemake.output.forward_reads, "w") as fout:
        SeqIO.write(get_matching_reads(SeqIO.parse(fin, "fastq"), matching_ids), fout, "fastq")

    with open(snakemake.input.reverse_reads, "r") as fin, open(snakemake.output.reverse_reads, "w") as fout:
        SeqIO.write(get_matching_reads(SeqIO.parse(fin, "fastq"), matching_ids), fout, "fastq")


