#' Find Python versions, Conda, & Virtual Environments
#'
#' This function lists available python versions, conda
#' environments, and virtual environments. One may show
#' all three or just one.
#' @param python If TRUE will list available python versions.
#' Default: TRUE
#' @param conda If TRUE will list available conda environments.
#' Default: TRUE
#' @param virtualenv If TRUE will list available virtual environments.
#' Default: TRUE
#' @return None
#' @export
#' @examples 
#' \dontrun{
#' find_python()
#' }
#' @import reticulate

find_python <- function(python=TRUE, conda=TRUE, virtualenv=TRUE){
  f_py <- py_discover_config()
  condalist <- conda_list()
  virtlist <- virtualenv_list()
  if(python == TRUE & conda == TRUE & virtualenv == TRUE){
    message("Default Python:\n", f_py$python, "\n\n",
        "Python versions found:\n", f_py$python_versions, "\n\n",
        "List of condaenvironments:\n",
        paste0(condalist$name, ": ", condalist$python, ","),
        "\n\n",
        "List of virtualenvs:\n", virtlist)
  } else if(python == TRUE & conda == FALSE & virtualenv == FALSE){
    message("Default Python:\n", f_py$python, "\n\n",
        "Python versions found:\n", f_py$python_versions, "\n\n")
  } else if(python == FALSE & conda == TRUE & virtualenv == FALSE){
    message("List of condaenvironments:\n", 
        paste0(condalist$name, ": ", condalist$python, ","))
  } else if(python == FALSE & conda == FALSE & virtualenv == TRUE){
    message("List of virtualenvs:\n", virtlist)
  } else {
    message("Please set python, virtualevl, and/or conda to TRUE")
  }
}


#' Make a new conda environment
#' 
#' This function creates a new conda environment and initializes
#' the new conda environment.
#' In doing so, this function sets your python version 
#' and one may specify a specific python version. This is useful
#' if you have multiple versions of python installed.
#' When making a new conda environment, if the python version isn't set, then
#' your default one will be used.
#' @param condaenv Specify conda environment name
#' @param version Set path to specific version of python.
#' @param verbose TRUE or FALSE. When TRUE, shows python and conda configuration.
#' Default: TRUE
#' @export
#' @return None
#' @examples 
#' \dontrun{
#' create_conda_env( 
#'     condaenv = "r-reticulate",
#'     version = "~/anaconda3/bin/python",
#'     verbose = TRUE)
#' }
#' @import reticulate

create_conda_env <- function(condaenv, version=NULL, verbose = TRUE){
  # check if conda environment exists, if not make it
  condalist <- conda_list()
  if(!(condaenv %in% condalist$name)){
    message("\n Your specified conda environment, ", condaenv, 
        " was not found.\n Making new conda environment. \n")
    if(!is.null(version)){
      # set python version
      use_python(version, required = TRUE)
    } else {
      f_py <- py_discover_config()
      message("No python version set. Default python is:\n", f_py$python, "\n")
    }
    # create conda env
    conda_create(condaenv, packages = "python", conda = "auto")
    message('\n Setting condaenvironment \n')
    # set conda environment
    use_condaenv(condaenv = condaenv, required = TRUE)
    if(verbose == TRUE){
      message("\n Python/conda environment created: \n", condaenv, "\n")
      print(conda_list())
      return(py_config())
    }
  } else {
    message('\n Your specifed Conda Environment already exists \n')
    message('\n Set your conda env with: set_python_conda \n')
  }
}


#' Set Python Conda environment
#'
#' This function sets your conda environment.
#' Run this command before PreprocessMatrix. Install python dependencies in the
#' same conda environment that you set here.
#' To make a new conda environment use the create_conda_env function.
#' @param condaenv Specify conda environment name
#' @param verbose TRUE or FALSE. When TRUE, shows python and conda configuration.
#' Default: TRUE
#' @export
#' @return None
#' @examples 
#' \dontrun{
#' set_python_conda(
#'     condaenv = "r-reticulate", 
#'     verbose = TRUE)
#' }
#' @import reticulate

set_python_conda <- function(condaenv, verbose = TRUE){
  # check if conda environment exists, if not make it
  condalist <- conda_list()
  if(!(condaenv %in% condalist$name)){
    message("\n Your specified conda environment, ", condaenv, 
        " was not found.\n Make a new env with create_conda_env. \n")
  } else {
    message('\n Setting condaenvironment \n')
    # set conda environment
    use_condaenv(condaenv = condaenv, required = TRUE)
    # if verbose
    if(verbose == TRUE){
      message("\n Python/conda environment in use: \n")
      return(py_config())
    }
  }
}


#' Make a new virtual environment
#'
#' This function creates a new virtual environment and initializes
#' the new virtual environment.
#' In doing so, this function sets your python version 
#' and one may specify a specific python version. This is useful
#' if you have multiple versions of python installed.
#' When making a new virtual environment, if the python version isn't set, then
#' your default one will be used.
#' @param virtualenv Specify conda environment name
#' @param version Set path to specific version of python.
#' @param verbose TRUE or FALSE. When TRUE, shows python and conda configuration.
#' Default: TRUE
#' @export
#' @return None
#' @examples 
#' \dontrun{
#' create_virtual_env(version = "/usr/bin/python3", 
#'     virtualenv = "r-reticulate", 
#'     verbose = TRUE)
#' }
#' @import reticulate

create_virtual_env <- function(virtualenv, version=NULL, verbose = TRUE){
  # check if virtual environment exists, if not make it
  virtlist <- virtualenv_list()
  if(!(virtualenv %in% virtlist)){
    message("\n Your specified virtual environment, ", virtualenv, 
        " was not found.\n Making new virtual environment. \n")
    if(!is.null(version)){
      # set python version
      use_python(version, required = TRUE)
    } else {
      f_py <- py_discover_config()
      message("No python version set. Default python is:\n", f_py$python, "\n")
    }
    # create virtual env
    virtualenv_create(envname = virtualenv)
    message('\n Setting virtual environment \n')
    # set virtual environment
    use_virtualenv(virtualenv = virtualenv, required = TRUE)
    if(verbose == TRUE){
      message("\n Python/virtual environment in use: \n")
      return(py_config())
    }
  } else {
    message('\n Your specifed Virtual Environment already exists \n')
    message('\n Set your virtual env with: set_python_virtual \n')
  }
}

#' Set your Python Virtual environment
#'
#' This function sets your virtual environment.
#' Run this command before PreprocessMatrix. Install python dependencies in the
#' same virtual environment that you set here.
#' To make a new virtual environment use the create_virtual_env function.
#' @param virtualenv Specify virtual environment name
#' @param verbose TRUE or FALSE. When TRUE, shows python and virtual environment configuration.
#' Default: TRUE
#' @export
#' @return None
#' @examples 
#' \dontrun{
#' set_python_virtual(
#'     virtualenv = "r-reticulate", 
#'     verbose = TRUE)
#' }
#' @import reticulate

set_python_virtual <- function(virtualenv, verbose = TRUE){
  # check if virtual environment exists, if not make it
  virtlist <- virtualenv_list()
  if(!(virtualenv %in% virtlist)){
    message("\n Your specified virtual environment, ", virtualenv, 
        " was not found.\n Make a new env with create_virtual_env. \n")
  } else {
    message('\n Setting virtual environment \n')
    # set virtual environment
    use_virtualenv(virtualenv = virtualenv, required = TRUE)
    # if verbose
    if(verbose == TRUE){
      message("\n Python/virtual environment in use: \n")
      return(py_config())
    }
  }
}



#' Install Python Dependencies
#'
#' This function installs needed python libraries into the specified conda
#' environment OR virtual environment. Should be the same as the one 
#' specified in set_python.
#' Required python libraries: matplotlib, numpy, pandas, pathos,
#' scipy and sympy
#' On CentOS 7 pandas & scipy may need to be installed with pip install 
#' from the command line. Will get the error: /lib/libstdc++.so.6: version
#' `CXXABI_1.3.9' not found
#' See vignette for more information.
#' @param condaenv Name of conda environment to install python libraries to.
#' Default: NULL
#' @param virtualenv Name of virtual environment to install python libraries to.
#' Default: NULL
#' @export
#' @return None
#' @examples 
#' \dontrun{
#' # Cond env
#' py_depend(condaenv = "r-reticulate", 
#'     virtualenv = NULL)
#' # virtualenv:
#' py_depend(virtualenv = "r-reticulate", 
#'     condaenv = NULL)
#' }
#' @import reticulate

py_depend <- function(condaenv=NULL, virtualenv=NULL){
  # symengine not installing on windows, will add later
  # issues with pandas & scipy on CentOS7
  required_py <- c("matplotlib", "numpy", "pandas", "pathos", "scipy", "sympy")
  if(!is.null(condaenv)){
    conda_install(envname = condaenv, packages = required_py, pip = FALSE)
  } else if(!is.null(virtualenv)){
    virtualenv_install(envname = virtualenv, 
                       packages = required_py, ignore_installed = TRUE)
  } else {
    # add spedify conda or virt
  }
  
}


#' Convert data to R format if saved to disk
#'
#' This function will convert objects saved to disk to
#' R friendly objects, or the same output as 
#' ComputeEntryWisePerturbationExpectation.
#' If you used the "save to disk" option or ran via python
#' directly, run this function to read the data into R.
#' Files read in: asymptotic_stability.npy, column_names.txt,
#' distributions.pkl, expected_num_switch.csv,
#' num_non_zero.npy, num_switch_funcs.pkl, 
#' row_names.txt and size.npy.
#' Note how most of these objects are python based objects-
#' numpy or pickle objects. 
#' @param matrix path to the original matrix.
#' @param type csv or tab. Is the original matrix comma separated
#' or tab separated? Default: csv
#' @param folder path to the folder where output data was saved.
#' @param prefix optional prefix to file names
#' @return object formatted in the same way the output of 
#' ComputeEntryWisePerturbationExpectation
#' @export
#' @examples 
#' \dontrun{
#' infile <- system.file("extdata", "Modules", "IGP.csv", 
#'     package = "PressPurt")
#' data <- process_data(matrix = infile, 
#'     type = "csv", folder = "output")
#' }
#' @import reticulate

process_data <- function(matrix, type="csv", folder, prefix=NULL){
  np <- reticulate::import("numpy")
  if(type == "csv"){
    if(!is.null(matrix)){
      original_matrix <- as.matrix(read.csv(matrix, header = FALSE))
      colnames(original_matrix) <- 1:ncol(original_matrix)
    } else {
      original_matrix <- matrix
    }
  } else if (type == "tab"){
    if(!is.null(matrix)){
      original_matrix <- as.matrix(read.table(matrix, sep = "\t"))
      colnames(original_matrix) <- 1:ncol(original_matrix)
    } else {
      original_matrix <- matrix
    }
  } else {
    message("Please specify csv file or tab separated file in type")
    stop()
  }
  out_files <- list.files(folder, full.names = TRUE)
  # matrix size
  if(!is.null(prefix)){
    matrix_size <- as.integer(np$load(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_size.npy")]))
  } else {
    matrix_size <- as.integer(np$load(
      out_files[basename(out_files) 
                %in% "size.npy"]))
  }
  # col names
  if(!is.null(prefix)){
    column_names <- as.character(read.table(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_column_names.txt")], sep = '\t')$V1)
  } else {
    column_names <- as.character(read.table(
      out_files[basename(out_files) %in% 
                  "column_names.txt"], sep = '\t')$V1)
  }
  # row names
  if(!is.null(prefix)){
    row_names <- as.character(read.table(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_row_names.txt")], sep = '\t')$V1)
  } else {
    row_names <- as.character(read.table(
      out_files[basename(out_files) %in% 
                  "row_names.txt"], sep = '\t')$V1)
  }
  # non zero
  if(!is.null(prefix)){
    non_zero <- as.integer(np$load(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_num_non_zero.npy")]))
  } else {
    non_zero <- as.integer(np$load(
      out_files[basename(out_files) %in% 
                  "num_non_zero.npy"]))
  }
  # get AS and split into start and stop
  if(!is.null(prefix)){
    asymptotic_stability <- np$load(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_asymptotic_stability.npy")])
  } else {
    asymptotic_stability <- np$load(
      out_files[basename(out_files) %in% 
        "asymptotic_stability.npy"])
  }
  asymptotic_stability_start <- asymptotic_stability[,,1]
  asymptotic_stability_end <- asymptotic_stability[,,2]
  # load num switch funcs
  if(!is.null(prefix)){
    num_switch_functions <- reticulate::py_load_object(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_num_switch_funcs.pkl")])
  } else {
    num_switch_functions <- reticulate::py_load_object(
      out_files[basename(out_files) %in% 
                  "num_switch_funcs.pkl"])
  }
  # convert to R format
  names(num_switch_functions) <- .r_index(
    names = num_switch_functions, to_r = TRUE)
  num_switch_funcs_r <- lapply(names(num_switch_functions), function(x) 
    .NS_func_r(num_switch_funcs = num_switch_functions, name = x))
  names(num_switch_funcs_r) <- names(num_switch_functions)
  # expected num switch
  if(!is.null(prefix)){
    expected_num_switch <- read.csv(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_expected_num_switch.csv")], 
      header = TRUE, row.names = 1)
  } else {
    expected_num_switch <- read.csv(
      out_files[basename(out_files) %in% 
                  "expected_num_switch.csv"], 
      header = TRUE, row.names = 1)
  }
  colnames(expected_num_switch) <- 1:ncol(expected_num_switch)
  rownames(expected_num_switch) <- 1:nrow(expected_num_switch)
  # distributions
  if(!is.null(prefix)){
    distributions <- reticulate::py_load_object(
      out_files[basename(out_files) %in% 
                  paste0(prefix, "_distributions.pkl")])
  } else {
    distributions <- reticulate::py_load_object(
      out_files[basename(out_files) %in% 
                  "distributions.pkl"])
  }
  distributions <- reticulate::py_load_object(out_files[
    grep("distributions.pkl", out_files)])
  names(distributions) <- .r_index(
    names = distributions, to_r = TRUE)
  # get in format
  distributions_object <- lapply(names(distributions), function(x){
    split_name <- unlist(lapply(
      strsplit(gsub("\\(", "", gsub(")", "", x)), ","), as.numeric))
    k <- split_name[1]
    l <- split_name[2]
    single_dist <- get_distributions_single(
      matrix_entry = c(k,l), 
      distribution_list = distributions, 
      asymp_stab = c(asymptotic_stability_start[k,l], 
                     asymptotic_stability_end[k,l]))
    return(single_dist)
  })
  names(distributions_object) <- names(distributions)
  # plot ready Num Switch
  ns_object <- lapply(names(num_switch_funcs_r), function(x){
    split_name <- unlist(lapply(
      strsplit(gsub("\\(", "", gsub(")", "", x)), ","), as.numeric))
    k <- split_name[1]
    l <- split_name[2]
    num_switch_func <- num_switch_funcs_r[
      paste("(", k, ", ", l, ")", sep = '')][[1]]
    ns_step <- ns_to_step(asymp_stab_start = asymptotic_stability_start[k,l],
                          asymp_stab_end = asymptotic_stability_end[k,l],
                          num_switch_func = num_switch_func)
    return(ns_step)
  })
  names(ns_object) <- names(num_switch_funcs_r)
  # place everything in list
  output <- list(original_matrix, matrix_size, 
                 column_names, row_names, non_zero,
                 asymptotic_stability_start,
                 asymptotic_stability_end,
                 num_switch_funcs_r, expected_num_switch, 
                 distributions_object,
                 ns_object)
  names(output) <- c("original_matrix", "matrix_size",
                     "column_names", "row_names",
                     "non_zero", 
                     "asymptotic_stability_start",
                     "asymptotic_stability_end",
                     "num_switch_funcs_r",
                     "expected_num_switch",
                     "distributions_object",
                     "ns_object_plot")
  return(output)
}

############ Helper functions

#' Get PDF distribution
#'
#' This function retrieves the PDF (Probability Distribution Function)
#' object from the scipy method 
#' <scipy.stats._distn_infrastructure.rv_frozen>.
#' @param matrix_entry Position in the matrix. Example: c(1, 1)
#' @param distribution_list list of scipy distributions
#' @param asymp_stab asymptotic stability interval
#' @param points the number of values in x range
#' @export
#' @return Probability Distribution Function from scipy
#' @examples
#' \dontrun{
#' k <- 1
#' l <- 1
#' np <- reticulate::import("numpy")
#' distributions <- reticulate::py_load_object("distributions.pkl")
#' single_dist <- get_distributions_single(matrix_entry = c(k,l), 
#'     distribution_list = distributions, 
#'     asymp_stab = c(combined$asymptotic_stability_start[k,l], 
#'     combined$asymptotic_stability_end[k,l]))
#' }
#' @import reticulate

get_distributions_single <- function(matrix_entry, 
                                     distribution_list, asymp_stab,
                                     points=250){
  np <- reticulate::import("numpy")
  k <- matrix_entry[1]
  l <- matrix_entry[2]
  interval <- asymp_stab
  padding <- (interval[2] - interval[1])/points
  x_range <- np$linspace((interval[1] - padding), (interval[2] + padding), as.integer(points))
  dist.py <- distribution_list[paste("(", k, ", ", l, ")", sep = '')]
  dist_vals <- sapply(x_range, function(x){dist.py[[1]]$pdf(x)})
  ax2 <- data.frame(x_range = as.numeric(x_range), dist_vals = dist_vals)
  out_list <- list(position = c(k, l), interval = interval,
                   distribution = ax2)
  return(out_list)
}


#' Num Switch Function to step function
#'
#' This function transforms a Num Switch Function
#' to a plot ready step function with x and y values.
#' Returns a data frame of x and y values to plot.
#' @param asymp_stab_start start interval from asymptotic_stability
#' @param asymp_stab_end end interval from asymptotic_stability
#' @param num_switch_func a single num switch function
#' @export
#' @return plot ready x and y values from the Num Switch Function
#' @examples
#' \dontrun{
#' # Set input file
#' infile <- system.file("extdata", "Modules", "IGP.csv", 
#'     package = "PressPurt")
#' # Preprocess the matrix
#' PreProsMatrix <- PreprocessMatrix(input_file = infile, 
#'     output_folder = NULL, max_bound = 10, threads = 2)
#'
#' # Run ComputeEntryWisePerturbationExpectation
#' Entrywise <- ComputeEntryWisePerturbationExpectation(
#'     PreProsMatrix = PreProsMatrix,
#'     distribution_type = "truncnorm", 
#'     input_a = 0, input_b = -2, threads = 1)
#' 
#' ns_step <- ns_to_step(
#'     asymp_stab_start = Entrywise$asymptotic_stability_start[1,1],
#'     asymp_stab_end = Entrywise$asymptotic_stability_end[1,1],
#'     num_switch_func = Entrywise$num_switch_funcs_r$`(1, 1)`)
#' }
#' @import reticulate

ns_to_step <- function(asymp_stab_start, asymp_stab_end, 
                       num_switch_func){
  asymp_stab <- c(asymp_stab_start, asymp_stab_end)
  # check if zero is the only num switch values
  if (num_switch_func[1,1] == 0){
    nsx <- asymp_stab
    nsy <- c(0, 0)
    out.df <- data.frame(nsx, nsy)
  } else{
    # check which AS interval is already in NS
    asymp_stab.df <- data.frame("AS" = asymp_stab, 
                                "in_NS" = c(asymp_stab[1] %in% num_switch_func,
                                            asymp_stab[2] %in% num_switch_func))
    AS_to_add <- asymp_stab.df[asymp_stab.df$in_NS == FALSE, 1]
    # check if BOTH the AS intervals are found in the NS func
    if (length(AS_to_add) == 0){
      # y should be increasing in both x directions as you go away from zero
      # ends, first row: start, last row: start
      df.temp <- rbind(cbind(num_switch_func[,3], num_switch_func[,1]), 
                       cbind(num_switch_func[1,2], 0),
                       cbind(num_switch_func[nrow(num_switch_func),2], 
                             num_switch_func[nrow(num_switch_func),1]))
      out.df <- data.frame(df.temp[order(df.temp[,1]),], 
                           row.names = 1:nrow(df.temp))
      colnames(out.df) <- c("nsx", "nsy")
    } else {
      # Need to cap one of the ends w/ other AS interval
      if (abs(num_switch_func[1,3]) - abs(num_switch_func[1,2]) > 0){
        # increasing
        nsx <- c(AS_to_add, num_switch_func[1,2], 
                 num_switch_func[,3]) # AS, start, ends
        nsy <- c(0, 0, num_switch_func[,1])
        out.df <- data.frame(nsx, nsy)
      } else if(abs(num_switch_func[1,3]) - 
                abs(num_switch_func[1,2]) < 0){
        # decreasing
        nsx <- c(AS_to_add, num_switch_func[,3], 
                 num_switch_func[nrow(num_switch_func),2]) # AS, ends, start
        nsy <- c(0, num_switch_func[,1], 
                 num_switch_func[nrow(num_switch_func),1])
        out.df <- data.frame(nsx, nsy)
        out.df <- out.df[order(out.df$nsx),]
      } else{
        message("No change in interval - are we missing test case?")
      }
    }
  }
  return(out.df)
}


# check if file exists

.check_read_file <- function(file_path){
  if(!file.exists(file_path)){
    # check if the file exists
    stop(paste("The file, ", file_path, ", does not appear to exist.", sep = ''))
  }
  tr <- data.table::fread(file_path)
  return(tr)
}

# Helper function for plotting

.grid_helper <- function(n, m, plots){
  # info for grid
  matrix.grid <- data.frame(n=n, m=m, total=n*m)
  # empty matrix for gridExtra::grid.arrange
  empty.grid <- matrix(as.numeric(NA), nrow = matrix.grid$n, ncol = matrix.grid$m)
  # now need to set up matrix position to list name
  layout.matrix <- data.frame(do.call(rbind, strsplit(names(plots), "[.]")))
  colnames(layout.matrix) <- c("rows", "cols")
  layout.matrix$index <- rownames(layout.matrix)
  # change to 1 based index
  layout.matrix$rows.r <- as.numeric(as.character(layout.matrix$rows))
  layout.matrix$cols.r <- as.numeric(as.character(layout.matrix$cols))
  # populate empty.grid
  for(i in 1:nrow(layout.matrix)){
    empty.grid[layout.matrix$rows.r[i], layout.matrix$cols.r[i]] <- as.numeric(layout.matrix$index[i])
    #print(layout.matrix$index[i])
  }
  return(empty.grid)
}

# recombine asymptotic_stability into 1 object

.back_to_array <- function(as_start, as_stop){
  ar <- array(dim = c(nrow(as_start), ncol(as_start), 2))
  ar[,,1] <- as_start
  ar[,,2] <- as_stop
  return(ar)
}

# add 1 (r-based 1) or subtract 1 (python 0 based)

.r_index <- function(names, to_r=TRUE){
  if (to_r == T) {
    index <- 1
  } else if (to_r == FALSE) {
    index <- -1
  } else {
    message("Set to_r to TRUE or FALSE")
  }
  # remove par, split str, convert to num
  remove_par <- gsub("\\(", "", gsub(")", "", names(names)))
  remove_par <- lapply(strsplit(remove_par, ","), as.numeric)
  converted <- lapply(remove_par, function(x){return(x + index)})
  # change back to character vector
  back_ch <- lapply(converted, function(x){
    tel <- paste0("(", x[1], ", ", x[2], ")")
    return(tel)})
  return(unlist(back_ch))
}

# unlist num_switch_funcs

.NS_func_r <- function(num_switch_funcs, name){
  if(length(num_switch_funcs[[name]]) == 0){
    num_test <- matrix(cbind(0, 0, 0), 
                       nrow = 1, ncol = 3)
    rownames(num_test) <- num_test[,1]
    colnames(num_test) <- c("num_switch_val", "start", "end")
  } else {
    num_test <- do.call(rbind, lapply(num_switch_funcs[[name]], unlist))
    rownames(num_test) <- num_test[,1]
    colnames(num_test) <- c("num_switch_val", "start", "end")
  }
  return(num_test)
}
