import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { DocCaraService } from '../doc-cara/doc-cara.service';
import { DocRefService } from './doc-ref.service';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { NzModalService } from 'ng-zorro-antd';
import { Router } from '@angular/router';
import { DocFicheService } from '../doc-fiche/doc-fiche.service';


@Component({
  selector: 'app-doc-ref',
  templateUrl: './doc-ref.component.html',
  styleUrls: ['./doc-ref.component.css']
})
export class DocRefComponent implements OnInit {

  nbreRefs = 0;
  typeRef1: string[] = [];
  typeRef: string[] = [];
  typeRefToUse: string[] = [];

  constructor(private doc_cara_service: DocCaraService,
    private doc_ref_service: DocRefService, private doc_acq_service: DocAcqService, 
    private modal: NzModalService, private router: Router, private doc_fiche_service: DocFicheService) {
      this.nbreRefs = 0;
      this.typeRef1 = [];
      this.typeRef = [];
      this.typeRefToUse = []
     }

  ngOnInit() {

  }

  /* extractRef() {
    for (var element of this.typeRef1) {
      let typerefSp = element.split(":")[1]; //
      let typerefSub = typerefSp.substring(1, typerefSp.length - 1); // to delete ""
      console.log(typerefSub);
      this.typeRefToUse.push(typerefSub);

      //extract Cara
      //var caracterisation = typecaraSub.substring(0, indexOfPoint);
      //console.log(caracterisation);
      //this.typeCaraToUse.push(caracterisation);

    }
  } */

  /*  selectRefTypeChosen() {
     var gUrl = "http://localhost:8080/api/ged/refType/:IDETYPDO";
 
     if (this.doc_typ_service.idSelectedType != null) {
 
       var params = new HttpParams()
         .set('IDETYPDO', this.doc_typ_service.idSelectedType)
 
       this.http.get(gUrl, { params }).toPromise().then(resp => {
         var lgt = JSON.stringify(resp).length;
         this.nbreRefs = lgt;
         this.typeRef1 = JSON.stringify(resp).substring(1, lgt - 1).split(",");
         console.log(JSON.stringify(resp));
         this.extractRef();
       });
 
     } else {
       console.log("Il faut déjà avoir un type");
     }
   } */

  tags = ['Insert key words of your document'];
  inputVisible = false;
  inputValue = '';

  @ViewChild('inputElement', { static: false }) inputElement: ElementRef;

  handleClose(removedTag: {}): void {
    this.tags = this.tags.filter(tag => tag !== removedTag);
  }

  sliceTagName(tag: string): string {
    const isLongTag = tag.length > 40;
    return isLongTag ? `${tag.slice(0, 40)}...` : tag;
  }

  showInput(): void {
    this.inputVisible = true;
    setTimeout(() => {
      this.inputElement.nativeElement.focus();
    }, 10);
  }

  handleInputConfirm(): void {
    if (this.inputValue && this.tags.indexOf(this.inputValue) === -1) {
      this.tags = [...this.tags, this.inputValue];
    }
    this.inputValue = '';
    this.inputVisible = false;
  }

  // To clear an array of caracteristics
  cleartabCodeAndValueCara() {
    this.doc_cara_service.tabCodeAndValueCara = [];
    this.doc_ref_service.tabKeyWordsDoc = [];
  }


  showConfirmRefe(): void {
    this.modal.confirm({
      nzTitle: 'Voulez-vous passer à l identification ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {
                        this.saveKeyWords();
                        this.router.navigateByUrl('/api/ged/identification')
                    },
      nzCancelText: 'Non',
      nzOnCancel: () => {
                        this.showConfirmIfNo();
                        }
    });
  }

  showConfirmIfNo(){
    this.modal.confirm({
      nzTitle: 'Voulez-vous sauvegarder votre document chargé ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {   
                        let modalSuccess;
                        this.saveKeyWords();
                        
                        if(this.doc_acq_service.idDocInserted != "0"){

                            this.doc_fiche_service.insertDocBin(); // sauvegarde doc + fiche
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

  saveKeyWords() {

    this.doc_ref_service.tabKeyWordsDoc = [] // To reset the old list

    for (let i = 1; i < this.tags.length; i++) {

      this.doc_ref_service.tabKeyWordsDoc.push(this.tags[i]);
    }
    console.log(this.doc_ref_service.tabKeyWordsDoc);
   
  }
}