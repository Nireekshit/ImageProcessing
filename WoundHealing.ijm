// This Macro can be used to manually draw ROI's, get measurements and save those measurements based on the specific image name. 


// First obtain the output folder by asking the user to enter a pre-existing folder path. 
OutputFolder = getString("Enter the folder path where you want to store the analysis", "User/Desktop/Pandorum/"); // This is the folder where you want to save your data. 

// Next, enter the folder which has to be analyzed. For example you might want to process the 0 h time point. That should contain only the image files to be analyzed. 
InputFolder = getString("Enter the folder path which you want to process", "User/Desktop/Pandorum/"); 

// Next enter the total number of treatments present in the 0 h time point folder. Example, DMF, EVD and so on. Match this to image names. 
NoT = getNumber("NumberOfTreatments?", 10);

// print("The number of treatments you entered is =", NoT); 
// waitForUser("Please confirm that you have entered correct number of treatments");
// run("Close");

i = 0; TreatmentNames = newArray(NoT); AnalysisFolders = newArray(NoT);

while (i < NoT) {	
      TreatmentNames[i] = getString("Please enter exact name of the treatment as in the image name", "NAIVE?"); 
      AnalysisFolders[i] = OutputFolder + "/" + TreatmentNames[i]; 
      File.makeDirectory(AnalysisFolders[i]);            
      i++;
}

print("The treatment names are");
Array.print(TreatmentNames); // This is just to check that we have entered treatment names correctly. 

waitForUser("Please confirm treatment names and press okay"); // Extra confirmation. Can be commented out. 
run("Close");

list = getFileList(InputFolder);
// This command will get the list of files in the directory. 

n = lengthOf(list); 
// This command will obtain the total number of files in the directory. 

i = 0;


// The next "while" loop will go through each image, ask the user to draw ROIs, add them to the ROI manager. It automatically saves the 
// results of this ROI into a .csv file in a folder named according to the treatment. For example, results from 0 h, field 1 of DMF treatment
// go to the folder called DMF. 

while (i < n) {
	  // print(list[i]); // Will print the exact image name we are processing Iincluding the extension. 
	  open(""+InputFolder+"/"+list[i]);
	  ImgName = File.nameWithoutExtension;
	  // print(ImgName); // Will print the exact image name we are processing without extension. 
	  waitForUser("Draw required number of ROI in image, add each to ROI manager and press okay"); 
      roiManager("measure"); // This step will output a results table. 
     
      
      // Now we have to decide where to save this. 
      
      j = 0;
      
      while (j < NoT) {
      	    // print(j);            
            res = ImgName.startsWith(TreatmentNames[j]); // We use this to save the result to the correct folder. 
            // print(res); 
            
            if (res == "true") {
             // print("Will be saved as", ""+AnalysisFolders[j]+"/"+ImgName+".xls");	
             saveAs("Results",""+AnalysisFolders[j]+"/"+ImgName+".csv");
             selectWindow("Results"); 
             run("Close"); 
             selectWindow("ROI Manager"); 
             run("Close"); 
             close("*");             
            }
            j = j + 1;  
      }
      i = i+1;
}

print("Congratulations ! Analysis of current data set complete");







 