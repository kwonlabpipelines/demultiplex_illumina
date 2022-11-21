
rule fastqc:
    input:
        "output/{sample}.{direction}.fq"
    output:
        html="output/qc/fastqc/{sample}.{direction}.html",
        zip="output/qc/fastqc/{sample}.{direction}_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: "--quiet"
    log:
        "logs/fastqc/{sample}.{direction}.log"
    threads: 1
    wrapper:
        "0.78.0/bio/fastqc"
