import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocTypService } from '../doc-typ/doc-typ.service';
import { DocCaraService } from './doc-cara.service';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { NzModalService } from 'ng-zorro-antd';
import { Router } from '@angular/router';
import { DocFicheService } from '../doc-fiche/doc-fiche.service';

@Component({
  selector: 'app-doc-cara',
  templateUrl: './doc-cara.component.html',
  styleUrls: ['./doc-cara.component.css']
})
export class DocCaraComponent implements OnInit {

  selectedType = "";
  nbreCaras = 0;
  isDate = false;

  typeCaras: string[] = [];
  typeCarasToUse: string[] = [];
  typeCodeCara: string[] = [];

  constructor(private http: HttpClient, private doc_typ_Service: DocTypService,
    private doc_cara_service: DocCaraService, private doc_acq_service: DocAcqService, 
    private modal: NzModalService, private router: Router, private doc_fiche_service: DocFicheService) {

  }

  ngOnInit() {
    console.log(this.doc_typ_Service.selectedType);
    this.selectCaraOfChosenType();
    this.doc_cara_service.typeCaraToUse = this.typeCarasToUse;
    //this.doc_cara_service.typeCodeCara = this.typeCodeCara;
  }

  extractCaras() {
    this.typeCaras.forEach(element => {
      this.typeCodeCara.push(element[0]);
      this.typeCarasToUse.push(element[1]);
    });
  }

  selectCaraOfChosenType() {
  
    let gUrl = "http://localhost:8083/api/dc/of/doc/caras";
    if (this.doc_typ_Service.idSelectedType != null) {

    let postData = {"idTypeChosen" : this.doc_typ_Service.idSelectedType};

      this.http.post(gUrl, postData).toPromise().then(resp => {
        let data = JSON.parse(JSON.stringify(resp)).data.caras.data;
        this.typeCaras = data;                             
        this.extractCaras() ;
      });
    }else{
      console.log("Il faut selectionner un type");
    }
  }

  showConfirmCara(): void {
    this.modal.confirm({
      nzTitle: 'Voulez-vous passer au referencement ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {    
                        this.save();               
                        this.router.navigateByUrl('/api/ged/referencement')
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        this.showConfirmIfNo();
                        }
    });
  }

  showConfirmIfNo(){
    this.modal.confirm({
      nzTitle: 'Voulez-vous sauvegarder votre document ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {   
                        let modalSuccess;
                        this.save();

                        if(this.doc_acq_service.idDocInserted != "0"){
                            this.doc_fiche_service.insertDocBin(); //sauvegarde doc + fiche
                            
                            modalSuccess = this.modal.success({
                                      nzTitle: 'Votre document a été sauvegardé !',
                              });
                            setTimeout(() => modalSuccess.destroy(), 5000);
                            this.router.navigateByUrl('/');
                        }else{
                          modalSuccess = this.modal.info({
                            nzTitle: 'Votre document n a pas été sauvegardé',
                          });
                        }                                                                
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        }
    });
  }

  save() {
    let tabCodeAndValueCara: string[] = [];
    let i = 0;
    for (let element of this.typeCarasToUse) {
      //formCaraValues.append(""+element, this[element]+"."+this.typeCodeCara[i]);
      tabCodeAndValueCara.push(this[element] + "." + this.typeCodeCara[i]);
      console.log(this[element] + "." + this.typeCodeCara[i])
      //console.log(formCaraValues.get(""+element));
      i++;
    }
    this.doc_cara_service.tabCodeAndValueCara = tabCodeAndValueCara; // A tab of code and value cara
    console.log(tabCodeAndValueCara); // to show codes and values of caracteristics
  }

  clearType() {
    this.doc_typ_Service.selectedType = "";
    this.doc_typ_Service.idSelectedType = "";
  }
}
