AMGP-26-510  
Response to Reviewers

Reviewer 1

(unnumbered) The statistical analysis is too telegraphic.

***Response.***  

* Acknowledge insufficient detail; expand Statistical Analysis to explain each method’s purpose, calculation, and interpretation.  
* Clarify the analysis structure: 46 participants, 7 assessors, 21 possible assessor pairs per participant; 966 possible comparisons reduced to 954 by 2 missing assessor ratings.  
* Distinguish quadratic-weighted κ for severity from κ for binary delirium presence; define percent agreement (severity scores within 2 points) and mean absolute score difference.  
* Explain sampling-weight construction, the target population, balancing variables (site and gold-standard delirium severity), and which analyses used those weights.  
* Describe initial and post-consensus analyses and dementia-stratified analyses; distinguish descriptive comparisons from formal tests of differences.  
* Specify confidence-interval methods and how dependence among comparisons involving the same participants and assessors was handled.  
* Explain the Bland–Altman analysis and limit its interpretation to the quantity actually analyzed.

1\. There are a variety of kappa statistics. Since you are using multiple raters on multiple people, you should use Fleiss's kappa. Please be explicit. You may also want to specify which R package you used (e.g., irrCAC). You could have used Kendall's W, which is made for ordinal data, or used an intraclass correlation.

***Response.***  

* Agree with the reviewer’s request to specify the κ statistic and use a method that accommodates multiple raters.  
* Replace the pooled pairwise Cohen’s κ analyses with Conger’s generalized κ, appropriate for the same 7 assessors rating multiple participants.  
* Use quadratic-weighted Conger’s κ for ordinal delirium severity ratings and unweighted Conger’s κ for binary delirium presence.  
* Recalculate initial, post-consensus, and dementia-stratified estimates and 95% confidence intervals; update the Methods, Results, tables, and figures accordingly.  
* Specify irrCAC::conger.kappa.raw, package version, category weights, missing-rating handling, and treatment of participant sampling weights.  
* Explain the choice of Conger’s κ as a measure of agreement on assigned ratings; acknowledge Kendall’s W and ICC as alternatives addressing related aspects of reliability.

2\. This is an odd statement: "We examined both Pearson correlation coefficients and weighted kappa coefficients (with quadratic weights) to summarize the agreement among pairs and confirmed that both approaches yielded identical results. We report these statistics as weighted kappa coefficients." First, Pearson's correlation coefficient is a measure of (linear) association, not a measure of agreement. So, in general, it does not provide identical results. Secondly, with multiple (k \= 7\) raters, there would be 21 correlations.  
The next sentence says "We report these statistics as weighted kappa coefficients." Please do not present Pearson's r-values as kappa.

***Response.***  

* We will replace the pooled pairwise analyses with Conger’s generalized κ, using quadratic weights for delirium severity and unweighted κ for delirium presence. This approach accommodates the 7 assessors within a single multiple-rater agreement analysis.  
* We will remove Pearson correlations from the reported analyses and revise the Methods and corresponding results to identify the estimator, implementation, and confidence-interval method explicitly.

3\. Why would you split your sample: "To address whether reliability differed by the presence of dementia, we repeated weighted κ and percent agreement analyses stratified by dementia status (present vs. absent, per gold-standard adjudication).?" Ideally, kappa would be undefined if all raters agreed. If you are using the scaled score, then artificially restricting the range seems odd.

***Response.***  

* Dementia-stratified analyses were intended to examine agreement in a clinically relevant subgroup: delirium severity assessment may be more difficult when chronic cognitive impairment is present.  
* Stratification was based on independently adjudicated dementia status. The full 0–10 delirium severity scale remained available in each subgroup; no severity categories were excluded or truncated.  
* We agree that stratification reduces sample size and may produce different severity distributions. Because κ depends on those distributions, differences between subgroup coefficients cannot by themselves establish differences in assessor performance.  
* We will retain the overall Conger’s generalized κ analysis as primary and describe dementia-stratified estimates as exploratory, accompanied by subgroup sample sizes, confidence intervals, and descriptive agreement measures.  
* The reported 100% agreement refers to paired severity scores within 2 points, rather than identical scores. κ becomes undefined when expected agreement equals 1, as when every assessor assigns every participant the same category; perfect agreement across participants occupying multiple categories can yield κ \= 1\.  
* We will revise the Methods and Results to clarify these distinctions and avoid interpreting similar subgroup estimates as evidence that reliability is equivalent.

4\. The tables and figures show Rater A and Rater B. You had seven raters, not two. That will be confusing to readers.

***Response.***  Blah

* We agree that “Rater A” and “Rater B” were insufficiently explained. These labels denote the first and second assessor within each paired comparison, with all 21 unique pairs among the 7 assessors pooled for descriptive presentation.  
* We will retain these displays because they show the distribution and magnitude of rating discrepancies. We will revise titles, axis labels, and legends to identify them explicitly as pooled assessor-pair comparisons.  
* Legends will explain that the displays include 954 comparisons from 46 participants and that each participant contributes multiple comparisons; “A” and “B” do not identify 2 particular assessors.  
* We will distinguish these descriptive displays from the revised reliability analysis, which will use Conger’s generalized κ to summarize agreement among all 7 assessors.

Reviewer 2

Overall comments. Thank you for the opportunity to review this report that describes the inter-rater reliability of delirium severity ratings across 7 independent reviewers who, I gather, were also among the clinical assessors in the BASIL II study. The authors selected a 46-case subsample from the BASIL II study for this analysis and demonstrate that independent reviewers had a high degree of agreement in delirium severity ratings before discussion and even higher after consensus discussions.

My comments below engage mostly with the nature of this analysis given—at least on my read and in my experience—its relative novelty in the delirium field. This approach to inter-rater reliability exists on a different level than usual. That is, this is not a traditional inter-rater reliability study where multiple clinical assessors evaluate the same patient simultaneously and then compare scores afterward. Rather, this appears to be a study where rigorous, detailed delirium evaluations were already conducted by a “clinical assessor” as part of the primary study (BASIL II) and then these study evaluation—one assessment per subject—were reviewed/adjudicated/scored by independent reviewers to assign/determine delirium severity. This, however, was not clear in the abstract or methods. It wasn’t entirely clear to me until I saw the very last supplemental Figure, which shows that the “clinical assessors” were not doing the clinical assessments here; rather, they were only reviewing packets of clinical information. Hence, their description as “clinical” (they’re not doing anything clinical in this sub-study, though they sound to be clinical assessors \*in the BASIL II study\*) and “assessors” (they’re not directly  
assessing the patient but rather reviewing available clinical assessments \*in this sub-study\*) is misleading. It seems that they would be better called something like “independent reviewers.”

***Response.***  

* We agree that the Abstract and Methods did not adequately distinguish the original patient assessments from the packet-review procedure used in this reliability substudy.  
* The 7 reviewers independently rated delirium severity using identical standardized packets containing previously collected clinical information. They did not conduct separate bedside assessments for this substudy.  
* We will use “independent reviewers” when describing their role in the reliability substudy and clarify their clinical assessor roles in the parent BASIL II study.  
* We will revise the Abstract, Methods, and figure legends to describe the sequence explicitly: collection of patient assessment information, preparation of standardized packets, independent severity ratings, and discussion of cases meeting the prespecified criteria for consensus review.  
* We will clarify that the initial analysis estimates agreement in interpreting shared clinical information. It does not capture variability arising when different assessors independently interview, examine, or collect information from the same patient.  
* We will distinguish initial independent ratings from ratings following consensus discussion and revise the interpretation and limitations to reflect the scope of this design.

I’m also struggling with the conclusions in the abstract, which I have pasted here with bracketed commentary included: “Trained clinical assessors \[read, “independent reviewers with a clinical background and who happened to be among the clinical assessors in BASIL II”\] demonstrated high inter-rater reliability in delirium severity ratings \[as below, the scale they’re rating is not reported\] across a reliability sample that included patients with dementia \[undefined: this value could range from 1 to 45\] and a wide range of delirium severity \[as with the preceding comment re dementia, a range does not imply distribution\]. These findings support feasibility \[this is not reported as a feasibility study\] of structured clinical assessment \[are we talking about the structured nature of the clinical assessments in the BASIL II study or the independent review process?\] approaches for generating reproducible delirium severity measurements in multisite research studies \[which presumes the fidelity of the original clinical assessments being reviewed, so I’m not sure how this report answers the question of reliability across sites; it rather assumes it\].”

***Response.***  Blah

* We agree that the Abstract conclusion extended beyond what this substudy evaluated. We will narrow the conclusion to agreement among independent reviewers assigning delirium severity scores from identical standardized clinical information packets.  
* We will identify the 0–10 severity scale and report the dementia composition explicitly: 27 of 46 participants (59%).  
* We will replace “a wide range of delirium severity” with a description of the observed score distribution in the Abstract Results; the observed range alone does not establish representation across severity levels.  
* We will remove the feasibility claim because feasibility was not an evaluated outcome.  
* We will distinguish the standardized packet-review procedure from the original clinical assessments and remove the implication that this substudy established reliability of bedside assessment or data collection across sites.  
* Revised conclusion: “Independent reviewers demonstrated high agreement when assigning delirium severity scores from standardized clinical information packets. These findings support the reproducibility of severity ratings based on shared information under the study’s review procedures.”

In addition to these higher-level considerations, I would ask the authors to consider the following specific comments:

1\) Specifically, regarding the last parenthetical point above, the authors should highlight that this analysis presumes the reliability and fidelity of the original clinical research assessments. Not that I’m challenging the assessments in BASIL II—far from it. I'm glad to grant that they are, in fact, rigorous. However, this is an assumption that should be made explicit because replicating findings from this analysis/sub-study will have to consider the rigor of both the primary clinical assessments \*and\* the rigor of this second-order adjudication as currently being presented.

***Response.***  Blah

* We agree that reproducibility depends on both the quality of the original clinical assessments and the procedures used to review that information.  
* We will state explicitly that this substudy evaluated agreement conditional on the clinical information provided. Because reviewers received identical packets, errors or omissions shared across packets could coexist with high reviewer agreement.  
* We will clarify that the analysis did not independently evaluate the reliability or fidelity of the original patient assessments.  
* We will expand the Methods to distinguish procedures for collecting and preparing clinical information from procedures for training reviewers, assigning severity ratings, and resolving disagreement.  
* We will add this dependency to the Discussion: replication requires comparable rigor in both the original assessments and the subsequent packet-review process; high agreement among reviewers alone does not establish the accuracy of the resulting ratings.

2\) As the authors acknowledge, delirium severity remains an unsettled topic in the field. I wanted to compare the authors’ current approach to previous approaches, but I could not find the scale the independent reviewers were being asked to score. Could you please include this in the report as a supplement or include a reference to an online version of the scale? It’s not clear to me how delirium severity is being anchored or operationalized.

***Response.***  **TAMARA** DESCRIBE RATINGS

3\) Delirium severity scales like the CAM-S (which was completed in the BASIL II and, moreover, was available to the reviewers) have been previously validated; however, the authors do not present validation data on this current measure of “delirium severity.” I initially thought that it may be the DEL-S or DEL-S-AD, but those are clinical assessments, not reviewer adjudication as being done here. Nor do the authors cite work on the DEL-S, so this appears to be different. Could the authors provide a rationale for why this new model of delirium severity, which uses as part of its available data the CAM-S, is needed or the gap(s) this is attempting to fill?

***Response.***  **TAMARA** DESCRIBE RATINGS

4\) How do these derived delirium severity measures compare to the CAM-S values that were available for review by these independent reviewers? It seems that as a reviewer I would likely end up putting a lot of stock in the CAM-S results if I were asked to rate delirium severity.

***Response.***  **TAMARA** DESCRIBE RATINGS; DO WE WANT TO ADD CORRELATION WITH CAM-S TO THIS MANUSCRIPT? OR IS THIS DESCRIPTIVE INFORMATION

5\) When the authors describe a “gold standard” approach to delirium adjudication, I recognize that they are also citing a paper with “gold standard” in the title, but—in view of the broad range of perspectives in the field—I think the more honest description would simply be “reference standard.”

***Response.  TAMARA***

* We agree and will replace “gold standard” with “reference standard” throughout the manuscript and supplemental materials.  
* We will describe the expert panel adjudication as the study’s reference standard, without implying an error-free determination of delirium or its severity.  
* The published title of the cited article will remain unchanged in the reference list.

Reviewer 3

This paper examines the question of interrater reliability for delirium severity across multiple sites.

Strengths: This paper utilizes data from a larger clinical study BASIL II, and leverages three geographically distinct sites. It uses a consensus process and a wide range of well-established scales. The methodology section is detailed and well-described.

Potential Areas for Improvement: The paper would benefit from additional details. For example, in the 46 subset selection, it is not clear what the severity of dementia is. It would be helpful for the reader to know whether these findings are applicable to those patients with a CDR 3.0 or only those with mild dementia. Characterization of pre-hsopital behavioral disturbances in those individuals with dementia would also be important to describe. Knowing whether the same rates of interreliability estimates apply to these more complex cases would be helpful. There is also concern about the selection of the clinical assessors in the consensus process. For example, the training between a neuropsychologist and a mental health counselor and a project manager are quite different. Finally, while the 46 cases were selected based on their methodological criteria for statistical calculation, it would be important to consider the additional selection of cases which may benefit from a rigorous conduct of a delirium severity rating, e.g., a case in which it may not be clear whether behavioral disturbances are due to dementia vs delirium.

***Response.***  Blah

Overall, this paper has modest impact for the field of delirium and dementia.

***Response.**  So you’re saying, this is an impactful paper?*

Reviewer 4

1\. Determination of delirium status4  
How was the presence or absence of delirium determined by the clinical assessors? Was it  
based on the CAM algorithm, the FAM-CAM, or another instrument? If multiple  
instruments were used, please clarify how the information from these instruments was  
integrated to arrive at a final determination.

2\. Discordance in delirium diagnoses  
Table 1 reports that, among cases in which at least one clinical assessor identified  
delirium, approximately 29% of delirium-positive cases were non-concordant before  
consensus (\[61 \+ 45\] / \[260 \+ 45 \+ 61\]). Following consensus discussions, this proportion  
decreased to approximately 24% (\[52 \+ 37\] / \[283 \+ 52 \+ 37\]).  
Does this level of disagreement (24% to 29%) among delirium-positive cases raise  
concern regarding diagnostic reliability? The manuscript also references an expert gold-  
standard diagnosis. If a separate adjudication process was used to establish the diagnosis,  
this should be explained more clearly in the Methods section and reported in the Results.  
If such a reference standard was available, it would also be valuable to report the  
sensitivity and specificity of the clinical assessors’ diagnoses.

3\. Relationship between delirium diagnosis and severity ratings  
How did the clinical assessors’ ratings of delirium presence or absence relate to their  
ratings of delirium severity? Given that disagreement existed in roughly one-quarter to  
one-third of delirium-positive cases, did this affect the severity ratings?  
It would be especially helpful to provide a more detailed description of how assessors  
assigned ratings on the 0-10 severity scale. What instruments or criteria were used to  
anchor these ratings? How were assessors trained to synthesize the various sources of  
information provided to them when determining severity?

4\. Consensus process  
Additional detail regarding the consensus process would be helpful. The manuscript  
refers to a “modified Delphi method,” but further explanation is needed. My  
understanding is that Delphi methods are generally used to obtain reliable consensus from  
a panel of experts through a structured series of iterative questionnaires. In contrast, the  
assessors in this study would not necessarily be considered experts, and the ratings appear  
to be based on clinical data collected according to a defined protocol rather than opinion-  
based judgments. Please clarify how the modified Delphi approach was operationalized  
in this context and why this terminology was chosen.

5\. Clarification of assessment instruments  
The description of the instruments used in the standardized summaries requires  
clarification. The Delirium Rating Scale-Revised-98 (DRS-R-98) is referenced on page 7  
of the manuscript; however, this instrument is not listed in the supplemental materials.  
Instead, the DSRS (Dementia Severity Rating Scale) is referenced.  
Please clarify which instrument was used. If the DRS-R-98 was included, it would be  
very informative to report the interrater reliability of the DRS-R-98 severity scores and  
compare these findings with the CAM-S severity ratings.

6\. Discussion and citation accuracy  
The statement on page 11 that:  
“The BASIL II study is one of few studies to detail the expert panel adjudication  
process.”  
cites Reference 23:  
Oh ES, Rosenberg PB, Wang NY , Sieber FE, Neufeld KJ. Delirium detection  
methodologies: implications for outcome measurement in clinical trials in postoperative  
delirium. Int J Geriatr Psychiatry. 2022;37(3). doi:10.1002/gps.5695.  
This publication does not describe the BASIL II study. Rather, it reports methods from  
the STRIDE study (PI: Sieber) and examines the adjudication process for delirium and  
dementia diagnoses within that study. Please revise this section accordingly and/or cite a  
more appropriate reference.  
