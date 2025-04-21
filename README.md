🧬 Variant Calling Pipeline with GATK & VEP Annotation
This Nextflow pipeline performs variant calling from paired-end FASTQ files, including quality control (FastQC), alignment (BWA), sorting (samtools), variant calling (GATK HaplotypeCaller), and annotation (VEP).

📁 Project Structure
project/
├── variant_pipeline.nf         # Main Nextflow pipeline
├── nextflow.config             # (Optional) Nextflow configuration file
├── Dockerfile                  # (Optional) Docker container with required tools
├── README.md                   # You're reading it!
├── RawData/                    # Input FASTQ files
│   ├── sample1_1.fq.gz
│   └── sample1_2.fq.gz
└── Ref/                        # Reference files
    ├── ref.fa                  # Reference genome
    └── ref.gtf                 # Annotation file


🚀 How to Run
1. Install Nextflow
curl -s https://get.nextflow.io | bash

2. Clone this repository
git clone https://github.com/yourusername/your-repo.git
cd your-repo

3. Prepare Inputs
Place paired FASTQ files in the RawData/ folder.

Name format should be: sampleID_1.fq.gz and sampleID_2.fq.gz

Put reference genome (ref.fa) and annotation file (ref.gtf) in the Ref/ folder.

4. Run the Pipeline
nextflow run GATK_variant.nf

5. Or run the pipeline with Docker:
nextflow run Strelka2_Somatic_varaint.nf -with-docker my-ngs-pipeline



📦 Pipeline Steps

Step	Tool	Output
1. Quality Check	FastQC	sampleID/fastqc
2. Alignment	BWA	sampleID/bwa/sampleID.sam
3. Sort & Convert	samtools	sampleID/bwa/sampleID.sorted.bam
4. Variant Call	GATK	sampleID/varaints.vcf
5. Annotation	Ensembl VEP	sampleID/annotated_varaints.vcf

🧪 Example Output
Each sample will have its results organized under its own folder, for example:

sample1/
├── fastqc/
├── bwa/
│   ├── sample1.sam
│   └── sample1.sorted.bam
├── varaints.vcf
└── annotated_varaints.vcf

❗ Known Issues
Make sure ref.fa is indexed if required by tools (e.g., samtools faidx, bwa index, gatk CreateSequenceDictionary)

Typo alert: check filenames like varaints.vcf (should be variants.vcf) in script output


⚙️ Configuration
If you want to change resource usage (e.g., memory, CPU, time limit), edit the nextflow.config file.







