# PCA on MRI images
This is an implementation of Principal Component Analysis (PCA) applied on a set of brain MRI images that depict the hippocampus of a brain. The goal is to extract the primary modes of variance of the shape distribution of the hippocampus, where each mode captures characteristics being learned. The method is inspired by [1]. The original MRI images can be downloaded for free from [2] and the preprocessed MRI images that contain the hippocampus segmentation can be requested as described in [3].

## Principal Components Analysis
PCA is a linear method for dimensionality reduction. The method is described in detail in [4], while the steps can be summed up as follows:
- Subtract the mean from the input data
- Calculate the covariance matrix
- Calculate the eigenvectors and eigenvalues of the covariance matrix
- Sort the eigenvalues in descending order in order to decide which and how many principal components to keep. The corresponding eigenvectors will form the feature vector
- Multiply the feature vector with the mean-adjusted input data to derive the output data

## Primary modes of variance
The method followed in this implementation is based on [1], where PCA is used to derive the mean shapes and primary modes of the corpus callosum and the vertebrae.

## Implementation
First, the MRI images are loaded into an input matrix using scripts that can be downloaded from [5].  Then, the input matrix is processed by calculating the signed distance map and transforming its shape from 3 dimensions to 2. Then, PCA is applied. To derive the primary modes of variance, equation 3 from [1] is used, where the square root of the eigenvalues is used in the place of α. Multiplying the eigenvectors with the square root of the eigenvalues produces the PCA factor loadings. The PCA factor loadings represent the amount of variance in each mode that can be explained by the principal component [6]. As shown in Fig. 3 in [1], the loadings are multiplied with [-2, 2] and step 0.2, and then added to the mean shape. Finally, the 4 primary modes are saved in .gif format.

## References
1.	M. E. Leventon, W. E. L. Grimson and O. Faugeras, "Statistical shape influence in geodesic active contours," Proceedings IEEE Conference on Computer Vision and Pattern Recognition. CVPR 2000 (Cat. No.PR00662), Hilton Head Island, SC, 2000, pp. 316-323 vol.1.
2.	http://www.oasis-brains.org/
3.	https://vcl.iti.gr/dataset/hippocampus-segmentation/
4.	http://www.cs.otago.ac.nz/cosc453/student_tutorials/principal_components.pdf
5.	https://github.com/fieldtrip/fileio/tree/master/private
6.	https://stats.idre.ucla.edu/spss/seminars/introduction-to-factor-analysis/a-practical-introduction-to-factor-analysis/
7.	Normative estimates of cross-sectional and longitudinal brain volume decline in aging and AD. Fotenos, AF, Snyder, AZ, Girton, LE, Morris, JC, and Buckner, RL, 2005. Neurology, 64: 1032-1039. doi: 10.1212/01.WNL.0000154530.72969.11
8.	A unified approach for morphometric and functional data analysis in young, old, and demented adults using automated atlas-based head size normalization: reliability and validation against manual measurement of total intracranial volume. Buckner, RL, Head, D, Parker, J, Fotenos, AF, Marcus, D, Morris, JC, Snyder, AZ, 2004. Neuroimage 23, 724-38. doi: 10.1016/j.neuroimage.2004.06.018
9.	Segmentation of brain MR images through a hidden Markov random field model and the expectation maximization algorithm. Zhang, Y, Brady, M, Smith, S, 2001. IEEE Trans. on Medical Imaging, 20(1):45-57. doi: 10.1109/42.906424 
10.	A prospective study of cognitive function and onset of dementia in cognitively healthy elders. Rubin, EH, Storandt, M, Miller, JP, Kinscherf, DA, Grant, EA, Morris, JC, Berg, L, 1998. Arch Neurol. 55, 395-401. PMID: 9520014 
11.	The Clinical Dementia Rating (CDR): current version and scoring rules. Morris, JC, 1993. Neurology 43, 2412b-2414b. PMID: 8232972 



