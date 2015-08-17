----------------------------------------------------------------------
> Multimodal registration for multi-spectral images                  
> Version 0.1                                                        
>                                                                    
> Author: Chen Yang (yangchen@picb.ac.cn)                            
> CAS-MPG Partner Institute for Computational Biology,               
> Shanghai Institutes for Biological Sciences,                       
> Chinese Academy of Sciences        
>                                
----------------------------------------------------------------------

# Multimodal registration for multi-spectral images

This is an example code for the algorithm described in

"Registration of Infrared Microscopic Images in Histologically Stained Tissue Sections 
using Restricted Mutual Information and Sparse Search"

## Usage
* function `imregistration` is the registration function for two pre-segmented index image 
* function `spstregistration` is a wrapper for registration between FTIR spectral image and H&E stained image 

* see `example` and `example_spst` for detailed usage
* see `reg_options` and `reg_defaults` for options and parameters of the registration pipeline
