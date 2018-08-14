public with sharing class BRPSGCDocListRespContainer 
{
    public class DocumentListResponse 
    {
        public List<UploadedList> uploadedList;
        public List<List<RequiredList>> requiredList;
        public List<RequiredList> optionalList;
    }

    public DocumentListResponse documentListResponse;

    public class RequiredList 
    {
        public String docType;
        public String formType;
        public String description;
    }

    public class UploadedList implements Comparable 
    {
        public String fileName;
        public String fileType;
        public String docType;
        public String formType;
        public String uploadType;
        public String receiveDate;
        public String docStatus;
    
        public Integer compareTo(Object compareTo) 
        {
            UploadedList compareToDoc = (UploadedList)compareTo;
            if (Datetime.valueOf(receiveDate) == Datetime.valueOf(compareToDoc.receiveDate))   return 0;
            if (Datetime.valueOf(receiveDate) < Datetime.valueOf(compareToDoc.receiveDate))    return 1;       return -1;       
        }    
    }
    
    public static BRPSGCDocListRespContainer parse(String json) 
    {
        return (BRPSGCDocListRespContainer) System.JSON.deserialize(json, BRPSGCDocListRespContainer.class);
    }    
}