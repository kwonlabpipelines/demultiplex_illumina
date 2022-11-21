
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

rule multiqc:
    input:
        expand("output/qc/fastqc/{sample}.{direction}.html", sample=ALL_SAMPLES, direction = ["f", "r"])
    output:
        "output/qc/multiqc.html"
    params:
        ""  # Optional: extra parameters for multiqc.
    log:
        "logs/multiqc.log"
    wrapper:
        "1.19.1/bio/multiqc"