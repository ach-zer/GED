import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocAnnotService } from './doc-annot.service';
import { NzModalService } from 'ng-zorro-antd';
import { Router } from '@angular/router';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { DocFicheService } from '../doc-fiche/doc-fiche.service';

@Component({
  selector: 'app-doc-annot',
  templateUrl: './doc-annot.component.html',
  styleUrls: ['./doc-annot.component.css']
})
export class DocAnnotComponent implements OnInit {

  
  radioValue = "";
  TEXTANNO = "";

  constructor( 
              private doc_annot_service: DocAnnotService,
              private modal: NzModalService, 
              private router: Router, 
              private doc_acq_service: DocAcqService, 
              private doc_fiche_service: DocFicheService) { 

                this.radioValue = "";
                this.TEXTANNO = "";
              }

  ngOnInit() {
    this.doc_annot_service.selectTypesAnnotations();
  }

  

  showConfirmAnno(){
    this.modal.confirm({
      nzTitle: 'Voulez-vous sauvegarder le document chargé ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {   
                        let modalSuccess;
                        this.saveAnnotation(); //Add an operation
                        
                        if(this.doc_acq_service.idDocInserted != "0"){

                            this.doc_fiche_service.insertDocBin(); // sauvegarde doc + fiche
                            modalSuccess = this.modal.success({
                                    nzTitle: 'Le document chargé a été sauvegardé !',
                            });
                            setTimeout(() => modalSuccess.destroy(), 5000);
                            this.router.navigateByUrl('/');
                        } else {
                              modalSuccess = this.modal.info({
                                    nzTitle: 'Le document chargé n a pas été enregistré !',
                        });
                        }
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        }
    });
  }

  saveAnnotation() {
    console.log(this.radioValue);
    console.log(this.TEXTANNO);
    this.doc_annot_service.TEXTANNO = this.TEXTANNO;
    this.doc_annot_service.radioValue = this.radioValue;
  }

  cancel(){
    this.doc_annot_service.TEXTANNO = ""; // Unsave the text annotation
    this.doc_annot_service.radioValue = ""; 
  }

  
}