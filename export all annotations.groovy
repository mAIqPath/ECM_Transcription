import qupath.lib.gui.QuPathGUI
import qupath.lib.regions.RegionRequest
import qupath.lib.scripting.QP
import qupath.lib.images.writers.ImageWriterTools

// Define the directory where the TIFF files will be saved
String dir = "D:/SCANS/0-ME-Collagen Project/0- MTC TMAs/MTC validation patients/TIFFs/Case1"

// Ensure the directory exists
new File(dir).mkdirs()

// Define the downsample value
double downsample = 2  // corresponds to 2 pixels (downsample)

// Function to export annotations based on their name
def exportAnnotations(String prefix, String dir, double downsample) {
    // Get the current image data
    def imageData = QP.getCurrentImageData()

    // Get all annotations
    def annotations = QP.getAnnotationObjects()

    // Filter annotations based on the prefix
    annotations.findAll { it.getName().startsWith(prefix) }.each { annotation ->
        // Define the file path for the TIFF
        String path = dir + File.separator + annotation.getName() + ".tif"
        
        // Define the region request
        def regionRequest = RegionRequest.createInstance(imageData.getServerPath(), downsample, annotation.getROI())

        // Export the annotation as a TIFF image
        def server = imageData.getServer()
        def img = server.readBufferedImage(regionRequest)
        
        // Write the image to the specified path
        ImageWriterTools.writeImage(img, path)
    }
}

// Run the export function for each set of annotations
exportAnnotations("TB", dir, downsample)
exportAnnotations("PIF", dir, downsample)
exportAnnotations("DIF", dir, downsample)
