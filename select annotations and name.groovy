// Get the list of selected annotations
def selectedAnnotations = getSelectedObjects().findAll { it.isAnnotation() }

// Initialize a counter
int counter = 1

// Loop through each selected annotation and rename it
selectedAnnotations.each { annotation ->
    annotation.setName("PIF" + counter)
    counter++
}

// Update the GUI
fireHierarchyUpdate()
