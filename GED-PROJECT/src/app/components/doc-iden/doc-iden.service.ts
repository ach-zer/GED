import { Injectable } from '@angular/core';
import { DocAcqService } from '../doc-acq/doc-acq.service';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class DocIdenService {

  // To identify the document
  tabValueNameFieldIden: string[] = []; // To save data in the table GED_CLIENTS
  tabNameFieldIden: string[] = [];
  tabValueFieldIden: string[] = [];
  procedure: string = "";
  idClientInserted : string;

  constructor(private http: HttpClient, private doc_acq_service: DocAcqService) { }

  insertIdenDoc(IDEDOCBI) {

    let gUrl = "http://localhost:8083/api/dc/of/doc/identification";

      let postData = {                    
        "procedure"  : this.procedure,
        "IDEDOCBI"   : ""+IDEDOCBI,
        "DOCNAME"    : this.doc_acq_service.docName,
        "NOM"        : this.tabValueFieldIden[0],
        "PRENOM"     : this.tabValueFieldIden[1]
      };

      console.log(postData);
      this.http.post(gUrl, postData).subscribe(resp => {
        let data1 = JSON.parse(JSON.stringify(resp)); // data from the procedure
        console.log(data1);
        //this.doc_acq_service.idDocInserted = "0";
        this.procedure = "";
        this.tabValueFieldIden = [];
        //this.idClientInserted = data1.data.idClient; // Id of the inserted document
      });
    }
}
