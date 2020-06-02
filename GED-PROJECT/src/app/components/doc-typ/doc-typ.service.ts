import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { NzModalService } from 'ng-zorro-antd';

@Injectable({
  providedIn: 'root'
})
export class DocTypService {

  selectedType: string = "";
  idSelectedType: string = "";

  typeDocs: string[] = [];//secondary table

  typeDocsToUse: string[] = []; // to introduce the links
  typeIdsDoc: string[] = [];

  constructor(private http: HttpClient, private modal: NzModalService) {}// how to use the constructor
  
  insertTypeDoc(IDEDOCBI: string, TYPE_DOC: string, IDETYPDO: string) {

    let gUrl = "http://localhost:8083/api/dc/of/doc/typage";
    
    var postData = {
        "IDETYPDO"   : IDETYPDO,
        "TYPE_DOC"   : TYPE_DOC,
        "IDEDOCBI"   : ""+IDEDOCBI
        };
        console.log(postData);
    this.http.post(gUrl, postData).subscribe(
      resp => {
        let data = JSON.parse(JSON.stringify(resp));
        console.log(data);
        this.idSelectedType = "";
        this.selectedType = "";

        let modalMsg = this.modal.success({
          nzTitle: 'Le document a été typé !',
        });
        setTimeout(() => modalMsg.destroy(), 3000);
      }
    );  
  }

  selectTypeDoc() {

    this.typeIdsDoc = [];
    this.typeDocs = [];
    this.typeDocsToUse = [];

    let gUrl = "http://localhost:8083/api/dc/of/doc/types";
    this.http.get(gUrl).subscribe(resp => {
      let data = JSON.parse(JSON.stringify(resp)).data.types.data; // We must use the parse method to simplify
      this.typeDocs = data;                             
      this.extractTypes();
    });
  }

  extractTypes() {
    this.typeDocs.forEach(element => {
      this.typeDocsToUse.push(element[0]);
      this.typeIdsDoc.push(element[1]);
    });
  }

  getIdTypeSelected(){
    for(let i = 0; i < this.typeDocsToUse.length; i++){
        if(this.selectedType == this.typeDocsToUse[i]){
          this.idSelectedType = this.typeIdsDoc[i];
          return;
        }
    }
  }


  updateTypeDoc(IDEDOCBI: string, TYPE_DOC: string, IDETYPDO: string) {

    let gUrl = "http://localhost:8083/api/dc/of/doc/retyper";
    
    var postData = {
        "IDETYPDO"   : IDETYPDO,
        "TYPE_DOC"   : TYPE_DOC,
        "IDEDOCBI"   : ""+IDEDOCBI
        };
        console.log(postData);
    this.http.post(gUrl, postData).subscribe(
      resp => {
        let data = JSON.parse(JSON.stringify(resp));
        console.log(data);
        this.idSelectedType = "";
        this.selectedType = "";

        let modalMsg = this.modal.success({
          nzTitle: 'Le type du document a été mis à jour !',
        });
        setTimeout(() => modalMsg.destroy(), 3000);
      }
    );  
  }
  
}
