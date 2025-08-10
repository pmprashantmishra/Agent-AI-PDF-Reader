public with sharing class ExtractionResponse {
    public List<Candidate> candidates;
    public UsageMetadata usageMetadata;
    public String modelVersion;
    public String responseId;
    
    /* public List<Response> responses;

    public class Response {
        public List<Candidate> candidates;
        public UsageMetadata usageMetadata;
        public String modelVersion;
        public String responseId;
    } */

    public class Candidate {
        public Content content;
        public Integer index;
        public String finishReason;
        public CitationMetadata citationMetadata;
    }

    public class Content {
        public List<Part> parts;
        public String role;
    }

    public class Part {
        public String text;
    }

    public class UsageMetadata {
        public Integer promptTokenCount;
        public Integer candidatesTokenCount;
        public Integer totalTokenCount;
        public List<PromptTokensDetail> promptTokensDetails;
        public Integer thoughtsTokenCount;
    }

    public class PromptTokensDetail {
        public String modality;
        public Integer tokenCount;
    }

    public class CitationMetadata {
        public List<CitationSource> citationSources;
    }

    public class CitationSource {
        public Integer startIndex;
        public Integer endIndex;
        public String uri;
        public String license;
    }
}