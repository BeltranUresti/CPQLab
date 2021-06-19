/**
 * Created by Administrador 1 on 05/06/2021.
 */
@IsTest
public with sharing class VS4SF_DocumentDTOTest {
    @IsTest
    public static void testBehavior() {
        Test.startTest();
        StaticResource sr= [SELECT Id, Body FROM StaticResource WHERE Name = 'createDocumentsRequest'];
        String  cd = sr.Body.toString();
        System.debug(cd);
        VS4SF_DocumentDTO.VS4SF_DocumentRequestDTO wrapper = ( VS4SF_DocumentDTO.VS4SF_DocumentRequestDTO) System.JSON.deserialize(cd,  VS4SF_DocumentDTO.VS4SF_DocumentRequestDTO.class);
        //String docCont = wrapper.DocContent;

        Test.stopTest();
    }
}