// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/* string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar); */

// Create a list to hold the FlowInput instances
List<PdfExtractorInvocable.FlowInput> inputs = new List<PdfExtractorInvocable.FlowInput>();

// Create a new FlowInput instance and set the caseId
PdfExtractorInvocable.FlowInput input = new PdfExtractorInvocable.FlowInput();
input.caseId = '500Hr00001sbQ2UIAU'; // Replace with the actual Case ID

// Add the FlowInput instance to the list
inputs.add(input);

// Call the extractPdfText method
List<PdfExtractorInvocable.FlowOutput> outputs = PdfExtractorInvocable.extractPdfText(inputs);

// Iterate over the outputs and log the results
for (PdfExtractorInvocable.FlowOutput output : outputs) {
    System.debug('Success: ' + output.success);
    System.debug('Extraction Result: ' + output.extractionResult);
    System.debug('Error Message: ' + output.errorMessage);
}