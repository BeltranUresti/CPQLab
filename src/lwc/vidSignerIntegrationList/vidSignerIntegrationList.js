/**
 * Created by Administrador 1 on 06/06/2021.
 */

import {LightningElement, track, wire, api} from 'lwc';
import logoStaticResource from '@salesforce/resourceUrl/VDJSS_validated_white';
import getConfigList from '@salesforce/apex/VIDSignerAdminScreensController.getConfigList';


export default class VidSignerIntegrationList extends LightningElement {
    @track logoUTM = logoStaticResource;
    @api recordId;
    @track showSpinner = true;
    @track isLoaded = false;

    @wire(getConfigList)
   getListOfConfigList(result){
        console.log(result);
        if(result.data){
            console.log(this.recordId);
            this.recordId =result.data[0].Id;
            this.isLoaded = true;
            this.showSpinner = false;

        }
    }



    connectedCallback() {

    }



}