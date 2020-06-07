import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocIdenService } from './doc-iden.service';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { NzModalService } from 'ng-zorro-antd';
import { Router } from '@angular/router';
import { DocFicheService } from '../doc-fiche/doc-fiche.service';

@Component({
  selector: 'app-doc-iden',
  templateUrl: './doc-iden.component.html',
  styleUrls: ['./doc-iden.component.css']
})
export class DocIdenComponent implements OnInit {

  nbreFieldIden = 0;
  tabFieldIden: string[] = [];
  tabFieldIdenToUse: string[] = [];
  CLAARCH = "";

  constructor(private http: HttpClient, private doc_iden_service: DocIdenService, 
              private doc_acq_service: DocAcqService, 
              private modal: NzModalService, 
              private router: Router, private doc_fiche_service: DocFicheService) { 

                this.tabFieldIden = [];
                this.tabFieldIdenToUse = [];
                this.CLAARCH = "";

              }

  ngOnInit() {
    //this.selectFieldIdentification();
  }

  selectFieldsIdenChoiceClass(){
    console.log(this.CLAARCH);
    this.doc_iden_service.CLAARCH = this.CLAARCH;
    this.selectFieldIdentification();
  }


  extractFieldIden() {
    this.tabFieldIden.forEach(element => {
      if (element != "IDCLIENT" && element != "IDCOMPA")
        this.tabFieldIdenToUse.push(element);
    });
  }

  selectFieldIdentification() {
    this.tabFieldIdenToUse = [];
    var gUrl = "http://localhost:8083/api/dc/of/doc/iden";


    let postData = {"CLAARCH" : this.CLAARCH};


    this.http.post(gUrl, postData).toPromise().then(resp => {
      let data = JSON.parse(JSON.stringify(resp)).data.fields.data;
      this.tabFieldIden = data;
      this.extractFieldIden();
    });
  }

  showConfirmIden(): void {
    this.modal.confirm({
      nzTitle: 'Voulez-vous passer à l annotation ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {
                        this.save();
                        this.router.navigateByUrl('/api/ged/annotation');
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        this.showConfirmIfNo();
                        }
    });
  }

  showConfirmIfNo(){
    this.modal.confirm({
      nzTitle: 'Voulez-vous sauvegarder le document chargé ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {   
                        let modalSuccess;
                        this.save(); //Add an operation
                        
                        if(this.doc_acq_service.idDocInserted != "0"){

                            this.doc_fiche_service.insertDocBin(); //sauvegarde doc + fiche
                            modalSuccess = this.modal.success({
                                    nzTitle: 'Le document chargé a été sauvegardé !',
                            });
                            setTimeout(() => modalSuccess.destroy(), 5000);
                            this.router.navigateByUrl('/');
                        } else {
                              modalSuccess = this.modal.info({
                                    nzTitle: 'Le document chargé n a pas été enregistré !',
                          });
                          this.doc_iden_service.tabValueFieldIden = [];
                        }
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        }
    });
  }

  save() {
    let tabNameFieldIden: string[] = [];
    let tabValueFieldIden: string[] = [];
    let i = 0;

    let procedure1;

    if(this.CLAARCH == "personne"){

      procedure1 = "insert into GED_CLIENTS (";

    }else if (this.CLAARCH == "compagnie"){

      procedure1 = "insert into GED_COMPAGNIES (";

    }

    
    let procedure2 = ") VALUES (";

    for (let element of this.tabFieldIdenToUse) {

      tabNameFieldIden.push("" + this.tabFieldIdenToUse[i]);
      let elem = ""+this[element]+"";
      let elemLowerCase = elem.toLowerCase();
      console.log(elemLowerCase);
      tabValueFieldIden.push(elemLowerCase);

      procedure1 = procedure1 + this.tabFieldIdenToUse[i] + ",";
      procedure2 = procedure2 + "'" + elemLowerCase + "'" + ","

      i++;
    }

    let procedure3 = procedure1.substring(0, procedure1.length - 1)
      + procedure2.substring(0, procedure2.length - 1) + ")";

    console.log(procedure3);

    this.doc_iden_service.tabNameFieldIden = tabNameFieldIden;
    this.doc_iden_service.tabValueFieldIden = tabValueFieldIden;
    this.doc_iden_service.procedure = procedure3;   // To save and send to oracle if not exists

    console.log(this.doc_iden_service.procedure);
  }
}
