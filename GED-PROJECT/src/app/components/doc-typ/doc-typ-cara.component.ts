import { Component, OnInit,} from '@angular/core';
import { DocTypService } from './doc-typ.service';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { NzModalService } from 'ng-zorro-antd';
import { Router } from '@angular/router';
import { DocFicheService } from '../doc-fiche/doc-fiche.service';

@Component({
  selector: 'app-doc-typ-cara',
  templateUrl: './doc-typ-cara.component.html',
  styleUrls: ['./doc-typ-cara.component.css']
})
export class DocTypCaraComponent implements OnInit {
  
  selectedType = "";
  //typeDocs: string[] = []; //secondary table

  //typeDocsToUse: string[] = [];
  //typeIdsDoc: string[] = [];

  constructor(private doc_typ_service: DocTypService,
         private doc_fiche_service: DocFicheService, private modal: NzModalService, 
         private router: Router, private doc_acq_service: DocAcqService) {
           this.selectedType = "";
           this.doc_typ_service.idSelectedType = ""
           this.doc_typ_service.selectedType = ""
          }

  ngOnInit() {
    this.doc_typ_service.selectTypeDoc();
  }

  onChangeTypes(selectedType: string) {
    console.log(selectedType);
    this.doc_typ_service.selectedType = selectedType;
    this.doc_typ_service.getIdTypeSelected();
    console.log(this.doc_typ_service.idSelectedType);
  }

  /* getIdTypeSelected(){
    for(let i = 0; i < this.typeDocsToUse.length; i++){
        if(this.selectedType == this.typeDocsToUse[i]){
          this.doc_typ_service.idSelectedType = this.typeIdsDoc[i];
          return;
        }
    }
  } */

  /* selectTypeDoc() {
    let gUrl = "http://localhost:8083/api/dc/of/doc/types";
    this.http.get(gUrl).subscribe(resp => {
      let data = JSON.parse(JSON.stringify(resp)).data.types.data; // We must use the parse method to simplify
      this.typeDocs = data;                             
      this.extractTypes() ;
    });
  }

  extractTypes() {
    this.typeDocs.forEach(element => {
      this.typeDocsToUse.push(element[0]);
      this.typeIdsDoc.push(element[1]);
    });
  } */

  showConfirmType(): void {
    this.modal.confirm({
      nzTitle: 'Voulez-vous passer à la caractérisation ?',
      nzOkText: 'Yes',
      nzOkType: 'primary',
      nzOnOk: () => {                      
                        this.router.navigateByUrl('/api/ged/caracterisation')
                    },
      nzCancelText: 'No',
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
                        
                        if(this.doc_acq_service.idDocInserted != "0"){

                            this.doc_fiche_service.insertDocBin(); // sauvegarde doc + fiche
                            
                            modalSuccess = this.modal.success({
                                    nzTitle: 'Votre type choisi a été sauvegardé !',
                            });
                            setTimeout(() => modalSuccess.destroy(), 5000);
                            this.router.navigateByUrl('/');
                        }else {
                            modalSuccess = this.modal.error({
                                    nzTitle: 'Votre type choisi n a pas été sauvegardé',
                            });
                        }
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        }
    });
  }

  save(){
    //this.insertTypeDoc();
  }
}
