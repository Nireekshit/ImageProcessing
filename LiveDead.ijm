// This macro can be used to count the the number of stained nuclei in channel 1 and channel 3 of a z stack image. The output for every image is a folder 
// that contains the ROI for each channel and also a text file with the ROI results for every channel. 

// First obtain the input folder by asking the user to enter a pre-existing folder path where only raw image files are present. 
InputFolder = "/Users/Nireekshit/Desktop/Pandorum/LiverTeam/NASHAnalysis2/LiveDead"; 


// Next obtain the output folder by asking the user to enter a pre-existing folder path. 
OutputFolder =  "/Users/Nireekshit/Desktop/Pandorum/LiverTeam/NASHAnalysis2/LDAnalysis"; // This is the folder where you want to save your data. 

list = getFileList(InputFolder); // obtains the list of images in the folder. 

l = lengthOf(list);

for (j = 0; j < l; j++) {

open(""+InputFolder+"/"+list[j]);

ImageName = getTitle(); // gets image title
ImageName = substring(ImageName,0,lengthOf(ImageName)-4); // Removes .tif from the end
NewFolderPath = "" +OutputFolder +"/" +ImageName;
File.makeDirectory(NewFolderPath); // Creates a new folder with the name of the image. 
print(NewFolderPath); // Prints the folder name of every image that is processed. 

run("*Split Channels [F1]");
close('C2*'); // We dont need channel 2. So close it. 

for (i = 0; i < 2; i++) {
	
    Name = getTitle(); 
    run("Duplicate...", "title=[Original] duplicate"); 
    print(Name);
    selectWindow(Name);
    run("Gaussian Blur...", "sigma=2 stack"); // Use this to remove sharp edges when thresholding. 
    setAutoThreshold("MaxEntropy dark"); // Type of thresholding method can be changed. 
    run("Threshold...");
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=MaxEntropy background=Dark calculate");
    run("Invert LUT");
    run("Watershed", "stack"); // Watershed algorithm will divide larger nuclei clusters into smaller parts. 
    run("Analyze Particles...", "size=20-300 circularity=0.75-1.00 exclude add stack"); // The values can be adjusted to get the desired ROIs. 
    close();
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







