import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { DocTypService } from '../doc-typ/doc-typ.service';
import { DocCaraService } from '../doc-cara/doc-cara.service';
import { DocRefService } from '../doc-ref/doc-ref.service';
import { DocIdenService } from '../doc-iden/doc-iden.service';
import { DocAnnotService } from '../doc-annot/doc-annot.service';

@Injectable({
  providedIn: 'root'
})
export class DocFicheService {

    DESDOCBI: string;
    SOUDOCBI: string;
    AUTDOCBI: string;
    REFDOCBI: string;
    VERDOCBI: string;
    RESDOCBI: string;
    NOMBPAGE: string;
    IDEDOCBI: string;

  constructor(private http: HttpClient, 
              private doc_acq_service: DocAcqService, 
              private doc_typ_service: DocTypService, 
              private doc_cara_service: DocCaraService, 
              private doc_ref_service: DocRefService, 
              private doc_iden_service: DocIdenService, 
              private doc_anno_service: DocAnnotService) {}

   insertFicheDocBin(IDEDOCBI: string) {

    let gUrl = "http://localhost:8083/api/dc/of/doc/fiche";

    
          let postData = {
            "DESDOCBI" : this.DESDOCBI,
            "SOUDOCBI" : this.SOUDOCBI,
            "AUTDOCBI" : this.AUTDOCBI,
            "REFDOCBI" : this.REFDOCBI,
            "VERDOCBI" : this.VERDOCBI,
            "RESDOCBI" : this.RESDOCBI,
            "NOMBPAGE" : ""+this.NOMBPAGE,
            "IDEDOCBI" : ""+IDEDOCBI,
          };

        console.log(postData);
          this.http.post(gUrl, postData).subscribe(
            resp => {
              let data = JSON.parse(JSON.stringify(resp)); //We must use the parse method to simplify
              console.log(data);
            }
          );
  }

  insertDocBin() {

    let formData = new FormData();
    let gUrl = "http://localhost:8083/api/doc/insert";
    formData.append("fileUpload", this.doc_acq_service.files[0]);

    this.http.post(gUrl, formData).subscribe( resp => {

        let IDEDOCBI = JSON.parse(JSON.stringify(resp)).idDocInserted; //We must use the parse method to simplify
        this.doc_acq_service.idDocInserted = IDEDOCBI;
        console.log(this.doc_acq_service.idDocInserted);

      if(this.doc_acq_service.idDocInserted != "0"){
        this.insertFicheDocBin(this.doc_acq_service.idDocInserted);
      }

      if(this.doc_acq_service.idDocInserted != "0" && this.doc_typ_service.selectedType != ""
                && this.doc_typ_service.idSelectedType != ""){
        console.log("Type entered");
        this.doc_typ_service.insertTypeDoc(this.doc_acq_service.idDocInserted, 
          this.doc_typ_service.selectedType, this.doc_typ_service.idSelectedType);
      }

      if(this.doc_acq_service.idDocInserted != "0" && this.doc_cara_service.tabCodeAndValueCara != []){
        this.doc_cara_service.insertCaraDoc(this.doc_acq_service.idDocInserted);
      }

      if(this.doc_acq_service.idDocInserted != "0" && this.doc_ref_service.tabKeyWordsDoc != []){
        this.doc_ref_service.insertRefDoc(this.doc_acq_service.idDocInserted);
      }

      if(this.doc_acq_service.idDocInserted != "0" && this.doc_iden_service.tabValueFieldIden != []
          && this.doc_iden_service.procedure != ""){
        this.doc_iden_service.insertIdenDoc(this.doc_acq_service.idDocInserted);
      }

      if(this.doc_acq_service.idDocInserted!= "0" && this.doc_anno_service.radioValue != ""
                && this.doc_anno_service.TEXTANNO != ""){

              this.doc_anno_service.insertDocAnnotation(this.doc_acq_service.idDocInserted, 
                                    this.doc_anno_service.TEXTANNO, this.doc_anno_service.radioValue);
      }


    });
 }
}
