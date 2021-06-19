/**
 * Created by Administrador 1 on 05/06/2021.
 */

public with sharing class VIDSignerIntegrationService {
    public static String endpointSub {get; set;}
    public static String authorizationHeader {get; set;}

    public static HttpResponse getHTTPResponse( String jsonContentStr, String APIname, String endpointSubArg ){
        endpointSub = endpointSubArg;
        return getHTTPResponse( APIname, jsonContentStr);
    }

    public static HttpResponse getHTTPResponse(String apiName, String jsonContentStr)
    {

        HTTPResponse response;
        String endpointStr = null;
        String userNameAuthStr = '';
        String passwordAuthStr = '';

        for (VIDSignerIntegracion__mdt IntVid : [SELECT Id,
                Activo__c,
                Metodo__c,
                ContentType__c,
                PuntoAcceso__c,
                Autorizacion__c,
                UserName__c,
                Password__c
        FROM VIDSignerIntegracion__mdt
        WHERE  Activo__c = true and DeveloperName =: apiName]) {

            endpointStr = IntVid.PuntoAcceso__c;
            userNameAuthStr =  IntVid.UserName__c;
            passwordAuthStr =  IntVid.Password__c;

            if(endpointSub != null){
                endpointStr += endpointSub;
                endpointSub = null;
            }
            if(userNameAuthStr  != '' && userNameAuthStr  != null){
                Blob headerValue = Blob.valueOf(userNameAuthStr + ':' + passwordAuthStr);
                authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            }

            System.debug('ENCONTRO METADATA CONN');
            HttpRequest req = new HttpRequest();
            req.setMethod(IntVid.Metodo__c);
            req.setHeader('Content-Type', IntVid.ContentType__c);
            if (authorizationHeader!= '' && authorizationHeader != null){
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Accept', '*/*');
            }
            req.setEndpoint(endpointStr);
            if (jsonContentStr !='' && jsonContentStr != null){
                req.setBody(jsonContentStr);
            }
            req.setTimeout(60000);

            Http http = new Http();
            response = http.send(req);
            system.debug('/ / / response.getStatusCode(): ' + response.getStatusCode());
            system.debug('/ / / response.getBody(): ' + response.getBody());
            system.debug('/ / / response: ' + response);

        }
        return response;
    }
}