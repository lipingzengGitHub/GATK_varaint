#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params {
    reads = ‘RawData/*_{1,2}.fq.gz’
    genome = 'Ref/ref.fa'
    annotation = 'Ref/ref.gtf'
    output_dir = './results'
}

Channel
    .fromFilePairs(params.reads, flat:true)
    .set { read_pairs_ch}

process fastqc {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)

    output:
    path("${sample_id}/fastqc")

    script
    """
    mkdir -p ${sample_id}/fastqc
    fastqc ${reads.join(' ')} -o ${sample_id}/fastqc
    """
}

process bwa_align {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)
    path(genome)

    output:
    path("${sample_id}/bwa")

    script:
    """
    mkdir -p ${sample_id}/bwa
    bwa mem -t 4 ${genome} ${reads[0]} ${reads[1]} > ${sample_id}/bwa/${sample_id}.sam
    """
}

process samtools_sort {
    tag "$sample_id"

    input:
    path("${sample_id}/bwa/${sample_id}.sam")
    path(genome)

    output:
    path("${sample_id}/bwa/${sample_id}.sorted.bam")

    script:
    """
    samtools view -bS ${sample_id}/bwa/${sample_id}.sam | samtools sort -o ${sample_id}/bwa/${sample_id}.sorted.bam 
    """
}

process gatk_varaint_calling {
    tag "$sample_id"

    input:
    path("${sample_id}/bwa/${sample_id}.sorted.bam")
    path(genome)

    output:
    path("${sample_id}/varaint.vcf")

    script:
    """
    gatk HaplotypeCaller -R ${genome} -I ${sample_id}/bwa/${sample_id}.sorted.bam -O ${sample_id}/varaints.vcf
    """
}

process vep_annotation {
    tag "$sample_id"

    input:
    path("${sample_id}/varaints.vcf")
    path(annotation)

    output:
    path("${sample_id}/annotated_varaints.vcf")

    script:
    """
    vep -i ${sample_id}/variants.vcf --gtf ${annotation} --cache --everthing --output_file ${sample_id}/annotated_varaints.vcf
    """
}

workflow {
    reads_pairs_ch
        .map { sample_id, reads -> tuple (sample_id, reads)}
        | fastqc
        | bwa_align
        | samtools_sort
        | gatk_varaint_calling
        | vep_annotation
}



