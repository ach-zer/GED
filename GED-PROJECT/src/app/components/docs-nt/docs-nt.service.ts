import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { delay } from "rxjs/operators";
import { Observable, of } from 'rxjs';
import { NzModalService } from 'ng-zorro-antd';

@Injectable({
  providedIn: 'root'
})
export class DocsNtService {

  tabDocsIds = [];
  dataCard = [];
  isSpinning = false;
  idedocbiSelected = "";

  constructor(private http: HttpClient, private modal: NzModalService) { }

  selectDocumentsIds(): Observable<any> {

    this.tabDocsIds = [];
    this.dataCard = [];
    this.load();

    let gUrl = "http://localhost:8083/api/dc/of/docs/nonType";

    this.http.get(gUrl).toPromise().then(resp => {
      let response = JSON.parse(JSON.stringify(resp)).data.ids;
      let response1 = JSON.parse(JSON.stringify(resp)).data.desdocs;
      console.log(response1);
      
      //Ids 
      let response2 = "" + response + "";
      let response3 = response2.substring(0, response2.length - 1).split(',');

      //Names
      let response4 = "" + response1 + "";
      let response5 = response4.substring(0, response4.length - 1).split(',');

      for(let i = 0; i < response3.length;i++){
        if(response3[i] == "undefine"){
          return;
        }
        this.dataCard.push({ idedocbi: response3[i], desdocbi: response5[i] });
      }

      console.log(this.dataCard);

    });

    return of(this.dataCard).pipe(delay( 1500 ));

  }

  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }

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
        
        let modalMsg = this.modal.success({
          nzTitle: 'Le document a été typé !',
        });
        setTimeout(() => modalMsg.destroy(), 3000);

        this.selectDocumentsIds().subscribe(dataCard => this.dataCard = dataCard);
      }
    );  
  }

  insertRefDoc(IDEDOCBI, tags){
    let gUrl = "http://localhost:8083/api/dc/of/doc/referencement";


    for (let i = 1; i < tags.length; i++) {
        let postData = {
            "IDEDOCBI"  :  ""+IDEDOCBI,
            "MOT_CLE"   :  tags[i]
          };

        this.http.post(gUrl, postData).subscribe(
          resp => {
            let data = JSON.parse(JSON.stringify(resp));
            console.log(data)
            tags = [];

            let modalMsg = this.modal.success({
              nzTitle: 'Le document a été référencé !',
            });
            setTimeout(() => modalMsg.destroy(), 3000);
        });
      
    }

  }

}
