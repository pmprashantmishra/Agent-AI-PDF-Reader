public with sharing class PdfExtractorInvocable {
    
    /**
     * Wrapper class to accept input from Flow
     */
    public class FlowInput {
        @InvocableVariable(label='Case Record ID' required=true description='ID of the Case record with PDF attachment')
        public String caseId;
    }
    
    /**
     * Wrapper class to return output to Flow
     */
    public class FlowOutput {
        @InvocableVariable(label='Extraction Result' description='JSON response from the PDF extraction')
        public String extractionResult;
        
        @InvocableVariable(label='Success' description='Whether the extraction was successful')
        public Boolean success;
        
        @InvocableVariable(label='Error Message' description='Error message if extraction failed')
        public String errorMessage;
    }
    
    /**
     * Invocable method to extract text from PDF attachments on a Case
     * @param inputs List of FlowInput containing Case IDs
     * @return List of FlowOutput containing extraction results
     */
    @InvocableMethod(label='Extract Text from PDF' description='Extracts text from PDF attachments on a Case')
    public static List<FlowOutput> extractPdfText(List<FlowInput> inputs) {
        List<FlowOutput> outputs = new List<FlowOutput>();
        
        FlowInput input = inputs.get(0);
        FlowOutput output = new FlowOutput();
        output.success = false;
        
        try {
            // Query ContentDocumentLink to find documents linked to the Case
            List<ContentDocumentLink> contentLinks = [
                SELECT ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :input.caseId
            ];
            
            if (contentLinks.isEmpty()) {
                output.errorMessage = 'No documents found attached to the Case';
                outputs.add(output);
            }
            
            // Query ContentVersion to get the latest version of PDF files
            List<ContentVersion> contentVersions = [
                SELECT Id, VersionData, FileExtension, Title
                FROM ContentVersion
                WHERE ContentDocumentId = :contentLinks.get(0).ContentDocumentId
                AND FileExtension = 'pdf'
                AND IsLatest = true
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
            
            if (contentVersions.isEmpty()) {
                output.errorMessage = 'No PDF files found attached to the Case';
                outputs.add(output);
            }
            
            // Get the first PDF file (most recent)
            ContentVersion cv = contentVersions[0];
            
            // Convert the Blob to Base64 string
            String base64Data = EncodingUtil.base64Encode(cv.VersionData);
            
            // Call the ExtractPdfCallout class to process the PDF
            String calloutResponse = ExtractPdfCallout.makeCallout(base64Data);
            
            if (calloutResponse != null) {
                output.extractionResult = calloutResponse;
                output.success = true;
            } else {
                output.errorMessage = 'Failed to extract text from PDF';
            }
            
        } catch (Exception e) {
            output.errorMessage = 'Error: ' + e.getMessage() + ' - ' + e.getStackTraceString();
        }
        
        outputs.add(output);
        return outputs;
    }
}