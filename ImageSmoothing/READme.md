# Image Smoothing

This is a Matlab implementation that applies 3 image smoothing filters to an input image, i.e., Mean, Gaussian and Kuwahara filters. 
All 3 filters are implemented from scratch and called in a Matlab script. At the end of the script there is a verification
section where the already implemented in Matlab Mean and Gaussian filters are applied and their result is compared to the 
result of the filters that were made from scratch.

This implementation was developed and tested with Matlab 2015. The script uses as input an MRI image, that can be found [here](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging_of_the_brain#/media/File:MRI_Head_Brain_Normal.jpg).

## References
1. http://homepages.inf.ed.ac.uk/rbf/HIPR2/mean.htm
2. https://homepages.inf.ed.ac.uk/rbf/HIPR2/gsmooth.htm
3. https://en.wikipedia.org/wiki/Kuwahara_filter
