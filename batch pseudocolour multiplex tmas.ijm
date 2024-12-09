macro "Identify and Process Common TMA Cores" {
    baseDir = "F:/SCANS/0-ME-Collagen Project/Marta/Analysis pMLC2-MLC2/Melanoma_qupath/multiplex/";
    saveDir = "F:/SCANS/0-ME-Collagen Project/Marta/Analysis pMLC2-MLC2/Melanoma_qupath/multiplex/Multiplex/";
    dir1 = baseDir + "pMLC2/";
    dir2 = baseDir + "MLC2/";
    dir3 = baseDir + "panmelan/";

    // Get the list of image files from each directory
    list1 = getFileList(dir1);
    list2 = getFileList(dir2);
    list3 = getFileList(dir3);

    // Initialize an array for common filenames
    commonFiles = newArray(0); // Initialize an empty array
    commonFilesIndex = 0; // Manually manage array index

    for (i = 0; i < list1.length; i++) {
        fileName = list1[i];
        if (endsWith(fileName, ".tif") && isInList(fileName, list2) && isInList(fileName, list3)) {
            commonFiles[commonFilesIndex++] = fileName; // Direct assignment to the array at the new index
        }
    }

    // Process each common file
    for (i = 0; i < commonFilesIndex; i++) {
        fileName = commonFiles[i];
        
        // Open images from each staining directory
        open(dir1 + fileName);
        open(dir2 + fileName);
        open(dir3 + fileName);

        // Stack images
        run("Images to Stack", "name=Stack title=[] use");
        run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");
        rename("aligned");

        // Split stack into individual images
        run("Stack to Images");
        
        // Apply Colour Deconvolution to each separated image, then close specific channels
        for (j = 1; j <= 3; j++) {
            selectWindow("aligned-000" + j);
            run("Colour Deconvolution", "vectors=[H AEC]");
            selectWindow("aligned-000" + j + "-(Colour_3)");
            close();
        }
        
        // Rename the remaining window to 'nuclei' for the third image
        selectWindow("aligned-0003-(Colour_1)");
        rename("nuclei");
        
        // Merge remaining channels from each image and apply further processing
        selectWindow("aligned-0001-(Colour_2)");
        rename("pMLC2");
        selectWindow("aligned-0002-(Colour_2)");
        rename("MLC2");
        selectWindow("aligned-0003-(Colour_2)");
        rename("panmelan");
        run("Merge Channels...", "c2=pMLC2 c3=nuclei c6=MLC2 c7=panmelan create ignore");
        run("Invert");
        Stack.setDisplayMode("color");
        
        // Adjust channel settings
        Stack.setChannel(3);
        setMinAndMax(73, 255);
        Stack.setChannel(2);
        setMinAndMax(59, 255);
        Stack.setChannel(1);
        setMinAndMax(70, 247);
        Stack.setDisplayMode("composite");

        // Save the processed image
        saveFileName = fileName.replace(".tif", " composite.tif");
        saveAs("Tiff", saveDir + saveFileName);
        close("*");  // Close all images to clean up
    }
}

// Helper function to check if a filename is in a list
function isInList(fileName, list) {
    for (index = 0; index < list.length; index++) {
        if (list[index] == fileName) {
            return true;
        }
    }
    return false;
}

