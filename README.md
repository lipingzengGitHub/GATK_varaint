#Nextflow for GATK calling varaints from whole-exome sequencing (WES)
#Directory Structure Example

project/
│
├── WES_with_annotation.nf
├── data/
│   ├── sample_R1.fastq.gz
│   └── sample_R2.fastq.gz
├── ref.fa
├── targets.bed
├── vep_cache/   # This is where the VEP cache files will be stored
└── nextflow.config

#Explainations
Reference Genome: Make sure the reference genome (ref.fa) is indexed
fastqc: Performs quality control on the paired-end FASTQ files.

bwa_align: Aligns the reads to the reference genome using BWA.

samtools_sort: Sorts the resulting SAM file into a BAM file using Samtools.

gatk_variant_calling: Uses GATK to perform variant calling on the sorted BAM file. i.e. MarkDuplicates, HaplotypeCaller.

vep_annotation: Annotates the called variants using VEP (Variant Effect Predictor) based on the provided annotation GTF file.

#The params block specifies the file locations for the input data, the reference genome, the annotation, and the output directory.

#Run the pipeline with Nextflow
nextflow run WES_with_annotation.nf


#If want to build the Docker Image
#In the same directory with the Dockerfile, run the following command line
docker build -t nextflow-wes-pipeline .

#Run the Nextflow pipeline in Docker
docker run --rm -v /path/to/your/workdir:/data -w /data nextflow-wes-pipeline nextflow run WES_with_annotation.nf

#Explanation:

--rm: Removes the container once it’s stopped.

-v /path/to/your/workdir:/data: Mounts your local directory (where the WES_with_annotation.nf file and your data are located) to the /data directory inside the container.

-w /data: Sets the working directory to /data inside the container.



