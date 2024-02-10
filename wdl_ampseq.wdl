version 1.0

workflow ampseq {
	input {	
		Boolean CONTAMINATION_DETECTION
		Boolean AMPLICON_ASSEMBLY

		#General commands
		String type_of_reads
		String path_to_fq 
		File path_to_flist
		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"

		#Commands for AmpSeq
		File pr1
		File pr2
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		File overlap_pr1
		File overlap_pr2
		File path_to_snv
		String no_ref = 'False'
		File reference
		String adjust_mode = "absolute"
		File reference2
		String strain = "3D7"
		String strain2 = "DD2"
		String polyN = "5"
		String min_reads = "0"
		String min_samples = "0"
		String max_snv_dist = "-1"
		String max_indel_dist = "-1"
		String include_failed = "False"
		String exclude_bimeras = "False"
		String amp_mask = "None"

		#Command for the decontamination pipeline
		Int minreads_threshold = 1000
		Float contamination_threshold = 0.5
		String verbose = "False"		
	}

	if (CONTAMINATION_DETECTION && !AMPLICON_ASSEMBLY) {
		call inline_barcodes_process {
			input: 	
				type_of_reads = type_of_reads,
				path_to_fq = path_to_fq,
				path_to_flist = path_to_flist,
				pattern_fw = pattern_fw,
				pattern_rv = pattern_rv,
				pr1 = pr1,
				pr2 = pr2,
				Class = Class,
				maxEE = maxEE,
				trimRight = trimRight,
				minLen = minLen,
				truncQ = truncQ,
				matchIDs = matchIDs,
				max_consist = max_consist,
				omegaA = omegaA,
				saveRdata = saveRdata,
				justConcatenate = justConcatenate,
				maxMismatch = maxMismatch,
				overlap_pr1 = overlap_pr1,
				overlap_pr2 = overlap_pr2,
				minreads_threshold = minreads_threshold,
				contamination_threshold = contamination_threshold,
				verbose = verbose
		}
	}

	if (AMPLICON_ASSEMBLY && !CONTAMINATION_DETECTION) {
		call ampseq_process {
			input:
				type_of_reads = type_of_reads,
				path_to_fq = path_to_fq,
				path_to_flist = path_to_flist,
				pattern_fw = pattern_fw,
				pattern_rv = pattern_rv,
				pr1 = pr1,
				pr2 = pr2,
				Class = Class,
				maxEE = maxEE,
				trimRight = trimRight,
				minLen = minLen,
				truncQ = truncQ,
				matchIDs = matchIDs,
				max_consist = max_consist,
				omegaA = omegaA,
				saveRdata = saveRdata,
				justConcatenate = justConcatenate,
				maxMismatch = maxMismatch,
				overlap_pr1 = overlap_pr1,
				overlap_pr2 = overlap_pr2,
				path_to_snv = path_to_snv,
				no_ref = no_ref,
				reference = reference,
				adjust_mode = adjust_mode,
				reference2 = reference2,
				strain = strain,
				strain2 = strain2,
				polyN = polyN,
				min_reads = min_reads,
				min_samples = min_samples,
				max_snv_dist = max_snv_dist,
				max_indel_dist = max_indel_dist,
				include_failed = include_failed,
				exclude_bimeras = exclude_bimeras,
				amp_mask = amp_mask
		}
	}

	if (AMPLICON_ASSEMBLY && CONTAMINATION_DETECTION) {
		call combined_process {
			input:
				type_of_reads = type_of_reads,
				path_to_fq = path_to_fq,
				path_to_flist = path_to_flist,
				pattern_fw = pattern_fw,
				pattern_rv = pattern_rv,
				pr1 = pr1,
				pr2 = pr2,
				Class = Class,
				maxEE = maxEE,
				trimRight = trimRight,
				minLen = minLen,
				truncQ = truncQ,
				matchIDs = matchIDs,
				max_consist = max_consist,
				omegaA = omegaA,
				saveRdata = saveRdata,
				justConcatenate = justConcatenate,
				maxMismatch = maxMismatch,
				overlap_pr1 = overlap_pr1,
				overlap_pr2 = overlap_pr2,
				path_to_snv = path_to_snv,
				no_ref = no_ref,
				reference = reference,
				adjust_mode = adjust_mode,
				reference2 = reference2,
				strain = strain,
				strain2 = strain2,
				polyN = polyN,
				min_reads = min_reads,
				min_samples = min_samples,
				max_snv_dist = max_snv_dist,
				max_indel_dist = max_indel_dist,
				include_failed = include_failed,
				exclude_bimeras = exclude_bimeras,
				amp_mask = amp_mask,
				minreads_threshold = minreads_threshold,
				contamination_threshold = contamination_threshold,
				verbose = verbose
		}
	}

#	output {
#		File? missing_files_decont_f = inline_barcodes_process.missing_files
#		File? missing_files_ampseq_f = ampseq_process.missing_files
#		File? ASVBimeras_f = ampseq_process.ASVBimeras
#		File? CIGARVariants_Bfilter_f = ampseq_process.CIGARVariants_Bfilter
#		File? ASV_to_CIGAR_f = ampseq_process.ASV_to_CIGAR
#		File? seqtab_f = ampseq_process.seqtab
#		File? ASVTable_f = ampseq_process.ASVTable
#		File? ASVSeqs_f = ampseq_process.ASVSeqs
#		File? rawfilelist_f = inline_barcodes_process.rawfilelist
#		File? merge_tar_f = inline_barcodes_process.merge_tar
#		File? dada2_ci_tar_f = inline_barcodes_process.dada2_ci_tar
#	}
}

task inline_barcodes_process {
	input {
		String type_of_reads
		String path_to_fq 
		File path_to_flist
		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"
		File pr1
		File pr2
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		File overlap_pr1
		File overlap_pr2
		Int minreads_threshold = 1000
		Float contamination_threshold = 0.5
		String verbose = "False"
	}

	Map[String, String] in_map = {
		"path_to_fq": "fq_dir",
		"path_to_flist": sub(path_to_flist, "gs://", "/cromwell_root/"),
		"pattern_fw": pattern_fw,
		"pattern_rv": pattern_rv,
		"pr1": sub(pr1, "gs://", "/cromwell_root/"),
		"pr2": sub(pr2, "gs://", "/cromwell_root/"),
		"Class": Class,
		"maxEE": maxEE,
		"trimRight": trimRight,
		"minLen": minLen,
		"truncQ": truncQ,
		"matchIDs": matchIDs,
		"max_consist": max_consist,
		"omegaA": omegaA,
		"saveRdata": saveRdata,
		"justConcatenate": justConcatenate,
		"maxMismatch": maxMismatch,
		"overlap_pr1" : sub(overlap_pr1, "gs://", "/cromwell_root/"),
		"overlap_pr2" : sub(overlap_pr2, "gs://", "/cromwell_root/"),
		"minreads_threshold": minreads_threshold,
		"contamination_threshold": contamination_threshold,
		"verbose": verbose
	}
	File config_json = write_json(in_map)
	command <<<
	set -euxo pipefail
	#set -x
	mkdir fq_dir

	gsutil ls ~{path_to_fq}
	gsutil -m cp -r ~{path_to_fq}* fq_dir/

	find . -type f
	python /Code/Amplicon_TerraPipeline.py --config ~{config_json} --~{type_of_reads} --terra --meta --repo --adaptor_removal --contamination
	find . -type f
	Rscript /render_report.R -d "/cromwell_root/Results/Merge/" -o "/cromwell_root/Report/" -p ~{path_to_flist} -m ~{minreads_threshold} -c ~{contamination_threshold} -mf "/cromwell_root/Results/missing_files.tsv"
	tar -csvf Report_Cards.tar.gz Report
	find . -type f
	>>>
	output {
		File? missing_files = "Results/missing_files.tsv" 
		File? decontamination_sample_cards = "Report_Cards.tar.gz"
		File? decontamination_report = "Results/ci_report_layouting.html"
	}
	runtime {
		cpu: 1
		memory: "15 GiB"
		disks: "local-disk 10 HDD"
		bootDiskSizeGb: 10
		preemptible: 3
		maxRetries: 1
		docker: 'jorgeamaya/mixed_reads_ampseq'
	}
}

task ampseq_process {
	input {
		String type_of_reads
		String path_to_fq 
		File path_to_flist
		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"
		File pr1
		File pr2
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		File overlap_pr1
		File overlap_pr2
		File path_to_snv
		String no_ref = 'False'
		File reference
		String adjust_mode = "absolute"
		File reference2
		String strain = "3D7"
		String strain2 = "DD2"
		String polyN = "5"
		String min_reads = "0"
		String min_samples = "0"
		String max_snv_dist = "-1"
		String max_indel_dist = "-1"
		String include_failed = "False"
		String exclude_bimeras = "False"
		String amp_mask = "None"
	}

	Map[String, String] in_map = {
		"path_to_fq": "fq_dir",
		"path_to_flist": sub(path_to_flist, "gs://", "/cromwell_root/"),
		"pattern_fw": pattern_fw,
		"pattern_rv": pattern_rv,
		"pr1": sub(pr1, "gs://", "/cromwell_root/"),
		"pr2": sub(pr2, "gs://", "/cromwell_root/"),
		"Class": Class,
		"maxEE": maxEE,
		"trimRight": trimRight,
		"minLen": minLen,
		"truncQ": truncQ,
		"matchIDs": matchIDs,
		"max_consist": max_consist,
		"omegaA": omegaA,
		"saveRdata": saveRdata,
		"justConcatenate": justConcatenate,
		"maxMismatch": maxMismatch,
		"overlap_pr1" : sub(overlap_pr1, "gs://", "/cromwell_root/"),
		"overlap_pr2" : sub(overlap_pr2, "gs://", "/cromwell_root/"),
		"path_to_snv": sub(path_to_snv, "gs://", "/cromwell_root/"),
		"no_ref": no_ref,
		"reference": sub(reference, "gs://", "/cromwell_root/"),
		"adjust_mode": adjust_mode,
		"reference2": sub(reference2, "gs://", "/cromwell_root/"),
		"strain": strain,
		"strain2": strain2,
		"polyN": polyN,
		"min_reads": min_reads,
		"min_samples": min_samples,
		"max_snv_dist": max_snv_dist,
		"max_indel_dist": max_indel_dist,
		"include_failed": include_failed,
		"exclude_bimeras": exclude_bimeras,
		"amp_mask": amp_mask
	}
	File config_json = write_json(in_map)

	command <<<
	set -euxo pipefail
	#set -x
	mkdir fq_dir

	gsutil ls ~{path_to_fq}
	gsutil -m cp -r ~{path_to_fq}* fq_dir/
	find . -type f
	python /Code/Amplicon_TerraPipeline.py --config ~{config_json} --~{type_of_reads} --terra --meta --adaptor_removal --primer_removal --dada2 --postproc_dada2 --asv_to_cigar
	find . -type f
	>>>
	output {
		File? ASVBimeras = "Results/ASVBimeras.txt"
		File? CIGARVariants_Bfilter = "Results/CIGARVariants_Bfilter.out.tsv"
		File? ASV_to_CIGAR = "Results/ASV_to_CIGAR/ASV_to_CIGAR.out.txt"
		File? seqtab = "Results/seqtab.tsv"
		File? ASVTable = "Results/PostProc_DADA2/ASVTable.txt"
		File? ASVSeqs = "Results/PostProc_DADA2/ASVSeqs.fasta"
		File? missing_files = "Results/missing_files.tsv"
	}
	runtime {
		cpu: 1
		memory: "15 GiB"
		disks: "local-disk 10 HDD"
		bootDiskSizeGb: 10
		preemptible: 3
		maxRetries: 1
		docker: 'jorgeamaya/mixed_reads_ampseq'
	}
}

task combined_process {
	input {
		String type_of_reads
		String path_to_fq 
		File path_to_flist
		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"
		File pr1
		File pr2
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		File overlap_pr1
		File overlap_pr2
		File path_to_snv
		String no_ref = 'False'
		File reference
		String adjust_mode = "absolute"
		File reference2
		String strain = "3D7"
		String strain2 = "DD2"
		String polyN = "5"
		String min_reads = "0"
		String min_samples = "0"
		String max_snv_dist = "-1"
		String max_indel_dist = "-1"
		String include_failed = "False"
		String exclude_bimeras = "False"
		String amp_mask = "None"
		Int minreads_threshold = 1000
		Float contamination_threshold = 0.5
		String verbose = "False"
	}

	Map[String, String] in_map = {
		"path_to_fq": "fq_dir",
		"path_to_flist": sub(path_to_flist, "gs://", "/cromwell_root/"),
		"pattern_fw": pattern_fw,
		"pattern_rv": pattern_rv,
		"pr1": sub(pr1, "gs://", "/cromwell_root/"),
		"pr2": sub(pr2, "gs://", "/cromwell_root/"),
		"Class": Class,
		"maxEE": maxEE,
		"trimRight": trimRight,
		"minLen": minLen,
		"truncQ": truncQ,
		"matchIDs": matchIDs,
		"max_consist": max_consist,
		"omegaA": omegaA,
		"saveRdata": saveRdata,
		"justConcatenate": justConcatenate,
		"maxMismatch": maxMismatch,
		"overlap_pr1" : sub(overlap_pr1, "gs://", "/cromwell_root/"),
		"overlap_pr2" : sub(overlap_pr2, "gs://", "/cromwell_root/"),
		"path_to_snv": sub(path_to_snv, "gs://", "/cromwell_root/"),
		"no_ref": no_ref,
		"reference": sub(reference, "gs://", "/cromwell_root/"),
		"adjust_mode": adjust_mode,
		"reference2": sub(reference2, "gs://", "/cromwell_root/"),
		"strain": strain,
		"strain2": strain2,
		"polyN": polyN,
		"min_reads": min_reads,
		"min_samples": min_samples,
		"max_snv_dist": max_snv_dist,
		"max_indel_dist": max_indel_dist,
		"include_failed": include_failed,
		"exclude_bimeras": exclude_bimeras,
		"amp_mask": amp_mask,
		"minreads_threshold": minreads_threshold,
		"contamination_threshold": contamination_threshold,
		"verbose": verbose
	}
	File config_json = write_json(in_map)
	command <<<
	set -euxo pipefail
	#set -x
	mkdir fq_dir

	gsutil ls ~{path_to_fq}
	gsutil -m cp -r ~{path_to_fq}* fq_dir/

	find . -type f	
	python /Code/Amplicon_TerraPipeline.py --config ~{config_json} --~{type_of_reads} --terra --meta --repo --adaptor_removal --contamination --primer_removal --dada2 --postproc_dada2 --asv_to_cigar
	find . -type f
	Rscript /render_report.R -d "/cromwell_root/Results/Merge/" -o "/cromwell_root/Report/" -p ~{path_to_flist} -m ~{minreads_threshold} -c ~{contamination_threshold} -mf "/cromwell_root/Results/missing_files.tsv"
	tar -csvf Report_Cards.tar.gz Report
	find . -type f	
	>>>
	output {
		File? ASVBimeras = "Results/ASVBimeras.txt"
		File? CIGARVariants_Bfilter = "Results/CIGARVariants_Bfilter.out.tsv"
		File? ASV_to_CIGAR = "Results/ASV_to_CIGAR/ASV_to_CIGAR.out.txt"
		File? seqtab = "Results/seqtab.tsv"
		File? ASVTable = "Results/PostProc_DADA2/ASVTable.txt"
		File? ASVSeqs = "Results/PostProc_DADA2/ASVSeqs.fasta"
		File? missing_files = "Results/missing_files.tsv"
		File? decontamination_sample_cards = "Report_Cards.tar.gz"
		File? decontamination_report = "Results/ci_report_layouting.html"
	}
	runtime {
		cpu: 1
		memory: "15 GiB"
		disks: "local-disk 10 HDD"
		bootDiskSizeGb: 10
		preemptible: 3
		maxRetries: 1
		docker: 'jorgeamaya/mixed_reads_ampseq'
	}
}
