import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay } from "rxjs/operators";
import { NzModalService } from 'ng-zorro-antd';

@Injectable({
  providedIn: 'root'
})
export class DocsAllService {
  
  tabDocsIds = [];
  dataCard = [];
  ideCurrentDoc = "";
  isSpinning = false;
  

  constructor(private http: HttpClient, private modal: NzModalService) { }

  load(): void {
    this.isSpinning = true;
    setTimeout(() => {
      this.isSpinning = false;
    }, 2000);
  }

  selectDocumentsIds(): Observable<any> {

    this.tabDocsIds = []; 
    this.dataCard = [];

    this.load();
  

    let gUrl = "http://localhost:8083/api/dc/of/doc/ids";

    this.http.get(gUrl).toPromise().then(resp => {

      let response = JSON.parse(JSON.stringify(resp)).data.ids;
      let response1 = JSON.parse(JSON.stringify(resp)).data.desdocs;
      
      //Ids
      let response2 = "" + response + "";
      let response3 = response2.substring(0, response2.length - 1).split(',');

      //Names
      let response4 = "" + response1 + "";
      let response5 = response4.substring(0, response4.length - 1).split(',');

      for(let i = 0; i < response3.length;i++){
        if(response3[i] == "undefine" || response3[i] == ""){
          return;
        }
        this.dataCard.push({ idedocbi: response3[i], desdocbi: response5[i] });
      }
    

    console.log(this.dataCard);

    }).catch(resp => {
      
        console.log("Problème au serveur");
  
    });

    return of(this.dataCard).pipe(delay( 2000 ));
  }

  deleteDocument(IDEDOCBI){
    
    let gUrl = "http://localhost:8083/api/dc/of/doc/del";

    let postData = {
          "IDEDOCBI": ""+IDEDOCBI
    } 

    this.http.post(gUrl, postData).subscribe(
      resp => {
        let response = JSON.parse(JSON.stringify(resp));
        console.log(response);
        this.selectDocumentsIds().subscribe(dataCard => this.dataCard = dataCard);
      });

  }

  validateDeleteDocument(IDEDOCBI){
    this.modal.confirm({
      nzTitle: 'Voulez-vous supprimer ce document ?',
      nzOkText: 'Oui',
      nzOkType: 'primary',
      nzOnOk: () => {              
                    let modalMsg;
                    this.deleteDocument(IDEDOCBI);
                    modalMsg = this.modal.success({
                      nzTitle: 'Le document a été supprimé !',
                    });
                    setTimeout(() => modalMsg.destroy(), 3000);
                    
                    return;
          },
      nzCancelText: 'Non',
      nzOnCancel: () => {
              console.log("Quit delete");
              return;
              }
      });
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
        });
      
    }

  }



}
