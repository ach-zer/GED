import { Component, OnInit } from '@angular/core';
import { DocFicheService } from './doc-fiche.service';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { NzModalService } from 'ng-zorro-antd';
import { Router } from '@angular/router';

@Component({
  selector: 'app-doc-fiche',
  templateUrl: './doc-fiche.component.html',
  styleUrls: ['./doc-fiche.component.css']
})
export class DocFicheComponent implements OnInit {

  DESDOCBI = this.doc_acq_service.docName;
  SOUDOCBI = ""
  AUTDOCBI = ""
  NOMBPAGE = ""
  REFDOCBI = ""
  VERDOCBI = ""
  RESDOCBI = ""

  isDocSaved = false;

  constructor(private doc_fiche_service: DocFicheService, private doc_acq_service: DocAcqService, 
    private modal: NzModalService, private router: Router) { }
 

  ngOnInit() {
  }

  showConfirmFiche(): void {
    this.modal.confirm({
      nzTitle: 'Voulez-vous passer au typage ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {
                        this.save();
                        this.router.navigateByUrl('/api/ged/typage')
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
                                    nzTitle: 'Le document chargé n a pas été enregistrer !',
                        });
                        }
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        }
    });
  }

  save(){
    this.doc_fiche_service.DESDOCBI = this.DESDOCBI;
    this.doc_fiche_service.SOUDOCBI = this.SOUDOCBI;
    this.doc_fiche_service.AUTDOCBI = this.AUTDOCBI;
    this.doc_fiche_service.REFDOCBI = this.REFDOCBI;
    this.doc_fiche_service.VERDOCBI = this.VERDOCBI;
    this.doc_fiche_service.RESDOCBI = this.RESDOCBI;
    this.doc_fiche_service.NOMBPAGE = this.NOMBPAGE;
  }

  unsaveDoc(){
    this.doc_acq_service.docName = "";
    this.doc_acq_service.files = [];
  }

}