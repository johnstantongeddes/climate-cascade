RAD-tag DNA library construction
================================

*Helms-Cahan lab protocol used to create 100bp RAD-tag library for Pogonomyrmex and Aphaenogaster*

*John Stanton-Geddes, 2013-09-26*

## Materials ##

DNA extraction and RNase A treatment

  1. DNeasy Blood & Tissue Kit (Qiagen).
  2. RNaseA (Qiagen). 
  3. Qubit® dsDNA HS Assay Kit (Invitrogen). 

Restriction endonuclease digestion

  1. Restriction enzyme (New England Biolabs): Bsaw1
  2. Clean, intact high-quality genomic DNA

P1 Adapter ligation

  1. New England Biolabs Buffer 2. 
  2. rATP (Promega):  100 mM.
  3. P1 Adapter:  100 nM. (96 top- and bottom-adaptors based on BsaW1 cutting site) 
  4. Concentrated T4 DNA Ligase (New England Biolabs):  2,000,000 U/ml.

Purification steps

  1. QIAquick or MinElute PCR Purification Kit (Qiagen).

DNA shearing

  1. Covaris ultrasonicator.

Size selection/agarose gel extraction

  1. Agarose (Sigma)
  2. 5X TBE:  0.45 M Tris-Borate, 0.01 M EDTA, pH 8.3.
  3. 6X Orange Loading Dye Solution (Fermentas).
  4. GeneRuler 100 bp DNA Ladder Plus (Fermentas).
  5. Razor blades.
  6. MinElute Gel Purification Kit (Qiagen).

Perform end repair

  1. Quick Blunting Kit (New England Biolabs).

3'-dA overhang addition­

  1. New England Biolabs Buffer 2. 
  2. dATP (Fermentas):  10 mM.
  3. Klenow Fragment (3´ to 5´ exo-, New England Biolabs):  5,000 U/ml.

P2 Adapter ligation

  1. New England Biolabs Buffer 2. 
  2. rATP:  100 mM.
  3. P2 Adapter:  10 μM. 
  4. Concentrated T4 DNA Ligase.

RAD tag Amplification/Enrichment

  1. Phusion High-Fidelity PCR Master Mix with HF Buffer (New England Biolabs).
  2. Modified Solexa Amplification primer mix (2006 Illumina, Inc., all rights reserved):  10 μM. 
    - P1-forward primer:  5´- AATGATACGGCGACCACCG*A -3´
	- P2-reverse primer:  5´- CAAGCAGAAGACGGCATACG*A -3´	 

\newpage

## Methods ##

**Preparation**

1) Prepare P1 (with barcode) and P2 adapters:
For each single stranded oligonucleotide, prepare 100 uM stock in 1x Elution Buffer (10nM Tris-Cl, PH8.5). Combine complementary adapter oligos at 10 μM in 1X AB (10X AB:  500 mM NaCl, 100 mM Tris-Cl, pH 7.5-8.0). Place in beaker of water just off the boil, cool slowly to room temperature to anneal. Dilute to desired concentration in 1X AB.
2) Quantify DNA samples with Qubit® dsDNA HS Assay Kit (follow the protocol of the kit).

**Restriction endonuclease digestion**

3) In each PCR tube (using 96 well PCR plates) combine:       
5.0 μl  10X New England Biolabs Buffer 4,  0.5 ul BSA (100x),  1.0 μl BsaW1,  DNA (~500 ng) and  H2O to 50.0 μl.
Incubate at 60°C for 6 hours (or longer) and inactivate at 80°C for 20 min (in PCR machine),  then allow the reactions to cool slowly to room temperature.

**P1 Adapter ligation**

4) To each inactivated digest (50 ul), add:  
1.0 μl 10X New England Biolabs Buffer 2, 1.8-2 μl Barcoded P1 Adapter (100 nM), 1.0 μl rATP (100 mM), 0.5 μl T4 DNA Ligase (2,000,000 U/ml), and H2O to 60.0 μl total volume. 
 (Note: This is the amount optimized for Pogonomyrmex ants.  It is critical to optimize the amount of P1 adapter added when a given restriction enzyme is used for the first time in an organism. Be sure to add P1 adapters to the reaction before the Ligase to avoid re-ligation of the genomic DNA.)
5) Incubate reaction at 16°C overnight using PCR machine (or following the original protocol to incubate at room temperature for 30 min).
6) Heat-inactivate T4 DNA Ligase for 20 min at 65° C. Allow reaction to cool slowly to ambient temperature (30 min).

**Sample multiplexing**

7) Take approximately equal amount of the barcoded DNA samples, combine them in a 1.5 ml centrifuge tube (to pool 48 individually barcoded DNA samples, I took 10 ul from each sample), freeze the rest at -20° C.  

**DNA shearing**

8) Take 55 μl aliquot from the multiplexed sample (containing 48 individually barcoded DNAs), and transfer into a glass microtube (4 tubes in total for each multiplexed DNA sample).  Shear DNA aliquots in Covaris for 45 seconds (density cycle: 10%, intensity: 5, cycles: 200). 
9) Combine the sheared DNA.  Clean up the sample using MinElute PCR Purification Kit following manufacturer’s instructions. Elute in 20 μl EB.

**Size selection/agarose gel extraction**

10) Run the entire sheared sample in 1X Orange Loading Dye on a 1.25% low melting agarose gel for 45 min at 100 V, next to 1.0 μl 100 bp DNA Ladder for size reference.
11) Use a fresh razor blade to cut a slice of the gel spanning 300-800 bp. Be careful to exclude any free P1 adapters and P1 dimers running at ~130 bp and below. 
12) Extract DNA using MinElute Gel Purification Kit following manufacturer’s instructions with the following modification: melt agarose gel slices in the supplied buffer at room temperature with agitation. Elute in 20 μl EB into 1.5 ml centrifuge tube.

**Perform end repair**

13) To the eluate from the previous step, add: 2.5 μl 10X Blunting Buffer,  2.5 μl dNTP mix (1mM),  1.0 μl Blunt Enzyme Mix. Incubate at room temperature for 30 min. 
14) Purify with QIAquick PCR Purification Kit. Elute in 43 μl EB into centrifuge tube .
15) 3'-dA overhang addition
16)  To the eluate from the previous step, add: 5.0 μl 10X New England Biolabs Buffer 2,  1.0 μl dATP (10mM), 3.0 μl Klenow (exo-). Incubate at 37º C for 30 min. Allow reaction to cool slowly to ambient temperature (15 min). 
17)  Purify with QIAquick PCR Purification Kit. Elute in 45 μl EB into centrifuge tube.

**P2 Adapter ligation**

18)  To the eluate from previous step, add:  5.0 μl 10X New England Biolabs Buffer 2,  1.0 μl P2 Adapter (10 μM), 0.5 μl rATP (100 mM), 0.5 μl concentrated T4 DNA Ligase. ) Incubate reaction at 16°C overnight using PCR machine (or following the original protocol to incubate at room temperature for 30 min).
19)  Purify with QIAquick PCR Purification Kit. Elute in 50 μl EB.
20)   Nanadrop the purified DNA.

**RAD tag Amplification/Enrichment**

21)  Perform a test amplification to determine library quality. 
 - In thin-walled PCR tube, combine: 12.5 μl Phusion High-Fidelity Master Mix, 0.5 μl forward RAD primer (10 μM), 0.5 μl reverse RAD primer (10 μM), 1.0 μl (or more, depend on the DNA concentration) RAD library template (eluate from last step), add H2O to a final volume of 25 ul. 
 - Perform 18 cycles of amplification in thermal cycler:  30 sec 98° C, 18X [10 sec 98° C, 30 sec 65° C, 30 sec 72° C], 5 min 72° C, hold 4° C. Take 5 ul reaction out after 12 and 15 cycles.  Run 5.0 μl of the PCR product of different (12, 15 and 18) cycles, as well as  1.0 μl 100 bp DNA Ladder, in 1X Orange Loading Dye on1.0% agarose gel. 
  - Compare the brightness of the PCR products resulted from different cycles (Template should be dim, yet visible on the gel; PCR products should be much brighter . It is recommended to use 16 or fewer cycles to avoid skewing the representation of the library (If amplification looks poor, use more library template in a second test PCR reaction).
22) Perform larger volume amplifications (100-150 μl in total) using the optimum PCR cycles  and amount of DNA template. 
23) Purify large volume reaction (75 ul x2) with a MinElute PCR purification kit. Elute in 25 μl EB. 
24) Gel purification / 2nd round of size selection:   
 - Load entire sample in 1X Orange Loading Dye on a 1.25% agarose gel (low melting point) and run for 45 min at 100 V, next to 1.0 μl 100 bp DNA Ladder. 
 - Use a fresh razor blade to cut a slice of the gel spanning 300-800 bp. 
 - Extract DNA using MinElute Gel Purification Kit following manufacturer’s instructions. 
 - Melt agarose gel slices in the supplied buffer at room temperature. 
 - Elute in 20 μl EB. 

**Quantify the amplified RAD library**

Qubit, (optional: bioanalyzer,)  qPCR.

**Sequencing**

Send off for sequencing Illumina single-end 100bp.
