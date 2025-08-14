public with sharing class ExtractPdfCallout {
    public static final String API_KEY = 'API KEY FROM AI STUDIO';
    // Method to perform the HTTP callout
    public static String makeCallout(String base64File) {
        // Create a new HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:streamGenerateContent?key='+API_KEY);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        // Construct the JSON body
        String requestBody = '{"contents":[{"role":"user","parts":[{"text":"Extract all information from this document image into a JSON format. For the JSON keys, do not use spaces; use an underscore `_` instead."},{"inlineData":{"mimeType":"application/pdf","data":"' + base64File + '"}}]}],"generationConfig":{"responseMimeType":"application/json"}}';
        
        req.setBody(requestBody);
        req.setTimeout(60000);
        
        // Create a new HTTP object and send the request
        Http http = new Http();
        HttpResponse res;
        try {
            res = http.send(req);
            // Check the response status code
            if (res.getStatusCode() == 200) {
                String textParts = '';
                List<ExtractionResponse> responseWraper = (List<ExtractionResponse>)System.JSON.deserialize(res.getBody(), List<ExtractionResponse>.class);
                for (ExtractionResponse item : responseWraper) {
                    if (item.candidates != null && !item.candidates.isEmpty()) {
                        ExtractionResponse.Candidate cand = item.candidates[0];
                        if (cand.content != null && cand.content.parts != null && !cand.content.parts.isEmpty()) {
                            textParts += cand.content.parts[0].text;
                        }
                    }
                }
                return textParts;
            } else {
                // Handle non-200 status codes
                System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
                return null;
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }
}