// First obtain the input folder by asking the user to enter a pre-existing folder path where only raw image files are present. 
InputFolder = "/Users/Nireekshit/Desktop/Pandorum/LiverTeam/NASHAnalysis2/WSI";


// Next obtain the output folder by asking the user to enter a pre-existing folder path. 
OutputFolder =  "/Users/Nireekshit/Desktop/Pandorum/LiverTeam/NASHAnalysis2/WSIAnalysis"; // This is the folder where you want to save your data. 

list = getFileList(InputFolder);

l = lengthOf(list);

for (j = 0; j < l; j++) {

open(""+InputFolder+"/"+list[j]);

ImageName = getTitle();
ImageName = substring(ImageName,0,lengthOf(ImageName)-4); // Removes .tif from the end
NewFolderPath = "" +OutputFolder +"/" +ImageName;
File.makeDirectory(NewFolderPath); 
print(NewFolderPath); // Prints the folder name of every image that is processed. 

run("*Split Channels [F1]");

for (i = 0; i < 2; i++) {
	
    Name = getTitle();
    run("Duplicate...", "title=[Original] duplicate");
    print(Name);
    selectWindow(Name);
    Ind = indexOf(Name,"C1");

	// If it is DAPI channel image we process to find nuclei. 
    
    if(Ind >= 0){
    run("Gaussian Blur...", "sigma=2 stack");
    setAutoThreshold("MaxEntropy dark");
    run("Threshold...");
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=MaxEntropy background=Dark calculate");
    run("Invert LUT");
    run("Watershed", "stack");
    run("Analyze Particles...", "size=20-600 circularity=0.6-1.00 exclude add stack");
    close();}

    // For other 2 channels we use a different approach.
    
    else { 
    run("Gaussian Blur...", "sigma=2 stack");
    setAutoThreshold("Moments dark");
    run("Threshold...");
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=Moments background=Dark calculate");
    run("Invert LUT");
    run("Watershed", "stack");
    run("Analyze Particles...", "size=5-Infinity circularity=0-1 exclude add stack");
    close();
    }
    
    Name = substring(Name,0,lengthOf(Name)-4);
    ROIString = "" +NewFolderPath +"/" +Name  +".zip" ; 
    ResultsString = "" +NewFolderPath +"/" +Name +".txt";
    print(ROIString);
    print(ResultsString);
    roiManager("Save", ROIString);
    roiManager("show none");
    selectWindow("Original");
    roiManager("measure");    
    selectWindow("Results"); 
    saveAs("Results", ResultsString);
    close("Original");
    selectWindow("Results"); 
    run("Close"); 
    selectWindow("ROI Manager"); 
    run("Close"); 
}

}







