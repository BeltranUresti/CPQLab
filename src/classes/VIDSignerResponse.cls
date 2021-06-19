/**
 * Created by Administrador 1 on 05/06/2021.
 */

public without sharing class VIDSignerResponse {
    public String FileName {get;set;}
    public String DocGUI {get;set;}
    public String DocStatus {get;set;}
    public Boolean Downloaded {get;set;}
    public String AdditionalData {get;set;}
    public List<Signers> Signers {get;set;}

    public class Signers {
        public String SignerGUI { get; set; }
        public String SignerName { get; set; }
        public String SignatureStatus { get; set; }
        public Object RejectionReason { get; set; }
        public String TypeOfID { get; set; }
        public String NumberID { get; set; }
        public Object UserNoticesInfo { get; set; }
        public Object FormInfo { get; set; }
        public String OperationTime { get; set; }
        public Signers(){

        }
    }
}