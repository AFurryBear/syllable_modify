# veitlab-vis

## requirement

### Node.js and related
1. Node.js, you can [DOWNLOAD HERE](https://nodejs.org/en/download/)
2. After download it, install some package
'''
npm install fs --save
npm install express --save
npm install path --save
npm install child_process --save
'''
### python3

make sure these packages are installed: numpy, pandas, json
'''
pip install numpy
pip install pandas
pip install json
'''

## steps

### step 1: prepare data
	xyr_prepare_csv(inpath, outpath)
	inpath is a folder path containing  "batch.keep". 
	outpath is a output folder path.  
	
	
### step 2: start rendering
	cd to veitlab_vis; 
	use code 'node xyr_data_modify.js' to render
	
### optional step: prepare data_folder for visualize
	 cd to veitlab_vis; 
	 python3 .\py\xyr_data_prepare.py UMAP_PATH(*.csv) SYLMAT_PATH(*.csv) OUTPUT_PATH(folder)
	 mv OUTPUT_PATH/data veitlab_vis/;

### step 3: view in browser
	type localhost:8080 in any browser (chrome and firefox are recommended)
	[if didn't finish the optional step] upload output files in step1 and wait for 1-2 mins (processing time)
	[finish optional step]: click Use data in folder to start immediately
	modify labeling data and click to download changed umap results


	
