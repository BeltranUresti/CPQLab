/**
 * Created by Administrador 1 on 06/06/2021.
 */

public without sharing class VIDSignerAdminScreensController {


    @AuraEnabled(Cacheable=true)
    public static List<cpqlab_2020__VIDSigner_Config__mdt> getConfigList(){

        List<cpqlab_2020__VIDSigner_Config__mdt> listOffConfigurations = new  List<cpqlab_2020__VIDSigner_Config__mdt>();
        try {

           for( cpqlab_2020__VIDSigner_Config__mdt VidSigner :[SELECT Id,cpqlab_2020__Aviso_de_privacidad__c,
                   cpqlab_2020__CertificateGUI__c,cpqlab_2020__Correo_administrador__c,
                   cpqlab_2020__environment__c,
                   cpqlab_2020__Es_productivo__c,
                   cpqlab_2020__Language__c,
                   cpqlab_2020__PDF_Empresas__c,
                   cpqlab_2020__PDF_Particular__c,
                   cpqlab_2020__Pin__c,
                   cpqlab_2020__SignatureType__c,
                   cpqlab_2020__subscription_pass__c,
                   cpqlab_2020__subscription_user__c,
                   cpqlab_2020__URL_de_Notificaciones__c
           FROM cpqlab_2020__VIDSigner_Config__mdt]){

               listOffConfigurations.add(VidSigner);
           }

        }catch(Exception e){

        }
        System.debug(listOffConfigurations);
        return  listOffConfigurations;
    }
    @AuraEnabled(Cacheable=true)
    public static List<VIDSignerIntegracion__mdt> getIntegrationList(){

        List<VIDSignerIntegracion__mdt> listIntegracion =   [SELECT Activo__c,
                                                                Autorizacion__c,
                                                                ContentType__c,
                                                                 Metodo__c,
                                                                    Password__c,
                                                                PuntoAcceso__c,
                                                                UserName__c
                                                        FROM
                                                         VIDSignerIntegracion__mdt];

                return listIntegracion;

    }
}